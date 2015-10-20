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
    var name: String?
    var timeZone: NSTimeZone?
    
    override var description: String {
        return "<User username=\(username), name=\(name), timeZone=\(timeZone?.name)>"
    }
    
    init(userId: Int, username: String, name: String?, timeZone: NSTimeZone?) {
        print("id: \(userId), username: \(username)")
        self.userId = userId
        self.username = username
        self.name = name
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
        name = JSONUser["name"].string
        timeZone = JSONUser["timeZoneName"].string != nil ? NSTimeZone(name: JSONUser["timeZoneName"].stringValue) : nil

        super.init()
    }

}
