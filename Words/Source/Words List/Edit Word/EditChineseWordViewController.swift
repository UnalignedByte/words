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

        setupTextAccessoryView()
    }


    fileprivate func setupTextAccessoryView()
    {
        let buttonColor = UIColor(colorLiteralRed: 202.0/255.0, green: 205.0/255.0, blue: 211.0/255.0, alpha: 1.0)

        // Buttons Stack
        let buttonsStack = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 2.0

        // ¯
        let toneOneButton = UIButton(type: .system)
        toneOneButton.setTitle("¯", for: .normal)
        toneOneButton.backgroundColor = buttonColor
        toneOneButton.layer.cornerRadius = 8.0
        toneOneButton.addTarget(self, action: #selector(toneOneButtonPressed(sender:)), for: .touchUpInside)
        buttonsStack.insertArrangedSubview(toneOneButton, at: 0)

        // ´
        let toneTwoButton = UIButton(type: .system)
        toneTwoButton.setTitle("´", for: .normal)
        toneTwoButton.backgroundColor = buttonColor
        toneTwoButton.layer.cornerRadius = 8.0
        toneTwoButton.addTarget(self, action: #selector(toneTwoButtonPressed(sender:)), for: .touchUpInside)
        buttonsStack.insertArrangedSubview(toneTwoButton, at: 1)

        // `
        let toneThreeButton = UIButton(type: .system)
        toneThreeButton.setTitle("`", for: .normal)
        toneThreeButton.backgroundColor = buttonColor
        toneThreeButton.layer.cornerRadius = 8.0
        toneThreeButton.addTarget(self, action: #selector(toneThreeButtonPressed(sender:)), for: .touchUpInside)
        buttonsStack.insertArrangedSubview(toneThreeButton, at: 2)

        // ˇ
        let toneFourButton = UIButton(type: .system)
        toneFourButton.setTitle("ˇ", for: .normal)
        toneFourButton.backgroundColor = buttonColor
        toneFourButton.layer.cornerRadius = 8.0
        toneFourButton.addTarget(self, action: #selector(toneFourButtonPressed(sender:)), for: .touchUpInside)
        buttonsStack.insertArrangedSubview(toneFourButton, at: 3)

        //  ̌̈
        let toneFiveButton = UIButton(type: .system)
        toneFiveButton.setTitle(" ̌̈", for: .normal)
        toneFiveButton.backgroundColor = buttonColor
        toneFiveButton.layer.cornerRadius = 8.0
        toneFiveButton.addTarget(self, action: #selector(toneFiveButtonPressed(sender:)), for: .touchUpInside)
        buttonsStack.insertArrangedSubview(toneFiveButton, at: 4)

        pinyinField.inputAccessoryView = buttonsStack
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


    // MARK: - Actions
    func toneOneButtonPressed(sender: UIButton)
    {
        self.pinyinField.text?.append("\u{0304}")
    }


    func toneTwoButtonPressed(sender: UIButton)
    {
        self.pinyinField.text?.append("\u{0341}")
    }


    func toneThreeButtonPressed(sender: UIButton)
    {
        self.pinyinField.text?.append("\u{0340}")
    }


    func toneFourButtonPressed(sender: UIButton)
    {
        self.pinyinField.text?.append("\u{030c}")
    }


    func toneFiveButtonPressed(sender: UIButton)
    {
        self.pinyinField.text?.append("\u{030c}\u{0308}")
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
