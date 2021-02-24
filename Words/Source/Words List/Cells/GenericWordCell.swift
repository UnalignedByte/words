//
//  GenericWordCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 11/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class GenericWordCell: WordCell
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordLabel: UILabel!
    @IBOutlet fileprivate weak var translationLabel: UILabel!

    fileprivate var config = 0


    // MARK: - Initialization    
    override func setup(withWord word: Word, config: Int)
    {
        self.wordLabel.text = word.word
        self.translationLabel.text = word.translation
        self.config = config
        self.setup(withConfig: config)
    }


    fileprivate func setup(withConfig config: Int)
    {
        switch config {
            // Word
            case 1:
                self.wordLabel.isHidden = false
                self.translationLabel.isHidden = true
            // Translation
            case 2:
                self.wordLabel.isHidden = true
                self.translationLabel.isHidden = false
            // All
            default:
                self.wordLabel.isHidden = false
                self.translationLabel.isHidden = false
        }
    }


    // MARK: - Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.setup(withConfig: 0)
    }


    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.setup(withConfig: self.config)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.setup(withConfig: self.config)
    }
}
