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
            return "en"
        }
    }
    static var identifier: String {
        get {
            return "WordCell"
        }
    }

    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var translationLabel: UILabel!
    @IBOutlet var gradientView: UIView!


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


    func setup(withWord word: Word)
    {
        self.wordLabel.text = word.word
        self.translationLabel.text = word.translation
    }
}
