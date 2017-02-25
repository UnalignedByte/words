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
    // MARK: - Private Properites
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var addGroupButton: UIButton!

    fileprivate var resultsController = NSFetchedResultsController<Group>()
    fileprivate var activeSection: Int = -1


    // MARK: - Initialization
    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.addGroupButton.layer.cornerRadius = self.addGroupButton.frame.size.width/2.0

        setupEditButton()
        registerCells()
        loadData()
        setupDataSource()
    }


    fileprivate func setupEditButton()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .plain,
                                                                 target: self, action: #selector(editButtonPressed))
    }


    fileprivate func registerCells()
    {
        self.tableView.register(UINib(nibName: "GroupHeader", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: GroupHeader.identifier)
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil),
                                forCellReuseIdentifier: GroupCell.identifier)
    }


    fileprivate func loadData()
    {
        WordsDataSource.sharedInstance.loadAllSharedFiles()
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
            fatalError("Error performing fetch")
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == String(describing: WordsListViewController.self) {
            let destination = segue.destination as! WordsListViewController

            if let indexPath = sender as? IndexPath {
                let group = self.resultsController.object(at: indexPath)
                destination.setup(forGroup: group)
            }
        }
    }


    @objc fileprivate func editButtonPressed()
    {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        let title = self.tableView.isEditing ? NSLocalizedString("Done", comment: "") : NSLocalizedString("Edit", comment: "")
        self.navigationItem.rightBarButtonItem?.title = title
        self.addGroupButton.isEnabled = !self.tableView.isEditing
        self.addGroupButton.alpha = self.addGroupButton.isEnabled ? 0.75 : 0.25
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
        if section == activeSection {
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


    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }


    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let endRow = sourceIndexPath.row > destinationIndexPath.row ? sourceIndexPath.row : destinationIndexPath.row

        var groups = [Group]()
        for i in 0...endRow {
            let group = self.resultsController.object(at: IndexPath(row: i, section: sourceIndexPath.section))
            groups.append(group)
        }

        var groupIndex = 0
        for i in 0...endRow {
            if i == sourceIndexPath.row {
                if destinationIndexPath.row > sourceIndexPath.row {
                    groupIndex += 1
                    groups[groupIndex].order = Int32(i)
                    groupIndex += 1
                } else {
                    groups[groupIndex].order = Int32(i)
                    groupIndex += 1
                }
            } else if i == destinationIndexPath.row {
                groups[sourceIndexPath.row].order = Int32(i)
            } else {
                groups[groupIndex].order = Int32(i)
                groupIndex += 1
            }
        }
    }


    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }

        return sourceIndexPath
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

        cell.setup(withLanguage: firstGroup.language, callback: { [weak self] in
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
                tableView.deleteRows(at: [indexPath!], with: .automatic)
            default:
                break
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.endUpdates()
        if self.activeSection == -1 && self.resultsController.sections!.count == 1 {
            self.activeSection = 0
            self.tableView.reloadData()
        }
    }
}
