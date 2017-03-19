//
//  ChineseWordCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit


class ChineseWordCell: WordCell
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var gradientView: UIView!
    @IBOutlet fileprivate weak var wordLabel: UILabel!
    @IBOutlet fileprivate weak var pinyinLabel: UILabel!
    @IBOutlet fileprivate weak var translationLabel: UILabel!
    @IBOutlet fileprivate weak var verticalStack: UIStackView!

    fileprivate var config = 0

    
    // MARK: - Initialization
    override func awakeFromNib()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: gradientView.bounds.height)
        gradientLayer.colors = [UIColor.lightGray.withAlphaComponent(0.1).cgColor,
                                UIColor.lightGray.withAlphaComponent(0.25).cgColor]
        gradientLayer.locations = [0.2, 1.0]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }


    // MARK: - Public Functions
    override func setup(withWord word: Word, config: Int)
    {
        let chineseWord = word as? ChineseWord
        guard chineseWord != nil else {
            fatalError("Passed in word isn't an instance of ChineseWord")
        }

        wordLabel.text = chineseWord!.word
        pinyinLabel.text = chineseWord!.pinyin
        translationLabel.text = chineseWord!.translation
        self.config = config
        setup(withConfig: config)
    }


    // MARK: - Private Functions
    fileprivate func setup(withConfig config: Int)
    {
        switch config {
            // Word
            case 1:
                wordLabel.isHidden = false
                pinyinLabel.isHidden = true
                translationLabel.isHidden = true
            // Pinyin
            case 2:
                wordLabel.isHidden = true
                pinyinLabel.isHidden = false
                translationLabel.isHidden = true
            // Translation
            case 3:
                wordLabel.isHidden = true
                pinyinLabel.isHidden = true
                translationLabel.isHidden = false
            // All
            default:
                wordLabel.isHidden = false
                pinyinLabel.isHidden = false
                translationLabel.isHidden = false
        }

        verticalStack.isHidden = translationLabel.isHidden && pinyinLabel.isHidden
    }


    // MARK: - Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        setup(withConfig: 0)
    }


    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        setup(withConfig: config)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        setup(withConfig: config)
    }
}
