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


    func loadWords(fromFilePath filePath: String)
    {
        if let groups = NSArray(contentsOfFile: filePath) as? Array<Dictionary<String,Any>> {
            for groupDict in groups {
                let languageCode = groupDict["languageCode"] as? String
                guard languageCode != nil else {
                    continue
                }
                let language = Language(rawValue: languageCode!)
                let groupName = groupDict["group"] as? String
                let wordDicts = groupDict["words"] as? [Dictionary<String, String>]

                guard languageCode != nil && groupName != nil && wordDicts != nil else {
                    continue
                }

                let group = newGroup(forLanguage: language!)
                group.name = groupName!

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


    // MARK: - Public Functions
    @objc func saveContext()
    {
        if self.context.hasChanges {
            do {
                try context.save()
            } catch let error {
                fatalError("Context saving error: \(error)")
            }
        }
    }


    // MARK: - Groups
    func newGroup(forLanguage language: Language) -> Group
    {
        let group = Group(context: self.context)
        group.language = language
        let maxGroupOrder = self.maxGroupOrder(forLanguage: language)
        group.order = maxGroupOrder + 1

        return group
    }


    func groups(forLanguage language: Language) -> [Group]
    {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", language.code)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        if let fetchResults = try? self.context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Group]()
    }


    func groupsCount(forLanguage language: Language) -> Int
    {
        return groups(forLanguage: language).count
    }


    func delete(group: Group)
    {
        self.context.delete(group)
    }


    func deleteGroups(forLanguage language: Language)
    {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", language.code)

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
        let word = NSEntityDescription.insertNewObject(forEntityName: group.language.wordEntity, into: context) as! Word
        let maxWordOrder = self.maxWordOrder(forGroup: group)
        word.order = maxWordOrder + 1

        group.addToWords(word)

        return word
    }


    func words(forLanguage language: Language) -> [Word]
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", language.code)

        if let fetchResults = try? self.context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Word]()
    }


    func wordsCount(forLanguage language: Language) -> Int
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", language.code)

        if let count = try? self.context.count(for: fetchRequest) {
            return count
        }
        
        return 0
    }


    func revisionWords(forLanguage language: Language) -> [Word]
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode = '\(language.code)' AND isInRevision = 'TRUE'")

        if let fetchResults = try? context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Word]()
    }


    func revisionWordsCount(forLanguage language: Language) -> Int
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group.languageCode = '\(language.code)' AND isInRevision = 'TRUE'")

        if let count = try? context.count(for: fetchRequest) {
            return count
        }

        return 0
    }


    func delete(word: Word)
    {
        self.context.delete(word)
    }


    func deleteWords(forLanguage language: Language)
    {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", language.code)

        let fetchResults = try? self.context.fetch(fetchRequest)

        if let fetchResults = fetchResults {
            for word in fetchResults {
                self.context.delete(word)
            }
        }
        // TODO: This should be done with NSBatchDeleteRequest
    }


    func deleteWords(forGroup group: Group)
    {
        for word in group.words {
            self.context.delete(word as! NSManagedObject)
        }
    }


    // MARK: - Fetch Requests
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


    func fetchRequestWords(forLanguage language: Language) -> NSFetchRequest<Word>
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.fetchBatchSize = 10

        fetchRequest.predicate = NSPredicate(format: "group.languageCode == %@", language.code)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "group.name", ascending: false),
                                        NSSortDescriptor(key: "order", ascending: false)]

        return fetchRequest
    }


    // MARK: - Private Utils
    fileprivate func newWord(forGroup group: Group, wordDict: Dictionary<String, String>)
    {
        let word = newWord(forGroup: group)
        word.word = wordDict["word"]!
        word.translation = wordDict["translation"]!

        switch group.languageCode {
            case "cn":
                (word as! ChineseWord).pinyin = wordDict["pinyin"]!
            default:
                break
        }
    }

    private func maxGroupOrder(forLanguage language: Language) -> Int32
    {
        let orderExp = NSExpression(forKeyPath: #keyPath(Group.order))
        let maxOrderExp = NSExpression(forFunction: "max:", arguments: [orderExp])
        let maxOrderExpDesc = NSExpressionDescription()
        maxOrderExpDesc.name = "maxOrder"
        maxOrderExpDesc.expression = maxOrderExp
        maxOrderExpDesc.expressionResultType = .integer32AttributeType

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Group")
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", language.code)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [maxOrderExpDesc]

        var maxGroupOrder = Int32(0)

        do {
            let results = try context.fetch(fetchRequest)
            let resultsDict = results.first!
            maxGroupOrder = resultsDict["maxOrder"] as! Int32
        } catch let error {
            fatalError("Context fetch error: \(error)")
        }

        return maxGroupOrder
    }


    private func maxWordOrder(forGroup group: Group) -> Int32
    {
        let orderExp = NSExpression(forKeyPath: #keyPath(Word.order))
        let maxOrderExp = NSExpression(forFunction: "max:", arguments: [orderExp])
        let maxOrderExpDesc = NSExpressionDescription()
        maxOrderExpDesc.name = "maxOrder"
        maxOrderExpDesc.expression = maxOrderExp
        maxOrderExpDesc.expressionResultType = .integer32AttributeType

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "group = %@", group)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [maxOrderExpDesc]

        var maxWordOrder = Int32(0)

        do {
            let results = try context.fetch(fetchRequest)
            let resultsDict = results.first!
            maxWordOrder = resultsDict["maxOrder"] as! Int32
        } catch let error {
            fatalError("Context fetch error: \(error)")
        }

        return maxWordOrder
    }
}
