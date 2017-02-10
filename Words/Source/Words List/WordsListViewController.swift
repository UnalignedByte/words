//
//  WordsListViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 11/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit
import CoreData


class WordsListViewController: UIViewController
{
    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate var resultsController = NSFetchedResultsController<Word>()
    fileprivate var identifiersForLanguageCode = Dictionary<String, String>()
    fileprivate var configIdentifiersForLanguageCode = Dictionary<String, String>()

    fileprivate var languageCode: String!
    fileprivate var cellConfig = 0


    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        registerCells()
    }


    private func registerCells()
    {
        self.tableView.register(UINib(nibName: "WordCell", bundle: nil),
                                forCellReuseIdentifier: WordCell.identifier)
        self.tableView.register(UINib(nibName: "WordConfigCell", bundle: nil),
                                forCellReuseIdentifier: WordConfigCell.identifier)
        WordConfigCell.configChangedCallback = { (config) in
            self.cellConfig = config
            self.tableView.reloadData()
        }
    }


    func setup(forGroup group: Group)
    {
        self.title = group.name
        self.languageCode = group.languageCode

        self.resultsController = NSFetchedResultsController(fetchRequest: WordsDataSource.sharedInstance.fetchRequestWords(forGroup: group),
                                                            managedObjectContext: WordsDataSource.sharedInstance.context,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)

        do {
            try self.resultsController.performFetch()
        } catch {
            print("\(error)")
            abort()
        }
    }
}


extension WordsListViewController: UITableViewDataSource
{

    func numberOfSections(in tableView: UITableView) -> Int
    {
        // Additional section for configuration cell
        return self.resultsController.sections!.count + 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }

        let sectionInfo = self.resultsController.sections![section - 1]
        return sectionInfo.numberOfObjects
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Get a configuration cell
        if indexPath.section == 0 {
            var identifier = WordConfigCell.identifier
            if let identifierForLanguageCode = self.configIdentifiersForLanguageCode[self.languageCode] {
                identifier = identifierForLanguageCode
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

            return cell
        }

        // Get a normal word cell
        var identifier = WordCell.identifier
        if let identifierForLanguageCode = self.identifiersForLanguageCode[self.languageCode] {
            identifier = identifierForLanguageCode
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WordCell

        let word = self.resultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        cell.setup(withWord: word, config: self.cellConfig)

        return cell
    }
}


extension WordsListViewController: UITableViewDelegate
{
}
