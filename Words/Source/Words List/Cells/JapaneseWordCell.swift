//
//  JapaneseWordCell.swift
//  Words
//
//  Created by Rafał Grodziński on 23/02/2021.
//  Copyright © 2021 UnalignedByte. All rights reserved.
//
import UIKit


class JapaneseWordCell: WordCell
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordLabel: UILabel!
    @IBOutlet fileprivate weak var yomikataLabel: UILabel!
    @IBOutlet fileprivate weak var translationLabel: UILabel!
    @IBOutlet fileprivate weak var verticalStack: UIStackView!

    fileprivate var config = 0

    
    // MARK: - Public Functions
    override func setup(withWord word: Word, config: Int)
    {
        let japaneseWord = word as? JapaneseWord
        guard japaneseWord != nil else {
            fatalError("Passed in word isn't an instance of JapaneseWord")
        }

        wordLabel.text = japaneseWord!.word
        yomikataLabel.text = japaneseWord!.yomikata
        translationLabel.text = japaneseWord!.translation
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
                yomikataLabel.isHidden = true
                translationLabel.isHidden = true
            // Pinyin
            case 2:
                wordLabel.isHidden = true
                yomikataLabel.isHidden = false
                translationLabel.isHidden = true
            // Translation
            case 3:
                wordLabel.isHidden = true
                yomikataLabel.isHidden = true
                translationLabel.isHidden = false
            // All
            default:
                wordLabel.isHidden = false
                yomikataLabel.isHidden = false
                translationLabel.isHidden = false
        }

        verticalStack.isHidden = translationLabel.isHidden && yomikataLabel.isHidden
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
