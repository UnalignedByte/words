//
//  EditEnglishWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 16/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditEnglishWordViewController: EditWordViewController
{
    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var translationField: UITextField!

    var isWordFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    var isTranslationFieldValid = false {
        didSet {
            valuesChanged()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(wordFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.wordField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.translationField)
    }


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

    override func createWord(forGroup group: Group)
    {
        let word = WordsDataSource.sharedInstance.newWord(forGroup: group)
        word.word = wordField.text!
        word.translation = translationField.text!
    }
}
