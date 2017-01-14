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


    func newWord(forLanguageCode code: String, group: String) -> Word
    {
        let word = Word(context: self.context)
        word.languageCode = code
        word.group = group

        var randomNumber = Int32(0)
        arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
        word.order = randomNumber

        return word
    }


    func loadWords(fromFilePath filePath: String)
    {
        if let groups = NSArray(contentsOfFile: filePath) as? Array<Dictionary<String,Any>> {
            for groupDict in groups {
                let languageCode = groupDict["languageCode"] as? String
                let group = groupDict["group"] as? String
                let wordDicts = groupDict["words"] as? [Dictionary<String, String>]

                guard languageCode != nil && group != nil && wordDicts != nil else {
                    continue
                }

                for wordDict in wordDicts! {
                    newWord(forLanguageCode: languageCode!, group: group!, wordDict: wordDict)
                }
            }
        }
    }


    func loadAllSharedFiles()
    {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                      FileManager.SearchPathDomainMask.userDomainMask,
                                                                      true)

        if let documentFilePaths = try? FileManager.default.contentsOfDirectory(atPath: documentDirectories.first!) {
            for documentFilePath in documentFilePaths {
                loadWords(fromFilePath: documentDirectories.first! + "/" + documentFilePath)
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


    // MARK: - Public Utils
    func deleteAllWords()
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


    func languageCodes() -> [String]
    {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Word")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["languageCode"]
        fetchRequest.returnsDistinctResults = true

        let fetchResults = try? self.context.fetch(fetchRequest)

        // Extract just the codes into an array
        var languageCodes = [String]()
        if let fetchResults = fetchResults {
            for property in fetchResults {
                languageCodes.append(property.object(forKey: "languageCode") as! String)
            }
        }

        // TODO: Can't get this to work :(
        //let languageCodes: [String] = fetchResults.map{$0.object(forKey: "languageCode") as! String}

        return languageCodes
    }


    func languageCodesCount() -> Int
    {
        // TODO: Ideally it would be implemented using NManagedObject.count
        // or with NSExpression, but I'm not sure how to get it done

        return languageCodes().count
    }


    func groups(forLanguageCode code: String) -> [String]
    {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Word")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["group"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = NSPredicate(format: "languageCode = %@", code)

        let fetchResults = try? self.context.fetch(fetchRequest)

        // Extract just the groups into an array
        var groups = [String]()
        if let fetchResults = fetchResults {
            for property in fetchResults {
                groups.append(property.object(forKey: "group") as! String)
            }
        }

        return groups
    }


    func groupsCount(forLanguageCode code: String) -> Int
    {
        // TODO: The same comment applies as in languageCodesCount

        return groups(forLanguageCode: code).count
    }


    func words(forLanguageCode languageCode: String, group: String) -> [Word]
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "languageCode == %@ AND group == %@", languageCode, group)

        if let fetchResults = try? self.context.fetch(fetchRequest) {
            return fetchResults
        }

        return [Word]()
    }


    func wordsCount(forLanguageCode languageCode: String, group: String) -> Int
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "languageCode == %@ AND group == %@", languageCode, group)

        if let count = try? self.context.count(for: fetchRequest) {
            return count
        }

        return 0
    }


    func fetchRequest(forLanguageCode languageCode: String, group: String? = nil) -> NSFetchRequest<Word>
    {
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.fetchBatchSize = 10

        // Only words in a given group
        if let group = group {
            fetchRequest.predicate = NSPredicate(format: "languageCode == %@ AND group == %@", languageCode, group)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        // All words for given language code
        } else {
            fetchRequest.predicate = NSPredicate(format: "languageCode == %@", languageCode)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "group", ascending: true),
                                            NSSortDescriptor(key: "order", ascending: true)]
        }

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


    private func newWord(forLanguageCode languageCode: String, group: String, wordDict: Dictionary<String, String>)
    {
        let word = newWord(forLanguageCode: languageCode, group: group)
        word.word = wordDict["word"]
        word.translation = wordDict["translation"]

        switch languageCode {
            case "cn":
                (word as! ChineseWord).pinyin = wordDict["pinyin"]
            default:
                break
        }
    }
}
