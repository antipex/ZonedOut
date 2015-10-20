//
//  Person.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    
    var userId: Int
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var timeZone: NSTimeZone?

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    var initials: String {
        let firstInitial = firstName.firstCharacter
        let secondInitial = lastName.firstCharacter

        return "\(firstInitial)\(secondInitial)"
    }
    
    override var description: String {
        return "<User username=\(username), name=\(fullName), timeZone=\(timeZone?.name)>"
    }
    
    init(userId: Int, username: String, email: String, firstName: String, lastName: String, timeZone: NSTimeZone?) {
        print("id: \(userId), username: \(username)")
        self.userId = userId
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.timeZone = timeZone
        
        super.init()
    }

    convenience init(rawJSON: AnyObject) {
        let JSONUser = JSON(rawJSON)

        self.init(JSONUser: JSONUser)
    }

    init(JSONUser: JSON) {
        userId = JSONUser["id"].intValue
        username = JSONUser["username"].stringValue
        email = JSONUser["email"].stringValue
        firstName = JSONUser["firstName"].stringValue
        lastName = JSONUser["lastName"].stringValue
        timeZone = JSONUser["timeZoneName"].string != nil ? NSTimeZone(name: JSONUser["timeZoneName"].stringValue) : nil

        super.init()
    }

}
