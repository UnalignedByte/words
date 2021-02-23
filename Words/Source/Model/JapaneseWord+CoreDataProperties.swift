//
//  JapaneseWord+CoreDataProperties.swift
//  Words
//
//  Created by Rafał Grodziński on 23/02/2021.
//  Copyright © 2021 UnalignedByte. All rights reserved.
//

import Foundation
import CoreData


extension JapaneseWord
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JapaneseWord> {
        return NSFetchRequest<JapaneseWord>(entityName: "JapaneseWord");
    }

    @NSManaged public var yomikata: String
}
