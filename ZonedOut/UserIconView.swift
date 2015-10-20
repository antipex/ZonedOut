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

    init(radius: CGFloat) {
        super.init(frame: CGRectZero)

        nameLabel.text = "UN"
        
        // UI setup
        backgroundColor = UIColor.lightGrayColor()
        layer.cornerRadius = radius
        
        nameLabel.font = UIFont.systemFontOfSize(18.0, weight: 2.0)
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

}
