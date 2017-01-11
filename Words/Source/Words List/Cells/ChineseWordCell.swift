//
//  ChineseWordCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit


enum ChineseWordDisplayStyle: Int {
    case all
    case english
    case pinyin
    case hanzi
}


class ChineseWordCell: UITableViewCell
{
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var hanziLabel: UILabel!

    var pinyinWidthConstraint: NSLayoutConstraint!
    var hanziWidthConstraint: NSLayoutConstraint!
    var englishHeightConstraint: NSLayoutConstraint!
    var pinyinHeightConstraint: NSLayoutConstraint!

    var isTouching: Bool = false
    var currentWord: ChineseWord!
    var currentStyle: ChineseWordDisplayStyle!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    func setupWithChineseWord(_ word: ChineseWord, style: ChineseWordDisplayStyle)
    {
        self.currentWord = word
        self.currentStyle = style

        self.englishLabel.text = word.english
        self.pinyinLabel.text = word.pinyin
        self.hanziLabel.text = word.hanzi

        self.englishLabel.isHidden = true
        self.pinyinLabel.isHidden = true
        self.hanziLabel.isHidden = true

        if self.pinyinWidthConstraint != nil {
            self.removeConstraint(self.pinyinWidthConstraint)
            self.pinyinWidthConstraint = nil
        }

        if self.hanziWidthConstraint != nil {
            self.removeConstraint(self.hanziWidthConstraint)
            self.hanziWidthConstraint = nil
        }

        if self.englishHeightConstraint != nil {
            self.removeConstraint(self.englishHeightConstraint)
            self.englishHeightConstraint = nil
        }

        if self.pinyinHeightConstraint != nil {
            self.removeConstraint(self.pinyinHeightConstraint)
            self.pinyinHeightConstraint = nil
        }

        if self.isTouching {
            self.englishLabel.isHidden = false
            self.pinyinLabel.isHidden = false
            self.hanziLabel.isHidden = false
        } else {
        switch style {
            case .all:
                self.englishLabel.isHidden = false
                self.pinyinLabel.isHidden = false
                self.hanziLabel.isHidden = false
            case .english:
                self.englishLabel.isHidden = false

                self.hanziWidthConstraint = NSLayoutConstraint(item: self.hanziLabel,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .notAnAttribute,
                                                               multiplier: 1.0,
                                                               constant: 0.0)
                self.addConstraint(self.hanziWidthConstraint)

                self.pinyinHeightConstraint = NSLayoutConstraint(item: self.pinyinLabel,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: .notAnAttribute,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0)
                self.addConstraint(self.pinyinHeightConstraint)
            case .pinyin:
                self.pinyinLabel.isHidden = false
                self.hanziWidthConstraint = NSLayoutConstraint(item: self.hanziLabel,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .notAnAttribute,
                                                               multiplier: 1.0,
                                                               constant: 0.0)
                self.addConstraint(self.hanziWidthConstraint)

                self.englishHeightConstraint = NSLayoutConstraint(item: self.englishLabel,
                                                                  attribute: .height,
                                                                  relatedBy: .equal,
                                                                  toItem: nil,
                                                                  attribute: .notAnAttribute,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
                self.addConstraint(self.englishHeightConstraint)
            case .hanzi:
                self.hanziLabel.isHidden = false
                self.pinyinWidthConstraint = NSLayoutConstraint(item: self.pinyinLabel,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
                self.addConstraint(self.pinyinWidthConstraint)
        }
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isTouching = true
        self.setupWithChineseWord(self.currentWord, style: self.currentStyle)
    }


    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.touchesEnded(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isTouching = false
        self.setupWithChineseWord(self.currentWord, style: self.currentStyle)
    }
}
