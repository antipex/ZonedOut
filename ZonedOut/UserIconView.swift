//
//  UserIconView.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 16/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class UserIconView: UIView {
    
    var name = "Unknown" {
        didSet {
            // Format the name label correctly
            nameLabel.text = name.substringToIndex(name.startIndex)
        }
    }
    
    var nameLabel = UILabel()

    init(name: String, radius: CGFloat) {
        super.init(frame: CGRectZero)
        
        self.name = name
        
        // UI setup
        backgroundColor = UIColor.grayColor()
        layer.cornerRadius = radius
        
        nameLabel.font = UIFont.systemFontOfSize(16.0, weight: 2.0)
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
