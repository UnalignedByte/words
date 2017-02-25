//
//  Group+CoreDataClass.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


@objc(Group)
public class Group: NSManagedObject
{
    var language: Language {
        get { return Language(rawValue: languageCode)! }
        set { languageCode = newValue.code }
    }
}
