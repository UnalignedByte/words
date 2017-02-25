//
//  ChineseWord+CoreDataProperties.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ChineseWord
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChineseWord> {
        return NSFetchRequest<ChineseWord>(entityName: "ChineseWord");
    }

    @NSManaged public var pinyin: String
}
