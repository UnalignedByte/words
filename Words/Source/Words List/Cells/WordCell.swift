//
//  WordCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 26/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class WordCell: UITableViewCell
{
    override func awakeFromNib()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.lightGray.withAlphaComponent(0.1).cgColor,
                                UIColor.lightGray.withAlphaComponent(0.25).cgColor]
        
        backgroundView = UIView()
        backgroundView?.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.layer.sublayers?.first?.frame = bounds
    }
    
    
    func setup(withWord word: Word, config: Int)
    {
        fatalError("Abstract Class")
    }
}
