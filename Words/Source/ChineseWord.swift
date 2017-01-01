//
//  ChineseWord.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import Foundation
import CoreData


class ChineseWord: NSManagedObject
{
    @NSManaged var order: Int32
    @NSManaged var groupName: String
    @NSManaged var english: String
    @NSManaged var pinyin: String
    @NSManaged var hanzi: String
}