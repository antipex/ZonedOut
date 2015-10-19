//
//  Person.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SwiftyJSON

class Person: NSObject {
    
    var personId: Int
    var username: String
    var name: String?
    var timeZone: NSTimeZone?
    
    override var description: String {
        return "<Person username=\(username), name=\(name), timeZone=\(timeZone?.name)>"
    }
    
    init(personId: Int, username: String, name: String?, timeZone: NSTimeZone?) {
        print("id: \(personId), username: \(username)")
        self.personId = personId
        self.username = username
        self.name = name
        self.timeZone = timeZone
        
        super.init()
    }

    init(rawJSON: AnyObject) {
        let swiftyPerson = JSON(rawJSON)

        personId = swiftyPerson["id"].intValue
        username = swiftyPerson["username"].stringValue
        name = swiftyPerson["name"].string
        timeZone = swiftyPerson["timeZoneName"].string != nil ? NSTimeZone(name: swiftyPerson["timeZoneName"].stringValue) : nil
    }

}
