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
    static let sharedInstance = WordsDataSource()

    private var model: NSManagedObjectModel!
    private var storeCoordinator: NSPersistentStoreCoordinator!
    private var persistentStore: NSPersistentStore!
    private var context: NSManagedObjectContext!

    init()
    {
        self.setupModel()
        self.setupStoreCoordinator()
        self.setupContext()
    }


    private func setupModel()
    {
        //let modelUrl = Bundle.main.url(forResource: "WordsModel", withExtension: "momd")
        self.model = NSManagedObjectModel.mergedModel(from: [Bundle.main])
        //self.model = NSManagedObjectModel.init(contentsOf: modelUrl!)
    }


    private func setupStoreCoordinator()
    {
        self.storeCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.model)

        do {
            try self.persistentStore = self.storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                                                        configurationName: nil,
                                                                                        at: nil,
                                                                                        options: nil)
        } catch {
            abort()
        }
    }


    private func setupContext()
    {
        self.context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.storeCoordinator
    }


    private func entityName(forLanguageCode languageCode: String) -> String
    {
        let entityForCode = ["cn" : "ChineseWord"]

        if entityForCode[languageCode] != nil {
            return entityForCode[languageCode]!
        }

        return "Word"
    }


    func newWord(languageCode: String) -> Word
    {
        let entityName = self.entityName(forLanguageCode: languageCode)
        let word = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! Word

        var randomNumber: Int32 = 0
        arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
        word.order = NSNumber(value: randomNumber)
        word.languageCode = languageCode

        return word
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
