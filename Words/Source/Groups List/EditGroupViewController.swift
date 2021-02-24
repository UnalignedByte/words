//
//  EditGroupViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 09/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


fileprivate let kLastUsedLanguage = "kLastUsedLanguage"

class EditGroupViewController: UIViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var nameField: UITextField!
    @IBOutlet fileprivate weak var languageLabel: UILabel!
    @IBOutlet fileprivate weak var languagePicker: UIPickerView!
    @IBOutlet fileprivate weak var addGroupButton: UIButton!
    @IBOutlet fileprivate weak var scrimView: UIVisualEffectView!

    fileprivate var editGroup: Group?


    // MARK: - Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 8.0
        NotificationCenter.default.addObserver(self, selector: #selector(nameFieldChanged(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.nameField)

        if let editGroup = editGroup {
            addGroupButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            nameField.text = editGroup.name
            languageLabel.isHidden = true
            languagePicker.isHidden = true
        }

        setupPickerSelection()
        
        if traitCollection.userInterfaceStyle == .dark {
            scrimView.effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        } else {
            scrimView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        }
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.nameField.becomeFirstResponder()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark {
            scrimView.effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        } else {
            scrimView.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        }
    }


    fileprivate func setupPickerSelection()
    {
        var language: Language!

        if let languageCode = UserDefaults.standard.object(forKey: kLastUsedLanguage) as? String {
            language = Language(rawValue: languageCode)
        } else {
            language = .gn
        }

        languagePicker.selectRow(pickerIndex(forLanguage: language), inComponent: 0, animated: false)
    }


    func setup(forEditGroup group: Group?)
    {
        editGroup = group
    }


    // MARK: - Actions
    @IBAction fileprivate func addGroupButtonPressed(sender: UIButton)
    {
        self.nameField.resignFirstResponder()

        if let editGroup = editGroup {
            editGroup.name = nameField.text!
        } else {
            let selectedRow = self.languagePicker.selectedRow(inComponent: 0)
            let language = Language.allCases[selectedRow]
            let group = WordsDataSource.sharedInstance.newGroup(forLanguage: language)
            group.name = nameField.text!

            UserDefaults.standard.set(language.code, forKey: kLastUsedLanguage)
        }

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

        self.addGroupButton.isEnabled = noSpacesName!.count > 0
    }


    // MARK: - Utils
    fileprivate func pickerIndex(forLanguage language: Language) -> Int
    {
        return Language.allCases.firstIndex(of: language)!
    }
}


extension EditGroupViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Language.allCases.count
    }
}


extension EditGroupViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let languageCode = Language.allCases[row].code
        return NSLocalizedString(languageCode, comment: "")
    }
}


extension EditGroupViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if addGroupButton.isEnabled {
            addGroupButtonPressed(sender: addGroupButton)
        }

        return true
    }
}
