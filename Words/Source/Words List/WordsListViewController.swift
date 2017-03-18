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
    // MARK: - Private Properties
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate weak var addWordButton: UIButton!

    fileprivate var resultsController = NSFetchedResultsController<Word>()
    fileprivate var group: Group?
    fileprivate var cellConfig = 0

    fileprivate var editWord: Word?
    fileprivate var indexToScrollTo: IndexPath?


    // MARK: - Initialization
    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.addWordButton.layer.cornerRadius = self.addWordButton.frame.size.width/2.0

        registerCells()
        setupShuffleButton()
    }


    fileprivate func registerCells()
    {
        guard group != nil else {
            fatalError("Group is nil")
        }

        self.group!.language.registerWordCell(forTableView: self.tableView)
        self.tableView.register(UINib(nibName: String(describing: WordConfigCell.self), bundle: nil),
                                forCellReuseIdentifier: String(describing: WordConfigCell.self))
        WordConfigCell.configChangedCallback = { (config) in
            self.cellConfig = config
            self.tableView.reloadData()
        }
    }


    fileprivate func setupShuffleButton()
    {
        let shuffleButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                            action: #selector(shuffleButtonPressed(sender:)))
        navigationItem.rightBarButtonItem = shuffleButton
    }


    func setup(forGroup group: Group)
    {
        self.group = group
        updateTitle()
        self.resultsController = NSFetchedResultsController(fetchRequest: WordsDataSource.sharedInstance.fetchRequestWords(forGroup: group),
                                                            managedObjectContext: WordsDataSource.sharedInstance.context,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        resultsController.delegate = self

        do {
            try self.resultsController.performFetch()
        } catch {
            fatalError("Error performing fetch")
        }
    }


    func updateTitle()
    {
        guard group != nil else {
            fatalError("Group cannot be nil")
        }

        self.title = "\(group!.name) (\(group!.words.count))"
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard group != nil else {
            fatalError("Group cannot be nil")
        }

        if segue.identifier == String(describing: EditWordViewController.self) {
            let viewController = segue.destination as! EditWordViewController
            viewController.setup(forGroup: group!, editWord: editWord)
        }
    }


    // MARK: - Actions
    @objc fileprivate func shuffleButtonPressed(sender: Any)
    {
        guard group != nil else {
            fatalError("Group cannot be nil")
        }

        for word in group!.words {
            var randomNumber = Int32(0)
            arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
            (word as! Word).order = randomNumber
        }
    }


    @IBAction fileprivate func addWordButtonPressed(sender: UIButton)
    {
        editWord = nil
        performSegue(withIdentifier: String(describing: EditWordViewController.self), sender: nil)
    }


    func revisionActionPressed(_ rowAction: UITableViewRowAction, _ indexPath: IndexPath)
    {
        tableView.isEditing = false

        let index = IndexPath(row: indexPath.row, section: 0)
        let word = resultsController.object(at: index)
        word.isInRevision = !word.isInRevision
    }


    func editActionPressed(_ rowAction: UITableViewRowAction, _ indexPath: IndexPath)
    {
        tableView.isEditing = false

        let index = IndexPath(row: indexPath.row, section: 0)
        editWord = resultsController.object(at: index)
        performSegue(withIdentifier: String(describing: EditWordViewController.self), sender: nil)
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
        guard group != nil else {
            fatalError("Group cannot be nil")
        }

        // Get a configuration cell
        if indexPath.section == 0 {
            let identifier = String(describing: WordConfigCell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WordConfigCell
            cell.setup(withLanguage: group!.language)

            return cell
        }

        // Get a normal word cell
        let identifier = self.group!.language.wordCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WordCell

        let word = self.resultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        cell.setup(withWord: word, config: self.cellConfig)

        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return indexPath.section == 1
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
    }
}


extension WordsListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // Revision
        let index = IndexPath(row: indexPath.row, section: 0)
        let word = resultsController.object(at: index)

        var revisionTitle: String!
        var revisionBackgroundColor: UIColor!
        if word.isInRevision {
            revisionTitle = "🗒－"
            revisionBackgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            revisionTitle = "🗒✚"
            revisionBackgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        let revisionAction = UITableViewRowAction(style: .normal, title: revisionTitle, handler: revisionActionPressed)
        revisionAction.backgroundColor = revisionBackgroundColor

        // Edit
        let editAction = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: ""),
                                              handler: editActionPressed)

        return [revisionAction, editAction]
    }
}


extension WordsListViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.beginUpdates()
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch(type) {
            case .insert:
                let index = IndexPath(row: newIndexPath!.row, section: 1)
                tableView.insertRows(at: [index], with: .automatic)
                indexToScrollTo = index
            case .delete:
                let index = IndexPath(row: indexPath!.row, section: 1)
                tableView.deleteRows(at: [index], with: .automatic)
            case .update:
                let newIndex = IndexPath(row: newIndexPath!.row, section: 1)
                tableView.reloadRows(at: [newIndex], with: .automatic)
            case .move:
                // We don't actually move rows, so technically it should be an update
                let newIndex = IndexPath(row: newIndexPath!.row, section: 1)
                tableView.reloadRows(at: [newIndex], with: .automatic)
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.endUpdates()

        if let indexToScrollTo = indexToScrollTo {
            tableView.scrollToRow(at: indexToScrollTo, at: .middle, animated: true)
            self.indexToScrollTo = nil
        }

        updateTitle()
    }
}
