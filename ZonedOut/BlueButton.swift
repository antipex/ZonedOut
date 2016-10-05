//
//  BlueButton.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class BlueButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = UIColor(hex: 0x235da2)
        layer.cornerRadius = 3.0
        setTitleColor(UIColor.white, for: UIControlState())
    }

}
