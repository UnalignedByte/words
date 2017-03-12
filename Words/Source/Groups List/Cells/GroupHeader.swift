//
//  GroupHeader.swift
//  Words
//
//  Created by Rafal Grodzinski on 14/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class GroupHeader: UITableViewHeaderFooterView
{
    @IBOutlet private var label: UILabel!
    @IBOutlet private var gradientView: UIView!
    private var callback: (() -> Void)!


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


    func setup(withLanguage language: Language, callback: @escaping () -> Void)
    {
        self.label.text = NSLocalizedString(language.code, comment: "Language Name")
        self.callback = callback
    }


    @IBAction func didSelect(sender: UIButton)
    {
        self.callback()
    }
}
