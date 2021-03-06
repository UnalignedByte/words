//
//  EditChineseWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 26/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditChineseWordViewController: EditWordControlsViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordField: UITextField!
    @IBOutlet fileprivate weak var pinyinField: UITextField!
    @IBOutlet fileprivate weak var translationField: UITextField!

    fileprivate var toneOneButton: UIButton!
    fileprivate var toneTwoButton: UIButton!
    fileprivate var toneThreeButton: UIButton!
    fileprivate var toneFourButton: UIButton!
    fileprivate var toneFiveButton: UIButton!

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
                                               name: UITextField.textDidChangeNotification, object: self.wordField)
        NotificationCenter.default.addObserver(self, selector: #selector(pinyinFieldChanged(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.pinyinField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.translationField)

        setupTextAccessoryView()
        setupToneButtons(forCharacter: nil)

        pinyinField.addObserver(self, forKeyPath: #keyPath(UITextField.selectedTextRange), options: .new, context: nil)

        if let editWord = editWord as? ChineseWord {
            wordField.text = editWord.word
            pinyinField.text = editWord.pinyin
            translationField.text = editWord.translation
            isWordFieldValid = true
            isPinyinFieldValid = true
            isTranslationFieldValid = true
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        if keyPath == #keyPath(UITextField.selectedTextRange) {
            if let start = pinyinField.selectedTextRange?.start {
                let offset = pinyinField.offset(from: pinyinField.beginningOfDocument, to: start)
                let character = extractTonedCharacter(fromString: pinyinField.text!, leftFromOffset: offset)
                setupToneButtons(forCharacter: character)
            }
        }
    }


    fileprivate func setupTextAccessoryView()
    {
        let backgroundColor = UIColor(red: 202.0/255.0, green: 205.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let buttonColor = UIColor(red: 179.0/255.0, green: 186.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        let pressedButtonColor = UIColor(red: 232.0/255.0, green: 234.0/255.0, blue: 237.0/255.0, alpha: 1.0)

        let width = Double(UIScreen.main.bounds.width)
        let height = 36.0

        // Accessory View
        let accessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        accessoryView.backgroundColor = backgroundColor

        // Buttons Stack
        let toneButtonsStack = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        toneButtonsStack.distribution = .fillEqually
        toneButtonsStack.spacing = 1.0
        accessoryView.addSubview(toneButtonsStack)

        // ¯
        toneOneButton = UIButton(type: .custom)
        toneOneButton.setTitle("¯", for: .normal)
        toneOneButton.setTitleColor(UIColor.white, for: .normal)
        toneOneButton.setTitleColor(UIColor.black, for: .highlighted)
        toneOneButton.setNormalBackgroundColor(buttonColor)
        toneOneButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneOneButton.addTarget(self, action: #selector(toneOneButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneOneButton, at: 0)

        // ´
        toneTwoButton = UIButton(type: .custom)
        toneTwoButton.setTitle("´", for: .normal)
        toneTwoButton.setTitleColor(UIColor.white, for: .normal)
        toneTwoButton.setTitleColor(UIColor.black, for: .highlighted)
        toneTwoButton.setNormalBackgroundColor(buttonColor)
        toneTwoButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneTwoButton.addTarget(self, action: #selector(toneTwoButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneTwoButton, at: 1)

        // `
        toneThreeButton = UIButton(type: .custom)
        toneThreeButton.setTitle("`", for: .normal)
        toneThreeButton.setTitleColor(UIColor.white, for: .normal)
        toneThreeButton.setTitleColor(UIColor.black, for: .highlighted)
        toneThreeButton.setNormalBackgroundColor(buttonColor)
        toneThreeButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneThreeButton.addTarget(self, action: #selector(toneThreeButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneThreeButton, at: 2)

        // ˇ
        toneFourButton = UIButton(type: .custom)
        toneFourButton.setTitle("ˇ", for: .normal)
        toneFourButton.setTitleColor(UIColor.white, for: .normal)
        toneFourButton.setTitleColor(UIColor.black, for: .highlighted)
        toneFourButton.setNormalBackgroundColor(buttonColor)
        toneFourButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneFourButton.addTarget(self, action: #selector(toneFourButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneFourButton, at: 3)

        //  ̌̈
        toneFiveButton = UIButton(type: .custom)
        toneFiveButton.setTitle(" ̌̈", for: .normal)
        toneFiveButton.setTitleColor(UIColor.white, for: .normal)
        toneFiveButton.setTitleColor(UIColor.black, for: .highlighted)
        toneFiveButton.setNormalBackgroundColor(buttonColor)
        toneFiveButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneFiveButton.addTarget(self, action: #selector(toneFiveButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneFiveButton, at: 4)

        pinyinField.inputAccessoryView = accessoryView
    }


    fileprivate func countOfUnicodeTones(inString string: String, leftFromOffset offset: Int) -> Int
    {
        guard offset > 0 else {
            return 0
        }

        let scalarToTheLeft = string.unicodeScalars[string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: offset - 1)]

        let isToneOne = scalarToTheLeft == UnicodeScalar("\u{0304}")
        let isToneTwo = scalarToTheLeft == UnicodeScalar("\u{0341}")
        let isToneThree = scalarToTheLeft == UnicodeScalar("\u{0340}")
        let isToneFour = scalarToTheLeft == UnicodeScalar("\u{030c}")
        var isToneFive = false
        if offset > 1 {
            let scalarToTheLeftLeft = string.unicodeScalars[string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: offset - 2)]
            let isToneFiveFirst = scalarToTheLeftLeft == UnicodeScalar("\u{030c}")
            let isToneFiveSecond = scalarToTheLeft == UnicodeScalar("\u{0308}")
            isToneFive = isToneFiveFirst && isToneFiveSecond
        }

        if isToneOne || isToneTwo || isToneThree || isToneFour {
            return 1
        } else if isToneFive {
            return 2
        } else {
            return 0
        }
    }


    fileprivate func extractTonedCharacter(fromString string: String, leftFromOffset offset: Int) -> Character?
    {
        guard offset > 0 else {
            return nil
        }

        let unicodeTonesCount = countOfUnicodeTones(inString: string, leftFromOffset: offset)
        let unicodeCharacter = string.unicodeScalars[string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: offset - unicodeTonesCount - 1)]
        let character = Character(unicodeCharacter)
        guard character != " " else {
            return nil
        }

        return character
    }


    fileprivate func replaceToneCharacter(inString string: inout String, leftFromOffset offset: Int, withToneCharacter toneCharacter: Character)
    {
        let unicodeTonesCount = countOfUnicodeTones(inString: string, leftFromOffset: offset)
        let startOffset = offset - unicodeTonesCount

        // Rmove tone unicodes from the string
        let unicodeTonesToRemoveStart = string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: startOffset)
        let unicodeTonesToRemoveEnd = string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: offset)
        if unicodeTonesToRemoveStart != unicodeTonesToRemoveEnd {
            let unicodeTonesToRemoveRange = unicodeTonesToRemoveStart..<unicodeTonesToRemoveEnd
            string.unicodeScalars.removeSubrange(unicodeTonesToRemoveRange)
        }

        // Insert new tone unicodes
        let toneCharacterString = "\(toneCharacter)"

        for offset in startOffset..<startOffset+toneCharacterString.unicodeScalars.count {
            let toneCharacterScalarIndex = toneCharacterString.unicodeScalars.index(toneCharacterString.unicodeScalars.startIndex, offsetBy: offset - startOffset)
            let toneCharacterScalar = toneCharacterString.unicodeScalars[toneCharacterScalarIndex]

            let insertScalarIndex = string.unicodeScalars.index(string.unicodeScalars.startIndex, offsetBy: offset)
            string.unicodeScalars.insert(toneCharacterScalar, at: insertScalarIndex)
        }
    }


    fileprivate func setupToneButtons(forCharacter character: Character?)
    {
        if let character = character {
            pinyinField.inputAccessoryView?.isHidden = false

            toneOneButton.setTitle("\(character)\u{0304}", for: .normal)
            toneTwoButton.setTitle("\(character)\u{0341}", for: .normal)
            toneThreeButton.setTitle("\(character)\u{0340}", for: .normal)
            toneFourButton.setTitle("\(character)\u{030c}", for: .normal)
            toneFiveButton.setTitle("\(character)\u{030c}\u{0308}", for: .normal)
        } else {
            pinyinField.inputAccessoryView?.isHidden = true
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
        pinyinField.resignFirstResponder()
        translationField.resignFirstResponder()
    }


    deinit
    {
        NotificationCenter.default.removeObserver(self)
        pinyinField.removeObserver(self, forKeyPath: #keyPath(UITextField.selectedTextRange))
    }


    // MARK: - Private functions
    @objc fileprivate func wordFieldChanged(notification: Notification)
    {
        let noSpacesWord = self.wordField.text?.replacingOccurrences(of: " ", with: "")
        isWordFieldValid = noSpacesWord!.count > 0
    }


    @objc fileprivate func pinyinFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.pinyinField.text?.replacingOccurrences(of: " ", with: "")
        isPinyinFieldValid = noSpacesTransaltion!.count > 0
    }


    @objc fileprivate func translationFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.translationField.text?.replacingOccurrences(of: " ", with: "")
        isTranslationFieldValid = noSpacesTransaltion!.count > 0
    }


    fileprivate func valuesChanged()
    {
        if let callback = valuesChangedCallback {
            callback(isWordFieldValid && isPinyinFieldValid && isTranslationFieldValid)
        }
    }


    // MARK: - Actions
    @objc func toneOneButtonPressed(sender: UIButton)
    {
        appendAccent(character: "\u{0304}")
    }


    @objc func toneTwoButtonPressed(sender: UIButton)
    {
        appendAccent(character: "\u{0341}")
    }


    @objc func toneThreeButtonPressed(sender: UIButton)
    {
        appendAccent(character: "\u{0340}")
    }


    @objc func toneFourButtonPressed(sender: UIButton)
    {
        appendAccent(character: "\u{030c}")
    }


    @objc func toneFiveButtonPressed(sender: UIButton)
    {
        appendAccent(character: "\u{030c}\u{0308}")
    }


    fileprivate func appendAccent(character: Character)
    {
        // Get info on current state of affairs
        let cursorOffset = pinyinField.offset(from: pinyinField.beginningOfDocument, to: pinyinField.selectedTextRange!.start)
        let unicodeTonesCount = countOfUnicodeTones(inString: pinyinField.text!, leftFromOffset: cursorOffset)

        // Change the tone scalars
        replaceToneCharacter(inString: &pinyinField.text!, leftFromOffset: cursorOffset, withToneCharacter: character)

        // Calculate new cursor offset based on old and new tone unicode scalars
        let newCursorOffset = cursorOffset + "\(character)".unicodeScalars.count - unicodeTonesCount
        let newCursorTextPosition = pinyinField.position(from: pinyinField.beginningOfDocument,
                                                         offset: newCursorOffset)
        let newCursorTextRange = pinyinField.textRange(from: newCursorTextPosition!,
                                                       to: newCursorTextPosition!)
        // Update the cursor position
        pinyinField.selectedTextRange = newCursorTextRange
    }


    // MARK: - Public functions
    override func createWord(forGroup group: Group)
    {
        if let editWord = editWord as? ChineseWord {
            editWord.word = wordField.text!
            editWord.pinyin = pinyinField.text!
            editWord.translation = translationField.text!
        } else {
            let word = WordsDataSource.sharedInstance.newWord(forGroup: group) as? ChineseWord
            guard word != nil  else {
                fatalError("Couldn't create an instance of ChineseWord")
            }

            word!.word = wordField.text!
            word!.pinyin = pinyinField.text!
            word!.translation = translationField.text!
        }
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


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField != pinyinField {
            return true
        }

        if string != "" {
            let replacedString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            let offset = pinyinField.offset(from: pinyinField.beginningOfDocument,
                                            to: textField.selectedTextRange!.start) + string.unicodeScalars.count
            let character = extractTonedCharacter(fromString: replacedString, leftFromOffset: offset)
            setupToneButtons(forCharacter: character)
        } else  {
            let offset = pinyinField.offset(from: pinyinField.beginningOfDocument, to: textField.selectedTextRange!.start)

            // Place cursor at the right spot
            let count = countOfUnicodeTones(inString: textField.text!, leftFromOffset: offset)
            let newCursorTextPosition = pinyinField.position(from: textField.beginningOfDocument,
                                                             offset: offset - count)
            let newCursorTextRange = pinyinField.textRange(from: newCursorTextPosition!,
                                                           to: newCursorTextPosition!)
            // Update the cursor position
            textField.selectedTextRange = newCursorTextRange

            // Tones buttons
            let character = extractTonedCharacter(fromString: textField.text!, leftFromOffset: offset - count - 1)
            setupToneButtons(forCharacter: character)
        }

        return true
    }
}
