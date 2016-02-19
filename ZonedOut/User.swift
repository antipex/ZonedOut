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

    /// First and last name separated by a space
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    /// Capital initials based on first character of first and last names
    var initials: String {
        let firstInitial = firstName.firstCharacter
        let secondInitial = lastName.firstCharacter

        return "\(firstInitial)\(secondInitial)"
    }
    
    override var description: String {
        return "<User username=\(username), name=\(fullName), timeZone=\(timeZone?.name)>"
    }

    /**
     Init a new `User` with specified properties

     - parameter userId:    User ID
     - parameter username:  Username
     - parameter email:     Email address
     - parameter firstName: First name
     - parameter lastName:  Last name
     - parameter timeZone:  Time zone

     - returns: A new instance of `User`
     */
    init(userId: Int, username: String, email: String, firstName: String, lastName: String, timeZone: NSTimeZone?) {
        self.userId = userId
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.timeZone = timeZone
        
        super.init()
    }

    /**
     Init a new `User` with a raw JSON dictionary

     - parameter rawJSON: JSON dictionary

     - returns: A new instance of `User`
     */
    convenience init(rawJSON: AnyObject) {
        let JSONUser = JSON(rawJSON)

        self.init(JSONUser: JSONUser)
    }

    /**
     Init a new `User` with a prepopulated JSON object

     - parameter JSONUser: JSON object

     - returns: A new instance of `User`
     */
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
