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
    static var identifier: String {
        get {
            return "GroupCell"
        }
    }

    @IBOutlet private var groupLabel: UILabel!
    @IBOutlet private var wordsCountLabel: UILabel!
    @IBOutlet private var gradientView: UIView!


    override func awakeFromNib()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors = [UIColor.lightGray.withAlphaComponent(0.1).cgColor,
                                UIColor.lightGray.withAlphaComponent(0.25).cgColor]
        gradientLayer.locations = [0.2, 1.0]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }


    func setup(withGroup group: Group)
    {
        self.groupLabel.text = group.name
        let wordsCount = group.words?.count
        if wordsCount == 1 {
            self.wordsCountLabel.text = "1 Word"
        } else {
            self.wordsCountLabel.text = "\(wordsCount) Words"
        }
    }
}
