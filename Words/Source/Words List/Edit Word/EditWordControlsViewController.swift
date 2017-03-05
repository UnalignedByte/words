//
//  EditWordControlsViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 16/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditWordControlsViewController: UIViewController
{
    var valuesChangedCallback: ((Bool) -> Void)?
    var editWord: Word?

    func createWord(forGroup group: Group)
    {
        fatalError("Abstract Class")
    }
}
