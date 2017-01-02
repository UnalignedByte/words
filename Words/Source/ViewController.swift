//
//  ViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController//, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate
{
    //var resultsController: NSFetchedResultsController<ChineseWord>!
    //var wordDisplayStyle: ChineseWordDisplayStyle!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterSegment: UISegmentedControl!
    @IBOutlet var filterButton: UIButton!


    /*override func viewDidLoad()
    {
        self.wordDisplayStyle = .all
        self.filterSegment.selectedSegmentIndex = self.wordDisplayStyle.rawValue

        self.loadWords("Lesson 1")
        self.loadWords("Lesson 2")
        self.loadWords("Lesson 3")
        self.loadWords("Lesson 4")
        self.loadWords("Lesson 5")
        self.loadWords("Lesson 6")
        self.loadWords("Lesson 7")
        self.loadWords("Lesson 8")
        self.loadWords("Lesson 9")
        self.loadWords("Lesson 9.5")
        self.loadWords("Lesson 10")
        self.loadWords("Lesson 11")
        self.loadWords("Lesson 13")
        self.loadWords("Lesson 14")
        self.loadWords("Lesson 15")
        self.loadWords("Lesson 16")
        self.loadWords("Lesson 17")
        self.loadWords("Basic Chinese 1")
        self.loadWords("Basic Chinese 3.1 - 1")
        self.loadWords("Basic Chinese 3.1 - 2")
        self.loadWords("Basic Chinese 3.1 - 3")
        self.loadWords("Basic Chinese 3.1 - 4")
        self.loadWords("Basic Chinese 3.2")
        self.loadWords("Basic Chinese 4 - 1")
        self.loadWords("Basic Chinese 4 - 2")
        self.loadWords("Basic Chinese 4 - 3")
        self.loadWords("Basic Chinese 5 - 1")
        self.loadWords("Basic Chinese 5 - 2")
        self.loadWords("Basic Chinese 5 - 3")
        self.loadWords("Basic Chinese 5 - 4")
        self.loadWords("Basic Chinese 5 - 5")
        self.loadWords("Basic Chinese 5 - 6")
        self.loadWords("Useful 1")
        self.loadWords("Useful 2")
        self.loadWords("Useful 3")
        self.loadWords("Read 1")
        self.loadWords("Grammar 1")

        let fetchRequest: NSFetchRequest<ChineseWord> = NSFetchRequest()
        let entityDescription = NSEntityDescription.entity(forEntityName: "ChineseWord",
                                                                  in: WordsDataSource.sharedInstance.context)
        fetchRequest.entity = entityDescription
        //let sortOne = NSSortDescriptor(key: "groupName", ascending: true, comparator: {(s1: String, s2: String) -> Co})
            //{$0.compare($1 , options: .numeric)})
        let sortOne = NSSortDescriptor(key: "groupName", ascending: true)
        let sortTwo = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortOne, sortTwo]
        fetchRequest.fetchBatchSize = 10

        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: WordsDataSource.sharedInstance.context,
                                                            sectionNameKeyPath: "groupName",
                                                            cacheName: nil)
        do {
            try self.resultsController.performFetch()
        } catch {
        }

        self.filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.filterButton.titleLabel?.minimumScaleFactor = 0.2
    }


    func loadWords(_ wordsPlist: String)
    {
        if let plistUrl = Bundle.main.url(forResource: wordsPlist, withExtension: "plist")
        {
            let wordsDict = NSDictionary.init(contentsOf: plistUrl) as! Dictionary<String, AnyObject>
            let groupName = wordsDict["name"] as! String

            let wordsArray = wordsDict["words"] as! Array<Dictionary<String, String>>

            for wordDict in wordsArray
            {
                let english: String = wordDict["english"]!
                let pinyin: String = wordDict["pinyin"]!
                let hanzi: String = wordDict["hanzi"]!

                if !english.isEmpty || !pinyin.isEmpty || !hanzi.isEmpty {
                    let word = WordsDataSource.sharedInstance.addNewChineseWord()
                    word.groupName = groupName
                    word.english = english
                    word.pinyin = pinyin
                    word.hanzi = hanzi
                }
            }
        }
    }


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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChineseWordCell", for: indexPath) as! ChineseWordCell

        let word = self.resultsController.object(at: indexPath) 
        cell.setupWithChineseWord(word, style: self.wordDisplayStyle)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let sectionInfo = self.resultsController.sections![section]

        return sectionInfo.name
    }

    
    @IBAction func filterSegmentPressed(_ sender: AnyObject)
    {
        let segment = sender as! UISegmentedControl

        if let style = ChineseWordDisplayStyle(rawValue: segment.selectedSegmentIndex) {
            self.wordDisplayStyle = style
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        (segue.destination as! GroupSelectionViewController).selectedGroupName = (self.filterButton.titleLabel?.text)!
    }


    @IBAction func returnToController(_ segue: UIStoryboardSegue)
    {
        let group = segue.source as! GroupSelectionViewController

        if group.selectedGroupName == "All" {
            self.resultsController.fetchRequest.predicate = nil
        } else {
            self.resultsController.fetchRequest.predicate = NSPredicate(format: "groupName = %@", group.selectedGroupName)
        }

        self.filterButton.setTitle(group.selectedGroupName, for: UIControlState())

        do {
            try self.resultsController.performFetch()
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        } catch {
        }
    }*/
}

