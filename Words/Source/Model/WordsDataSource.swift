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


    func loadWords(fromFile file: String)
    {
        var file = file

        // Remove trailing .plist from filename (if present)
        if let range = file.range(of: ".plist") {
            if range.upperBound == file.endIndex {
                file = file.replacingCharacters(in: range, with: "")
            }
        }

        for bundle in Bundle.allBundles {
            if let plistUrl = bundle.url(forResource: file, withExtension: "plist") {
                if let groups = NSArray(contentsOf: plistUrl) as? Array<Dictionary<String,Any>> {
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


    /*
    func hanziCount() -> Int
    {
        do {
            try self.context.save()
        } catch {

        }

        let fetchRequest: NSFetchRequest<ChineseWord> = NSFetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "ChineseWord", in: self.context)
        fetchRequest.entity = entityDescription

        var count = 0

        do {
            let result = try self.context.fetch(fetchRequest)
            let chineseResult = result 

            //let chin = chineseResult[0]
            //chin.hanzi.characters.map{$0}
            //chin.hanzi.characters.map{String($0)}

            //let chineseSet = [chineseResult.map{$0.hanzi.characters.map{$0}}]
            var hanziSet = Set<String>()

            let hanziAr = chineseResult.map{$0.hanzi}

            for hanzi in hanziAr {
                let hanzis = hanzi.characters.map{String($0)}
                for hanz in hanzis {
                    hanziSet.insert(hanz)
                }
            }

            ///let chineseSet = chineseResult.map{$0.hanzi.characters.map{String($0)}}

            count = hanziSet.count
        } catch {
            
        }
        
        return count
    }*/
}
