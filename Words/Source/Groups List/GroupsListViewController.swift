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
    fileprivate var editGroup: Group?
    fileprivate var indexToScrollTo: IndexPath?
    fileprivate var sectionThatHadRevision = -1


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


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        editGroup = nil
    }


    fileprivate func setupEditButton()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .plain,
                                                                 target: self, action: #selector(editButtonPressed))
    }


    fileprivate func registerCells()
    {
        tableView.register(UINib(nibName: String(describing: GroupHeader.self), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: String(describing: GroupHeader.self))
        tableView.register(UINib(nibName: String(describing: GroupCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: GroupCell.self))
        tableView.register(UINib(nibName: String(describing: RevisionCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: RevisionCell.self))
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
            if resultsController.sections!.count == 1 {
                activeSection = 0
            }
        } catch {
            fatalError("Error performing fetch")
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == String(describing: WordsListViewController.self) {
            let destination = segue.destination as! WordsListViewController

            if let indexPath = sender as? IndexPath {
                var index = indexPath
                if doesActiveSectionHaveRevision() {
                    index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                }
                let group = self.resultsController.object(at: index)
                destination.setup(forGroup: group)
            }
        } else if segue.identifier == String(describing: EditGroupViewController.self) {
            let destination = segue.destination as! EditGroupViewController
            destination.setup(forEditGroup: editGroup)
        } else if segue.identifier == String(describing: RevisionWordsViewController.self) {
            let destination = segue.destination as! RevisionWordsViewController
            let firstGroup = self.resultsController.object(at: IndexPath(row: 0, section: activeSection))
            destination.setup(forLanguage: firstGroup.language)
        }
    }


    // MARK: - Actions
    @objc fileprivate func editButtonPressed()
    {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        let title = self.tableView.isEditing ? NSLocalizedString("Done", comment: "") : NSLocalizedString("Edit", comment: "")
        self.navigationItem.rightBarButtonItem?.title = title
        self.addGroupButton.isEnabled = !self.tableView.isEditing
        self.addGroupButton.alpha = self.addGroupButton.isEnabled ? 0.75 : 0.25
    }


    @IBAction fileprivate func addGroupButtonPressed(sender: UIButton)
    {
        editGroup = nil
        performSegue(withIdentifier: String(describing: EditGroupViewController.self), sender: nil)
    }


    @IBAction fileprivate func longPressAction(sender: UIGestureRecognizer)
    {
        guard sender.state == .began else {
            return
        }

        let location = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: location) {
            var index = indexPath
            if doesActiveSectionHaveRevision() {
                if indexPath.row == 0 {
                    return
                }
                index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            }
            editGroup = resultsController.object(at: index)
            performSegue(withIdentifier: String(describing: EditGroupViewController.self), sender: nil)
        }
    }


    // MARK: - Utils
    fileprivate func doesActiveSectionHaveRevision() -> Bool
    {
        var activeSection = 0
        if resultsController.sections!.count > 1 && self.activeSection >= 0 {
            activeSection = self.activeSection
        } else if resultsController.sections!.count > 1 {
            return false
        }

        if resultsController.sections!.count == 0 || resultsController.sections![activeSection].numberOfObjects == 0 {
            return false
        }

        if sectionThatHadRevision == activeSection {
            sectionThatHadRevision = -1
            return true
        }

        let firstGroup = self.resultsController.object(at: IndexPath(row: 0, section: activeSection))
        let revisonWordsCount = WordsDataSource.sharedInstance.revisionWordsCount(forLanguage: firstGroup.language)

        return revisonWordsCount > 0
    }
}


extension GroupsListViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        let sectionsCount = self.resultsController.sections!.count

        return sectionsCount
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == activeSection {
            let section = self.resultsController.sections![section]
            var rowsCount = section.numberOfObjects
            if doesActiveSectionHaveRevision() {
                rowsCount += 1
            }

            return rowsCount
        }

        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if doesActiveSectionHaveRevision() && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RevisionCell.self),
                                                     for: indexPath) as! RevisionCell

            let firstGroup = self.resultsController.object(at: IndexPath(row: 0, section: activeSection))
            cell.setup(withLanguage: firstGroup.language)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupCell.self),
                                                     for: indexPath) as! GroupCell

            var index = indexPath
            if doesActiveSectionHaveRevision() {
                index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            }
            let group = self.resultsController.object(at: index)
            cell.setup(withGroup: group)

            return cell
        }
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if doesActiveSectionHaveRevision() && indexPath.row == 0 {
            return false
        }

        return true
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        var index = indexPath
        if doesActiveSectionHaveRevision() {
            index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            sectionThatHadRevision = indexPath.section
        }

        if editingStyle == .delete {
            let group = self.resultsController.object(at: index)
            WordsDataSource.sharedInstance.delete(group: group)
        }
    }


    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        if doesActiveSectionHaveRevision() && indexPath.row == 0 {
            return false
        }

        return true
    }


    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        var sourceIndex = sourceIndexPath
        var destinationIndex = destinationIndexPath

        if doesActiveSectionHaveRevision() {
            sourceIndex = IndexPath(row: sourceIndexPath.row - 1, section: sourceIndexPath.section)
            destinationIndex = IndexPath(row: destinationIndexPath.row - 1, section: destinationIndexPath.section)
        }

        let endRow = sourceIndex.row > destinationIndex.row ? sourceIndex.row : destinationIndex.row

        var groups = [Group]()
        for i in 0...endRow {
            let group = self.resultsController.object(at: IndexPath(row: i, section: sourceIndex.section))
            groups.append(group)
        }

        var groupIndex = 0
        for i in 0...endRow {
            if i == sourceIndex.row {
                if destinationIndex.row > sourceIndex.row {
                    groupIndex += 1
                    groups[groupIndex].order = Int32(i)
                    groupIndex += 1
                } else {
                    groups[groupIndex].order = Int32(i)
                    groupIndex += 1
                }
            } else if i == destinationIndex.row {
                groups[sourceIndex.row].order = Int32(i)
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
            if doesActiveSectionHaveRevision() && proposedDestinationIndexPath.row == 0 {
                return IndexPath(row: 1, section: proposedDestinationIndexPath.section)
            }

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

        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: GroupHeader.self)) as! GroupHeader

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
        if doesActiveSectionHaveRevision() && indexPath.row == 0 {
            self.performSegue(withIdentifier: String(describing: RevisionWordsViewController.self), sender: indexPath)
        } else {
            self.performSegue(withIdentifier: String(describing: WordsListViewController.self), sender: indexPath)
        }
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
                    var index = newIndexPath
                    if doesActiveSectionHaveRevision() {
                        index = IndexPath(row: newIndexPath!.row + 1, section: newIndexPath!.section)
                    }
                    tableView.insertRows(at: [index!], with: .automatic)

                    indexToScrollTo = newIndexPath
                }
            case .delete:
                var indexesToDelete = [IndexPath]()
                if doesActiveSectionHaveRevision() {
                    indexesToDelete.append(IndexPath(row: indexPath!.row + 1, section: indexPath!.section))
                    if !doesActiveSectionHaveRevision() {
                        indexesToDelete.append(IndexPath(row: 0, section: indexPath!.section))
                    } else {
                        tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath!.section)], with: .fade)
                    }
                } else {
                    indexesToDelete.append(indexPath!)
                }
                tableView.deleteRows(at: indexesToDelete, with: .automatic)
            case .update:
                var index = newIndexPath
                if doesActiveSectionHaveRevision() {
                    index = IndexPath(row: indexPath!.row + 1, section: indexPath!.section)
                }
                tableView.reloadRows(at: [index!], with: .automatic)
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

        if let indexToScrollTo = indexToScrollTo {
            tableView.scrollToRow(at: indexToScrollTo, at: .middle, animated: true)
            self.indexToScrollTo = nil
        }
    }
}
