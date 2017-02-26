//
//  NewGroupViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 09/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class NewGroupViewController: UIViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var nameField: UITextField!
    @IBOutlet fileprivate weak var languagePicker: UIPickerView!
    @IBOutlet fileprivate weak var addGroupButton: UIButton!


    // MARK: - Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 8.0
        NotificationCenter.default.addObserver(self, selector: #selector(nameFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.nameField)
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.nameField.becomeFirstResponder()
    }


    // MARK: - Actions
    @IBAction fileprivate func addGroupButtonPressed(sender: UIButton)
    {
        self.nameField.resignFirstResponder()

        let selectedRow = self.languagePicker.selectedRow(inComponent: 0)
        let language = Language.languages[selectedRow]
        let group = WordsDataSource.sharedInstance.newGroup(forLanguage: language)
        group.name = nameField.text!

        self.dismiss(animated: true, completion: nil)
    }


    @IBAction fileprivate func cancelButtonPressed(sender: UIButton)
    {
        self.nameField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }


    @objc fileprivate func nameFieldChanged(notification: Notification)
    {
        let noSpacesName = self.nameField.text?.replacingOccurrences(of: " ", with: "")

        self.addGroupButton.isEnabled = noSpacesName!.characters.count > 0
    }
}


extension NewGroupViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Language.languages.count
    }
}


extension NewGroupViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let languageCode = Language.languages[row].code
        return NSLocalizedString(languageCode, comment: "")
    }
}


extension NewGroupViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if addGroupButton.isEnabled {
            addGroupButtonPressed(sender: addGroupButton)
        }

        return true
    }
}
