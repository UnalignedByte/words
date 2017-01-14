//
//  GroupsListViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 12/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class GroupsListViewController: UIViewController
{
    @IBOutlet fileprivate var tableView: UITableView!


    override func viewDidLoad()
    {
        self.tableView.estimatedRowHeight = 20

        registerCells()
        loadData()
    }


    private func registerCells()
    {
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil),
                                forCellReuseIdentifier: GroupCell.identifier)
    }


    private func loadData()
    {
        WordsDataSource.sharedInstance.loadAllSharedFiles()
    }
}


extension GroupsListViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return WordsDataSource.sharedInstance.languageCodesCount()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let languageCodes = WordsDataSource.sharedInstance.languageCodes()
        return WordsDataSource.sharedInstance.groupsCount(forLanguageCode: languageCodes[section])
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell

        let languageCodes = WordsDataSource.sharedInstance.languageCodes()
        let groups = WordsDataSource.sharedInstance.groups(forLanguageCode: languageCodes[indexPath.section])

        cell.setup(withName: groups[indexPath.row])

        return cell
    }
}


extension GroupsListViewController: UITableViewDelegate
{
}
