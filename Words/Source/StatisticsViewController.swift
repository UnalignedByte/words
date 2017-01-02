//
//  StatisticsViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 30/08/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit


class StatisticsViewController: UIViewController
{
    @IBOutlet fileprivate weak var wordsCountLabel: UILabel!
    @IBOutlet fileprivate weak var hanziCountLabel: UILabel!

    /*override func viewDidLoad()
    {
        self.wordsCountLabel.text = "Words Count: \(WordsDataSource.sharedInstance.wordsCount())"
        self.hanziCountLabel.text = "Hanzi Count: \(WordsDataSource.sharedInstance.hanziCount())"
    }*/
}
