//
//  UIColor+Constructors.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex:Int, alpha:CGFloat) {
        let red = CGFloat(((hex >> 16) & 0xFF)) / 255.0
        let green = CGFloat(((hex >> 8) & 0xFF)) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    convenience init(hex:Int) {
        self.init(hex:hex, alpha:1.0)
    }
}