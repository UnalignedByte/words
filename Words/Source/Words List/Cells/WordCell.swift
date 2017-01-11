//
//  WordCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 11/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class WordCell: UITableViewCell
{
    static var languageCode: String {
        get {
            return "banana"
        }
    }
    static var identifier: String {
        get {
            return "WordCell"
        }
    }


    func setup(withWord word: Word)
    {
    }
}
