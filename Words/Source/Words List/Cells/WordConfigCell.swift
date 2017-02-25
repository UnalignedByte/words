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
    // MARK: - Private Properties
    @IBOutlet fileprivate var gradientView: UIView!
    @IBOutlet fileprivate var configSegment: UISegmentedControl!
    fileprivate var language: Language?

    // MARK: - Public Properties
    static var configChangedCallback: ((Int) -> Void)?

    // MARK: - Initialization
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


    func setup(withLanguage language: Language)
    {
        guard language != self.language else {
            return
        }
        self.language = language

        configSegment.removeAllSegments()

        for i in 0..<language.wordConfigCellTitles.count {
            let title = language.wordConfigCellTitles[i]
            configSegment.insertSegment(withTitle: title, at: i, animated: false)
        }

        configSegment.selectedSegmentIndex = 0
    }


    // MARK: - Actions
    @IBAction fileprivate func visibilitySegmentChanged(sender: UISegmentedControl)
    {
        if let callback = WordConfigCell.configChangedCallback {
            callback(sender.selectedSegmentIndex)
        }
    }
}
