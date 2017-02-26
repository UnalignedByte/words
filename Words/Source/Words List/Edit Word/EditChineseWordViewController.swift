//
//  EditChineseWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 26/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditChineseWordViewController: EditWordViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordField: UITextField!
    @IBOutlet fileprivate weak var pinyinField: UITextField!
    @IBOutlet fileprivate weak var translationField: UITextField!

    fileprivate var isWordFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    fileprivate var isPinyinFieldValid = false {
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
        NotificationCenter.default.addObserver(self, selector: #selector(pinyinFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.pinyinField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.translationField)
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
        pinyinField.resignFirstResponder()
        translationField.resignFirstResponder()
    }


    // MARK: - Private functions
    @objc fileprivate func wordFieldChanged(notification: Notification)
    {
        let noSpacesWord = self.wordField.text?.replacingOccurrences(of: " ", with: "")
        isWordFieldValid = noSpacesWord!.characters.count > 0
    }


    @objc fileprivate func pinyinFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.pinyinField.text?.replacingOccurrences(of: " ", with: "")
        isPinyinFieldValid = noSpacesTransaltion!.characters.count > 0
    }


    @objc fileprivate func translationFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.translationField.text?.replacingOccurrences(of: " ", with: "")
        isTranslationFieldValid = noSpacesTransaltion!.characters.count > 0
    }


    fileprivate func valuesChanged()
    {
        if let callback = valuesChangedCallback {
            callback(isWordFieldValid && isPinyinFieldValid && isTranslationFieldValid)
        }
    }

    // MARK: - Public functions
    override func createWord(forGroup group: Group)
    {
        let word = WordsDataSource.sharedInstance.newWord(forGroup: group) as? ChineseWord
        guard word != nil  else {
            fatalError("Couldn't create an instance of ChineseWord")
        }

        word!.word = wordField.text!
        word!.pinyin = pinyinField.text!
        word!.translation = translationField.text!
    }
}


extension EditChineseWordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == wordField {
            pinyinField.becomeFirstResponder()
        } else if textField == pinyinField {
            translationField.becomeFirstResponder()
        } else {
            wordField.becomeFirstResponder()
        }

        return true
    }
}
