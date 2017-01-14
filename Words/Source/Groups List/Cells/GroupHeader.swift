//
//  GroupHeader.swift
//  Words
//
//  Created by Rafal Grodzinski on 14/01/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class GroupHeader: UITableViewHeaderFooterView
{
    static var identifier: String {
        get {
            return "GroupHeader"
        }
    }

    @IBOutlet private var label: UILabel!
    private var callback: (() -> Void)!


    func setup(withLanguageCode code: String, callback: @escaping () -> Void)
    {
        self.label.text = code
        self.callback = callback
    }


    @IBAction func didSelect(sender: UIButton)
    {
        self.callback()
    }
}
