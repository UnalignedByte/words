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
    }


    // MARK: - Public Control
    func newWord(forLanguageCode code: String) -> Word
    {
        //let entityName = self.entityName(forLanguageCode: code)
        //let word = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! Word

        let word = Word(context: self.context)
        word.languageCode = code

        var randomNumber = Int32(0)
        arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
        word.order = NSNumber(value: randomNumber)

        do {
            try self.storeContainer.viewContext.save();
        } catch let error {
            print("Error: \(error)")
        }

        return word
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
        for property in fetchResults! {
            languageCodes.append(property.object(forKey: "languageCode") as! String)
        }

        // TODO: Can't get this to work :(
        //let languageCodes: [String] = fetchResults.map{$0.object(forKey: "languageCode") as! String}

        return languageCodes
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


    /*func groupNames() -> [String]
    {
        let fetchRequest: NSFetchRequest<ChineseWord> = NSFetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "ChineseWord",
                                                                  in: self.context)!
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "groupName", ascending: true)]

        var allWords: [ChineseWord]!
        do {
            allWords = try self.context.fetch(fetchRequest)
        } catch {
        }

        var groupNames = Array<String>()

        for word in allWords {
            if !groupNames.contains(word.groupName) {
                groupNames.append(word.groupName)
            }
        }

        return groupNames
    }


    func wordsCount() -> Int
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
            let chineseSet = Set(chineseResult.map{$0.english})
            count = chineseSet.count
        } catch {

        }

        return count
    }


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
