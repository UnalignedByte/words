//
//  Word+CoreDataProperties.swift
//  Words
//
//  Created by Rafal Grodzinski on 02/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word");
    }

    @NSManaged public var groupName: String?
    @NSManaged public var languageCode: String?
    @NSManaged public var order: NSNumber?
    @NSManaged public var translation: String?
    @NSManaged public var word: String?

}
