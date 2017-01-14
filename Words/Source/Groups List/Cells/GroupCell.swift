//
//  GroupCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 13/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class GroupCell: UITableViewCell
{
    @IBOutlet private var nameLabel: UILabel!

    static var identifier: String {
        get {
            return "GroupCell"
        }
    }


    func setup(withName name: String)
    {
        self.nameLabel.text = name
    }
}
