//
//  Language.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

enum Language: String
{
    case en = "en"
    case cn = "cn"
}

extension Language
{
    var code: String {
        return self.rawValue
    }

    static var languages: [Language] {
        return [.en, .cn]
    }

    var editWordViewController: EditWordViewController {
        var viewController: EditWordViewController!

        switch self {
            case .en:
                viewController = UIStoryboard(name: "EditEnglishWord", bundle: nil).instantiateInitialViewController() as! EditWordViewController
            case .cn:
                viewController = UIStoryboard(name: "EditChineseWord", bundle: nil).instantiateInitialViewController() as! EditWordViewController
        }

        return viewController
    }


    var wordConfigCellTitles: [String] {
        var titles: [String]!

        switch self {
            case .en:
                titles = ["Both", "Word", "Translation"]
            case .cn:
                titles = ["所有", "汉字", "拼音", "Translation"]
        }

        return titles
    }

    var wordCellIdentifier: String {
        get {
            var wordCellIdentifier: String!

            switch self {
                case .en:
                    wordCellIdentifier = String(describing: EnglishWordCell.self)
                case .cn:
                    wordCellIdentifier = String(describing: ChineseWordCell.self)
            }

            return wordCellIdentifier
        }
    }

    var wordEntity: String {
        get {
            var entity: String!

            switch self {
                case .en:
                    entity = "Word"
                case .cn:
                    entity = "ChineseWord"
            }

            return entity
        }
    }


    func registerWordCell(forTableView tableView: UITableView)
    {
        tableView.register(UINib(nibName: wordCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: wordCellIdentifier)
    }
}
