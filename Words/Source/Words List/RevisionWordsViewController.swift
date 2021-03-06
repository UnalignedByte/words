//
//  RevisionWordsViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 13/03/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit
import CoreData


class RevisionWordsViewController: UIViewController
{
    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var resultsController: NSFetchedResultsController<Word>!
    fileprivate var language: Language!
    fileprivate var cellConfig = 0

    // MARK: - Initialization
    override func viewDidLoad()
    {
        tableView.estimatedRowHeight = 20.0
        tableView.rowHeight = UITableView.automaticDimension

        registerCells()
        setupShuffleButton()
    }


    fileprivate func registerCells()
    {
        guard language != nil else {
            fatalError("Language is nil")
        }

        language.registerWordCell(forTableView: tableView)
        tableView.register(UINib(nibName: String(describing: WordConfigCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: WordConfigCell.self))
        WordConfigCell.configChangedCallback = { [weak self] config in
            self?.cellConfig = config
            self?.tableView.reloadData()
        }
    }


    func setup(forLanguage language: Language)
    {
        self.language = language
        setupResultsController(forLanguage: language)
        updateTitle()
    }


    fileprivate func setupResultsController(forLanguage language: Language)
    {
        let fetchRequest = WordsDataSource.sharedInstance.fetchRequestRevisionWords(forLanguage: language)
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: WordsDataSource.sharedInstance.context,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        resultsController.delegate = self
        do {
            try resultsController.performFetch()
        } catch let error {
            fatalError("Error performing fetch: \(error)")
        }
    }


    fileprivate func setupShuffleButton()
    {
        let shuffleButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                            action: #selector(shuffleButtonPressed(sender:)))
        navigationItem.rightBarButtonItem = shuffleButton
    }


    fileprivate func updateTitle()
    {
        guard language != nil else {
            fatalError("Language is nil")
        }

        let titleFront = NSLocalizedString(language.code, comment: "")
        let titleBack = NSLocalizedString("Revision", comment: "")
        let wordsCount = WordsDataSource.sharedInstance.revisionWordsCount(forLanguage: language)

        title = titleFront + " - " + titleBack + " (\(wordsCount))"
    }


    // MARK: - Actions
    @objc fileprivate func shuffleButtonPressed(sender: Any)
    {
        let words = resultsController.sections![0].objects as! [Word]

        for word in words {
            var randomNumber = Int32(0)
            arc4random_buf(&randomNumber, MemoryLayout.size(ofValue: randomNumber))
            word.order = randomNumber
        }
    }
}


extension RevisionWordsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // Additional section for configuration cell
        return resultsController.sections!.count + 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WordConfigCell.self),
                                                     for: indexPath) as! WordConfigCell
            cell.setup(withLanguage: language)

            return cell
        }

        // Get a normal word cell
        let cell = tableView.dequeueReusableCell(withIdentifier: language.wordCellIdentifier,
                                                 for: indexPath) as! WordCell

        let word = self.resultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        cell.setup(withWord: word, config: cellConfig)
        
        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return indexPath.section == 1
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
    }
}


extension RevisionWordsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let index = IndexPath(row: indexPath.row, section: 0)
        let word = resultsController.object(at: index)
        
        let revisionAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            word.isInRevision = false
            completion(true)
        }
        revisionAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        revisionAction.image = UIImage(systemName: "bookmark.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        
        return UISwipeActionsConfiguration(actions: [revisionAction])
    }
}


extension RevisionWordsViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.beginUpdates()
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch(type) {
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
            default:
                break
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.endUpdates()
        updateTitle()
    }
}
