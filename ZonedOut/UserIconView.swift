//
//  UserIconView.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 16/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class UserIconView: UIView {
    
    var nameLabel = UILabel()

    let backgroundColours = [
        UIColor(hex: 0x7ed321),
        UIColor(hex: 0xf5a623),
        UIColor(hex: 0x4a90e2)
    ]

    var index: Int = 0 {
        didSet {
            refreshBackgroundColor()
        }
    }

    init(radius: CGFloat, index: Int = 0) {
        super.init(frame: CGRectZero)

        nameLabel.text = "UN"
        
        // UI setup
        self.index = index
        refreshBackgroundColor()
        layer.cornerRadius = radius
        
        nameLabel.font = UIFont.systemFontOfSize(0.81 * radius, weight: UIFontWeightBold)
        nameLabel.textColor = UIColor.darkGrayColor()
        nameLabel.textAlignment = .Center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Add constraints
        let views = ["nameLabel": nameLabel]
        
        let formats = [
            "H:|[nameLabel]|",
            "V:|[nameLabel]|"
        ]
        
        for format in formats {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: views)
            )
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func refreshBackgroundColor() {
        print(index % 3)
        backgroundColor = backgroundColours[index % 3]
    }

}
