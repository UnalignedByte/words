//
//  WordConfigCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 15/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class WordConfigCell: UITableViewCell
{
    static var identifier: String {
        get {
            return "WordConfigCell"
        }
    }
    static var configChangedCallback: ((Int) -> Void)?

    @IBOutlet var gradientView: UIView!


    override func awakeFromNib()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.lightGray.withAlphaComponent(0.1).cgColor]
        gradientLayer.locations = [0.2, 1.0]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }


    @IBAction func visibilitySegmentChanged(sender: UISegmentedControl)
    {
        if let callback = WordConfigCell.configChangedCallback {
            callback(sender.selectedSegmentIndex)
        }
    }
}
