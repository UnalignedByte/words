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
    var valuesChangedCallback: ((Bool) -> Void)?

    func createWord(forGroup group: Group)
    {
        fatalError("Abstract Class")
    }
}
