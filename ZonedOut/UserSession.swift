//
//  User.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class UserSession: NSObject {

    static let sharedSession = UserSession()

    var currentUser: User? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ZonedOut.Notification.UserSessionStateChanged, object: nil)
            NSLog("User changed: %@", currentUser != nil ? currentUser! : "nil")
        }
    }

}
