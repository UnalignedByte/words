//
//  GroupsListViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 12/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit
import CoreData


class GroupsListViewController: UIViewController
{
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var addGroupButton: UIButton!

    fileprivate var resultsController = NSFetchedResultsController<Group>()
    var activeSection: Int = -1


    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.addGroupButton.layer.cornerRadius = self.addGroupButton.frame.size.width/2.0

        registerCells()
        loadData()
        setupDataSource()
    }


    private func registerCells()
    {
        self.tableView.register(UINib(nibName: "GroupHeader", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: GroupHeader.identifier)
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil),
                                forCellReuseIdentifier: GroupCell.identifier)
    }


    fileprivate func setupDataSource()
    {
        self.resultsController = NSFetchedResultsController(fetchRequest: WordsDataSource.sharedInstance.fetchRequestGroups(),
                                                            managedObjectContext: WordsDataSource.sharedInstance.context,
                                                            sectionNameKeyPath: "languageCode",
                                                            cacheName: nil)
        self.resultsController.delegate = self

        do {
            try self.resultsController.performFetch()
        } catch {
            print("\(error)")
            abort()
        }
    }


    private func loadData()
    {
        WordsDataSource.sharedInstance.loadAllSharedFiles()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "WordsListViewController" {
            let destination = segue.destination as! WordsListViewController

            if let indexPath = sender as? IndexPath {
                let group = self.resultsController.object(at: indexPath)
                destination.setup(forGroup: group)
            }
        }
    }
}


extension GroupsListViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.resultsController.sections!.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == activeSection || self.resultsController.sections!.count <= 1 {
            let section = self.resultsController.sections![section]
            return section.numberOfObjects
        }

        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell

        let group = self.resultsController.object(at: indexPath)
        cell.setup(withGroup: group)

        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let group = self.resultsController.object(at: indexPath)
            WordsDataSource.sharedInstance.delete(group: group)
        }
    }
}


extension GroupsListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if self.resultsController.sections!.count > 1 {
            return 44.0
        }

        return 0.0
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if self.resultsController.sections!.count <= 1 {
            return nil
        }

        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: GroupHeader.identifier) as! GroupHeader

        let firstGroup = self.resultsController.object(at: IndexPath(row: 0, section: section))

        cell.setup(withLanguageCode: firstGroup.languageCode!, callback: { [weak self] in
            self?.tableView(tableView, didSelectHeaderInSection: section)
        })

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectHeaderInSection section: Int)
    {
        let indexesToRefresh = NSMutableIndexSet()

        if self.activeSection >= 0 {
            indexesToRefresh.add(self.activeSection)
        }

        if self.activeSection == section {
            self.activeSection = -1
        } else {
            self.activeSection = section
            indexesToRefresh.add(section)
        }

        tableView.reloadSections(indexesToRefresh as IndexSet, with: .automatic)
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "WordsListViewController", sender: indexPath)
    }
}


extension GroupsListViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.beginUpdates()
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch(type) {
            case .insert:
                if activeSection >= 0 {
                    let activeSection = self.activeSection
                    self.activeSection = -1
                    self.tableView.reloadSections(IndexSet([activeSection]), with: .automatic)
                }
                self.activeSection = sectionIndex
                self.tableView.insertSections(IndexSet([sectionIndex]), with: .automatic)
            case .delete:
                self.activeSection = -1
                self.tableView.deleteSections(IndexSet([sectionIndex]), with: .automatic)
            default:
                break
        }
    }


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch(type) {
            case .insert:
                if activeSection == newIndexPath!.section || self.resultsController.sections!.count <= 1 {
                    tableView.insertRows(at: [newIndexPath!], with: .automatic)
                }
            case .delete:
                let languageCode = (anObject as! Group).languageCode!
                let groupsCount = WordsDataSource.sharedInstance.groupsCount(forLanguageCode: languageCode)

                if activeSection == indexPath!.section && groupsCount > 0 {
                    tableView.deleteRows(at: [indexPath!], with: .automatic)
                }
            default:
                break
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.endUpdates()
    }
}
