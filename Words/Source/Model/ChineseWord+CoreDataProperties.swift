//
//  ChineseWord+CoreDataProperties.swift
//  Words
//
//  Created by Rafal Grodzinski on 03/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import Foundation
import CoreData


extension ChineseWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChineseWord> {
        return NSFetchRequest<ChineseWord>(entityName: "ChineseWord");
    }

    @NSManaged public var pinyin: String?

}
