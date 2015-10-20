//
//  OverviewHeaderView.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class OverviewHeaderView: UIView {

    var titleLabel = UILabel()
    var timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = UIFont.systemFontOfSize(12.0, weight: UIFontWeightBlack)
        timeLabel.font = UIFont.systemFontOfSize(12.0, weight: UIFontWeightLight)

        for subview in [titleLabel, timeLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }

        let views = [
            "titleLabel": titleLabel,
            "timeLabel": timeLabel
        ]

        let metrics = [
            "sidePadding": 18.0,
            "bottomPadding": 6.0
        ]

        let formats = [
            "H:|-(sidePadding)-[titleLabel]",
            "H:[timeLabel]-(sidePadding)-|",
            "V:[titleLabel]-(bottomPadding)-|",
            "V:[timeLabel]-(bottomPadding)-|"
        ]

        for format in formats {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
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

}
