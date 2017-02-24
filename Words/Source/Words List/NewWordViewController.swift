//
//  NewWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 16/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class NewWordViewController: UIViewController
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addWordButton: UIButton!

    weak var editWordViewController: EditWordViewController?

    var group: Group?


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 8.0
        setupEditView()
    }


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


extension NewWordViewController
{
    func setup(forGroup group: Group)
    {
        self.group = group
    }
}


extension NewWordViewController
{
    fileprivate func setupEditView()
    {
        guard group != nil else {
            return
        }

        if let viewController = editWordViewController(forGroup: group!) {
            viewController.valuesChangedCallback = { [weak self] isValid in
                self?.wordValuesChanged(isValid: isValid)
            }
            addChildViewController(viewController)
            stackView.insertArrangedSubview(viewController.view, at: 0)
            self.editWordViewController = viewController
        }
    }


    fileprivate func editWordViewController(forGroup group: Group) -> EditWordViewController?
    {
        let identifier = String(describing: EditEnglishWordViewController.self)

        let controller = UIStoryboard(name: "WordsList", bundle: nil).instantiateViewController(withIdentifier: identifier)
        return controller as? EditWordViewController
    }
}
