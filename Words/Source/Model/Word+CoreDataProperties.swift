//
//  Word+CoreDataProperties.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Word
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word");
    }

    @NSManaged public var order: Int32
    @NSManaged public var translation: String
    @NSManaged public var word: String
    @NSManaged public var group: Group
}
