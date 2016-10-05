//
//  StatusView.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

protocol StatusViewDelegate {
    func statusViewDidTap(_ statusView: StatusView)
}

class StatusView: UIView {

    var iconView = UserIconView(radius: 16.0)

    var contentContainer = UIView()
    var infoLabel = UILabel()
    var timeZoneLabel = UILabel()

    var tapGesture = UITapGestureRecognizer()

    var tapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true

        infoLabel.text = "I'm Currently In".uppercased()
        infoLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightLight)
        infoLabel.textColor = UIColor.white
        timeZoneLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
        timeZoneLabel.textColor = UIColor.white

        // Auto Layout

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
            "padding": 8.0,
            "iconSize": 32.0
        ]

        let formats = [
            "H:|-[iconView(==iconSize)]-[contentContainer]-|",
            "V:[iconView(==iconSize)]",
            "V:|-(padding)-[contentContainer]-(padding)-|"
        ]

        for format in formats {
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
            )
        }

        addConstraint(NSLayoutConstraint(
            item: iconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        )

        // Content container views

        let containerViews = [
            "infoLabel": infoLabel,
            "timeZoneLabel": timeZoneLabel
        ]

        let containerMetrics = [
            "labelSpacing": 4.0
        ]

        let containerFormats = [
            "H:|[infoLabel]|",
            "H:|[timeZoneLabel]|",
            "V:|[infoLabel][timeZoneLabel]|"
        ]

        for format in containerFormats {
            contentContainer.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: format,
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: containerMetrics,
                views: containerViews)
            )
        }

        NotificationCenter.default.addObserver(self, selector: #selector(StatusView.userSessionStateChanged(_:)), name: NSNotification.Name(rawValue: ZonedOut.Notification.UserSessionStateChanged), object: nil)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(StatusView.tappedStatusView(_:)))

        addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)

        removeGestureRecognizer(tapGesture)
    }

    func userSessionStateChanged(_ notification: Notification) {
        refresh()
    }

    func refresh() {
        guard let currentUser = UserSession.sharedSession.currentUser else {
            iconView.nameLabel.text = "UN"
            timeZoneLabel.text = ""

            return
        }

        iconView.nameLabel.text = currentUser.initials
        timeZoneLabel.text = currentUser.timeZone?.displayName
    }

    func tappedStatusView(_ recognizer: UITapGestureRecognizer) {
        tapHandler?()
    }

}
