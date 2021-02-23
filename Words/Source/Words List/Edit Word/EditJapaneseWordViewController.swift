//
//  EditJapaneseWordViewController.swift
//  Words
//
//  Created by Rafał Grodziński on 23/02/2021.
//  Copyright © 2021 UnalignedByte. All rights reserved.
//

import UIKit


class EditJapaneseWordViewController: EditWordControlsViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordField: UITextField!
    @IBOutlet fileprivate weak var yomikataField: UITextField!
    @IBOutlet fileprivate weak var translationField: UITextField!

    fileprivate var isWordFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    fileprivate var isYomikataFieldValid = false {
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
                                               name: UITextField.textDidChangeNotification, object: self.wordField)
        NotificationCenter.default.addObserver(self, selector: #selector(yomikataFieldChanged(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.yomikataField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.translationField)

        if let editWord = editWord as? JapaneseWord {
            wordField.text = editWord.word
            yomikataField.text = editWord.yomikata
            translationField.text = editWord.translation
            isWordFieldValid = true
            isYomikataFieldValid = true
            isTranslationFieldValid = true
        }
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
        yomikataField.resignFirstResponder()
        translationField.resignFirstResponder()
    }


    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Private functions
    @objc fileprivate func wordFieldChanged(notification: Notification)
    {
        let noSpacesWord = self.wordField.text?.replacingOccurrences(of: " ", with: "")
        isWordFieldValid = noSpacesWord!.count > 0
    }


    @objc fileprivate func yomikataFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.yomikataField.text?.replacingOccurrences(of: " ", with: "")
        isYomikataFieldValid = noSpacesTransaltion!.count > 0
    }


    @objc fileprivate func translationFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.translationField.text?.replacingOccurrences(of: " ", with: "")
        isTranslationFieldValid = noSpacesTransaltion!.count > 0
    }


    fileprivate func valuesChanged()
    {
        if let callback = valuesChangedCallback {
            callback(isWordFieldValid && isYomikataFieldValid && isTranslationFieldValid)
        }
    }


    // MARK: - Public functions
    override func createWord(forGroup group: Group)
    {
        if let editWord = editWord as? JapaneseWord {
            editWord.word = wordField.text!
            editWord.yomikata = yomikataField.text!
            editWord.translation = translationField.text!
        } else {
            let word = WordsDataSource.sharedInstance.newWord(forGroup: group) as? JapaneseWord
            guard word != nil  else {
                fatalError("Couldn't create an instance of JapaneseWord")
            }

            word!.word = wordField.text!
            word!.yomikata = yomikataField.text!
            word!.translation = translationField.text!
        }
    }
}


extension EditJapaneseWordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == wordField {
            yomikataField.becomeFirstResponder()
        } else if textField == yomikataField {
            translationField.becomeFirstResponder()
        } else {
            wordField.becomeFirstResponder()
        }

        return true
    }
}
