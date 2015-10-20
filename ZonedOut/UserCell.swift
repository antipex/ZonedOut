//
//  UserCell.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    var user: User? {
        didSet {
            setupCell()
        }
    }
    
    var iconView = UserIconView(radius: 22.0)
    var fullNameLabel = UILabel()
    
    static let PreferredHeight: CGFloat = 66.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for view in [iconView, fullNameLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        let views = [
            "fullNameLabel": fullNameLabel,
            "iconView": iconView
        ]
        
        let metrics = [
            "iconSize": 44.0
        ]
        
        let formats = [
            "H:|-[iconView(==iconSize)]-[fullNameLabel]|",
            "V:|-[iconView]-|",
            "V:|[fullNameLabel]|"
        ]
        
        for format in formats {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        guard let user = user else {
            return
        }
        
        iconView.nameLabel.text = user.initials
        fullNameLabel.text = user.fullName
        
    }
    
}

    