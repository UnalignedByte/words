//
//  WordsDataSource.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import Foundation
import CoreData


class WordsDataSource
{
    // MARK: - Public Properties
    static let sharedInstance = WordsDataSource()

    var context: NSManagedObjectContext {
        get {
            return storeContainer.viewContext
        }
    }

    // MARK: - Private Properties
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WordsModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {

            }
        }
        return container
    }()


    // MARK: - Initialization
    private init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(saveContext),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: self.context)
    }


    // MARK: - Public Control
    @objc func saveContext()
    {
        if self.context.hasChanges {
            do {
                try self.storeContainer.viewContext.save();
            } catch let error {
                print("Context saving error: \(error)")
            }
        }
    }


    // MARK: - Groups
    func newGroup(forLanguageCode code: String) -> Group
    {
        let group = Group(context: self.context)
        group.languageCode = code

        let orderExp = NSExpression(forKeyPath: #keyPath(Group.order))
        let maxOrderExp = NSExpression(forFunction: "max:", arguments: [orderExp])
        let maxOrderExpDesc = NSExpressionDescription()
        maxOrderExpDesc.name = "maxOrder"
        maxOrderExpDesc.expression = maxOrderExp
        maxOrderExpDesc.expressionResultType = .integer32AttributeType

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Group")
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", code)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [maxOrderExpDesc]

        var maxGroupOrder = Int32(0)

        do {
            let results = try context.fetch(fetchRequest)
            let resultsDict = results.first!
            maxGroupOrder = resultsDict["maxOrder"] as! Int32
        } catch let error {
            print("Context fetch error: \(error)")
        }

        group.order = maxGroupOrder + 1

        return group
    }


    func groups(forLanguageCode code: String) -> [Group]
    {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", code)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        if let fetchResults = try? self.context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Group]()
    }


    func groupsCount(forLanguageCode code: String) -> Int
    {
        // TODO: The same comment applies as in languageCodesCount

        return groups(forLanguageCode: code).count
    }


    func delete(group: Group)
    {
        self.context.delete(group)
    }


    func deleteAllGroups(forLanguageCode code: String)
    {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", code)

        let fetchResults = try? self.context.fetch(fetchRequest)

        if let fetchResults = fetchResults {
            for group in fetchResults {
                self.context.delete(group)
            }
        }
        // TODO: This should be done with NSBatchDeleteRequest
    }


    // MARK: - Words
    func newWord(forGroup group: Group) -> Word
    {
        let word = Word(context: self.context)
        var randomNumber = Int32(0)
        arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
        word.order = randomNumber

        group.addToWords(word)

        return word
    }


    func words(forLanguageCode languageCode: String) -> [Word]
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", languageCode)

        if let fetchResults = try? self.context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Word]()
    }


    func wordsCount(forLanguageCode languageCode: String) -> Int
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", languageCode)

        if let count = try? self.context.count(for: fetchRequest) {
            return count
        }
        
        return 0
    }


    func delete(word: Word)
    {
        self.context.delete(word)
    }


    func deleteAllWords(forLanguageCode languageCode: String)
    {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()

        let fetchResults = try? self.context.fetch(fetchRequest)

        if let fetchResults = fetchResults {
            for word in fetchResults {
                self.context.delete(word)
            }
        }
        // TODO: This should be done with NSBatchDeleteRequest
    }


    func deleteAllWords(forGroup group: Group)
    {
        if let words = group.words {
            for word in words {
                self.context.delete(word as! NSManagedObject)
            }
        }
    }


    func loadWords(fromFilePath filePath: String)
    {
        if let groups = NSArray(contentsOfFile: filePath) as? Array<Dictionary<String,Any>> {
            for groupDict in groups {
                let languageCode = groupDict["languageCode"] as? String
                let groupName = groupDict["group"] as? String
                let wordDicts = groupDict["words"] as? [Dictionary<String, String>]

                guard languageCode != nil && groupName != nil && wordDicts != nil else {
                    continue
                }

                let group = newGroup(forLanguageCode: languageCode!)
                group.name = groupName

                for wordDict in wordDicts! {
                    newWord(forGroup: group, wordDict: wordDict)
                }
            }
        }
    }


    func loadAllSharedFiles()
    {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                      FileManager.SearchPathDomainMask.userDomainMask,
                                                                      true)
        let documentDirectoryPath = documentDirectories.first!

        if let documentFiles = try? FileManager.default.contentsOfDirectory(atPath: documentDirectoryPath) {
            for documentFile in documentFiles {
                let filePath = documentDirectoryPath + "/" + documentFile

                loadWords(fromFilePath: filePath)
                try? FileManager.default.removeItem(atPath: filePath)
            }
        }
    }


    func loadWords(fromBundledFile file: String)
    {
        var file = file

        // Remove trailing .plist from filename (if present)
        if let range = file.range(of: ".plist") {
            if range.upperBound == file.endIndex {
                file = file.replacingCharacters(in: range, with: "")
            }
        }

        for bundle in Bundle.allBundles {
            if let plistFilePath = bundle.path(forResource: file, ofType: "plist") {
                loadWords(fromFilePath: plistFilePath)
            }
        }
    }


    func fetchRequestGroups() -> NSFetchRequest<Group>
    {
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        fetchRequest.fetchBatchSize = 10

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "languageCode", ascending: true),
                                        NSSortDescriptor(key: "order", ascending: true)]

        return fetchRequest
    }

    func fetchRequestWords(forGroup group: Group) -> NSFetchRequest<Word>
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.fetchBatchSize = 10

        fetchRequest.predicate = NSPredicate(format: "group == %@", group)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        return fetchRequest
    }


    func fetchRequestWords(forLanguageCode languageCode: String) -> NSFetchRequest<Word>
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.fetchBatchSize = 10

        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", languageCode)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "group.name", ascending: false),
                                        NSSortDescriptor(key: "order", ascending: false)]

        return fetchRequest
    }


    // MARK: - Private Utils
    private func entityName(forLanguageCode code: String) -> String
    {
        let entityForCode = ["cn" : "ChineseWord"]

        if entityForCode[code] != nil {
            return entityForCode[code]!
        }

        return "Word"
    }


    private func newWord(forGroup group: Group, wordDict: Dictionary<String, String>)
    {
        let word = newWord(forGroup: group)
        word.word = wordDict["word"]
        word.translation = wordDict["translation"]

        switch group.languageCode! {
            case "cn":
                (word as! ChineseWord).pinyin = wordDict["pinyin"]
            default:
                break
        }
    }
}
