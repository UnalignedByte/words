//
//  EditGenericWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 16/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditGenericWordViewController: EditWordControlsViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordField: UITextField!
    @IBOutlet fileprivate weak var translationField: UITextField!

    fileprivate var isWordFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    fileprivate var isTranslationFieldValid = false {
        didSet {
            valuesChanged()
        }
    }


    // MARK: - Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(wordFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.wordField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.translationField)

        if let editWord = editWord {
            wordField.text = editWord.word
            translationField.text = editWord.translation
            isWordFieldValid = true
            isTranslationFieldValid = true
        }
    }


    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        wordField.becomeFirstResponder()
    }


    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        wordField.resignFirstResponder()
        translationField.resignFirstResponder()
    }


    // MARK: - Private functions
    @objc fileprivate func wordFieldChanged(notification: Notification)
    {
        let noSpacesWord = self.wordField.text?.replacingOccurrences(of: " ", with: "")
        isWordFieldValid = noSpacesWord!.characters.count > 0
    }


    @objc fileprivate func translationFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.translationField.text?.replacingOccurrences(of: " ", with: "")
        isTranslationFieldValid = noSpacesTransaltion!.characters.count > 0
    }


    fileprivate func valuesChanged()
    {
        if let callback = valuesChangedCallback {
            callback(isWordFieldValid && isTranslationFieldValid)
        }
    }

    // MARK: - Public functions
    override func createWord(forGroup group: Group)
    {
        if let editWord = editWord {
            editWord.word = wordField.text!
            editWord.translation = translationField.text!
        } else {
            let word = WordsDataSource.sharedInstance.newWord(forGroup: group)
            word.word = wordField.text!
            word.translation = translationField.text!
        }
    }
}


extension EditGenericWordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == wordField {
            translationField.becomeFirstResponder()
        } else {
            wordField.becomeFirstResponder()
        }

        return true
    }
}
