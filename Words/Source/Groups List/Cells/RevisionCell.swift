//
//  RevisionCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 12/03/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class RevisionCell: UITableViewCell
{
    @IBOutlet var titleLabel: UILabel!


    override func awakeFromNib()
    {
        super.awakeFromNib()
    }


    func setup(withLanguage language: Language)
    {
        let count = WordsDataSource.sharedInstance.revisionWordsCount(forLanguage: language)
        titleLabel.text = "\(count) Words"
    }
}
