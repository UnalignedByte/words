//
//  Language.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

enum Language: String, CaseIterable
{
    case gn = "gn"
    case cn = "cn"
    case jp = "jp"
}

extension Language
{
    var code: String {
        return self.rawValue
    }

    var editWordControlsViewController: EditWordControlsViewController {
        var viewController: EditWordControlsViewController!

        switch self {
            case .gn:
                viewController = UIStoryboard(name: "EditGenericWord", bundle: nil).instantiateInitialViewController() as! EditWordControlsViewController
            case .cn:
                viewController = UIStoryboard(name: "EditChineseWord", bundle: nil).instantiateInitialViewController() as! EditWordControlsViewController
            case .jp:
                viewController = UIStoryboard(name: "EditJapaneseWord", bundle: nil).instantiateInitialViewController() as! EditWordControlsViewController
            
        }

        return viewController
    }


    var wordConfigCellTitles: [String] {
        var titles: [String]!

        switch self {
            case .gn:
                titles = [NSLocalizedString("Both", comment: ""),
                          NSLocalizedString("Word", comment: ""),
                          NSLocalizedString("Translation", comment: "")]
            case .cn:
                titles = ["所有", "汉字", "拼音", NSLocalizedString("Translation", comment: "")]
            case .jp:
                titles = ["両方", "漢字", "読み方", NSLocalizedString("Translation", comment: "")]
        }

        return titles
    }

    var wordCellIdentifier: String {
        get {
            var wordCellIdentifier: String!

            switch self {
                case .gn:
                    wordCellIdentifier = String(describing: GenericWordCell.self)
                case .cn:
                    wordCellIdentifier = String(describing: ChineseWordCell.self)
                case .jp:
                    wordCellIdentifier = String(describing: JapaneseWordCell.self)
            }

            return wordCellIdentifier
        }
    }

    var wordEntity: String {
        get {
            var entity: String!

            switch self {
                case .gn:
                    entity = "Word"
                case .cn:
                    entity = "ChineseWord"
                case .jp:
                    entity = "JapaneseWord"
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
