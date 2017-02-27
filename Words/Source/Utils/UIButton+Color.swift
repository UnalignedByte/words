//
//  UIButton+Color.swift
//  Words
//
//  Created by Rafal Grodzinski on 27/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit
import CoreGraphics


extension UIButton
{
    func setNormalBackgroundColor(_ color: UIColor)
    {
        let colorImage = image(forColor: color)
        setBackgroundImage(colorImage, for: .normal)
    }


    func setHighlightedBackgroundColor(_ color: UIColor)
    {
        let colorImage = image(forColor: color)
        setBackgroundImage(colorImage, for: .highlighted)
    }


    fileprivate func image(forColor color: UIColor) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return colorImage!
    }
}
