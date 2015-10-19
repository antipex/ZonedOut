//
//  User.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class User: NSObject {

    static let sharedUser = User()

    var currentPerson: Person? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ZonedOut.Notification.UserSessionStateChanged, object: nil)
            NSLog("User changed: %@", currentPerson != nil ? currentPerson! : "nil")
        }
    }

}
