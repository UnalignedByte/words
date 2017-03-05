//
//  EditWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 16/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditWordViewController: UIViewController
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addWordButton: UIButton!

    fileprivate weak var editWordViewController: EditBaseWordViewController?

    fileprivate var group: Group?
    fileprivate var editWord: Word?


    // MARK: - Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 8.0

        if editWord != nil {
            addWordButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        }

       setupEditView()
    }


    func setup(forGroup group: Group, editWord: Word?)
    {
        self.group = group
        self.editWord = editWord
    }


    fileprivate func setupEditView()
    {
        guard group != nil else {
            fatalError("Group cannot be nil")
        }

        let viewController = group!.language.editBaseWordViewController
        viewController.valuesChangedCallback = { [weak self] isValid in
            self?.wordValuesChanged(isValid: isValid)
        }
        viewController.editWord = editWord
        addChildViewController(viewController)
        stackView.insertArrangedSubview(viewController.view, at: 0)
        self.editWordViewController = viewController
    }


    // MARK: - Actions
    @IBAction func addWordButtonPressed(sender: UIButton)
    {
        guard group != nil else {
            return
        }

        editWordViewController?.createWord(forGroup: group!)

        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func cancelButtonPressed(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }


    func wordValuesChanged(isValid: Bool)
    {
        self.addWordButton.isEnabled = isValid
    }
}
