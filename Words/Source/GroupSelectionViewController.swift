//
//  LessonSelectionViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 27/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit


class GroupSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    var vc: ViewController!
    var groupNames: [String]!
    var selectedGroupName: String = "All"
    @IBOutlet var pickerView: UIPickerView!

    override func viewWillAppear(_ animated: Bool)
    {
        var groupNames = ["All"]
        groupNames.append(contentsOf: WordsDataSource.sharedInstance.groupNames())

        self.groupNames = groupNames.sorted() {$0.compare($1, options: .numeric) == .orderedAscending}

        let i = self.groupNames.index(of: self.selectedGroupName)!
        self.pickerView.selectRow(i, inComponent: 0, animated: false)
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.groupNames.count
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.groupNames[row]
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedGroupName = self.groupNames[row];
    }
}
