//
//  WordsListViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 11/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit
import CoreData


class WordsList: UIViewController
{
    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate var resultsController: NSFetchedResultsController<Word>!
    fileprivate var identifiersForLanguageCode = Dictionary<String, String>()


    override func viewDidLoad()
    {
        registerCells()
    }


    private func registerCells()
    {
        self.tableView.register(UINib(nibName: "Word", bundle: nil),
                                forCellReuseIdentifier: WordCell.identifier)
    }
}


extension WordsList: UITableViewDataSource
{

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.resultsController.sections!.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = self.resultsController.sections![section]
        return sectionInfo.numberOfObjects
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let word = self.resultsController.object(at: indexPath)

        var identifier = WordCell.identifier
        if let identifierForLanguageCode = self.identifiersForLanguageCode[word.languageCode!] {
            identifier = identifierForLanguageCode
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WordCell
        cell.setup(withWord: word)

        return cell
    }
}


extension WordsList: UITableViewDelegate
{
    
}
