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
    @IBOutlet private var groupLabel: UILabel!
    @IBOutlet private var wordsCountLabel: UILabel!
    @IBOutlet private var gradientView: UIView!


    override func awakeFromNib()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: gradientView.bounds.height)
        gradientLayer.colors = [UIColor.lightGray.withAlphaComponent(0.1).cgColor,
                                UIColor.lightGray.withAlphaComponent(0.25).cgColor]
        gradientLayer.locations = [0.2, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }


    func setup(withGroup group: Group)
    {
        groupLabel.text = group.name
        wordsCountLabel.text = String(format: NSLocalizedString("%d Word(s)", comment: ""), group.words.count)
    }
}
