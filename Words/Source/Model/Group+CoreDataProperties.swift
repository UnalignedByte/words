//
//  Group+CoreDataProperties.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Group
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group");
    }

    @NSManaged public var languageCode: String
    @NSManaged public var name: String
    @NSManaged public var order: Int32
    @NSManaged public var words: NSSet
}


// MARK: Generated accessors for words
extension Group
{
    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)
}
