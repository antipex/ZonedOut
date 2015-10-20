//
//  StatusView.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class StatusView: UIView {

    var iconView = UserIconView(radius: 22.0)

    var contentContainer = UIView()
    var infoLabel = UILabel()
    var timeZoneLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        infoLabel.text = "I'm Currently In".uppercaseString

        for subview in [iconView, contentContainer] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }

        for contentView in [infoLabel, timeZoneLabel] {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentContainer.addSubview(contentView)
        }

        let views = [
            "iconView": iconView,
            "contentContainer": contentContainer
        ]

        let metrics = [
            "iconSize": 44.0
        ]

        let formats = [
            "H:|-[iconView(==iconSize)]-[contentContainer]-|",
            "V:|[iconView]|",
            "V:|[contentContainer]|"
        ]

        for format in formats {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
            )
        }

        // Content container views

        let containerViews = [
            "infoLabel": infoLabel,
            "timeZoneLabel": timeZoneLabel
        ]

        let containerFormats = [
            "H:|[infoLabel]|",
            "H:|[timeZoneLabel]|",
            "V:|[infoLabel]-[timeZoneLabel]|"
        ]

        for format in containerFormats {
            contentContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: containerViews)
            )
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSessionStateChanged:", name: ZonedOut.Notification.UserSessionStateChanged, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func userSessionStateChanged(notification: NSNotification) {
        refresh()
    }

    func refresh() {
        guard let currentUser = UserSession.sharedSession.currentUser else {
            iconView.nameLabel.text = "UN"
            timeZoneLabel.text = ""

            return
        }

        iconView.nameLabel.text = currentUser.initials
        timeZoneLabel.text = currentUser.timeZone?.name
    }

}
