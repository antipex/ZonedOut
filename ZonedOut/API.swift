//
//  API.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API {

    static let BaseURL = "http://localhost/~kyle/zoned-out-api"

    typealias APICompletionClosure = (Response<AnyObject, NSError>) -> Void

    private class func personFromRawPerson(rawPerson: AnyObject) -> Person {
        let swiftyPerson = JSON(rawPerson)

        let person = Person(
            personId: swiftyPerson["id"].intValue,
            username: swiftyPerson["username"].stringValue,
            name: swiftyPerson["name"].string,
            timeZone: swiftyPerson["timeZoneName"].string != nil ? NSTimeZone(name: swiftyPerson["timeZoneName"].stringValue) : nil
        )

        return person
    }

    class func getPerson(personId: Int, completion: APICompletionClosure?) {
        return API.getPerson(personId, username: nil, completion: completion)
    }
    
    class func getPerson(username: String, completion: APICompletionClosure?) {
        return API.getPerson(nil, username: username, completion: completion)
    }

    class func getPerson(personId: Int?, username: String?, completion: APICompletionClosure?) {
        var params = [String: AnyObject]()
        
        if let personId = personId {
            params["id"] = personId
        }
        
        if let username = username {
            params["username"] = username
        }
        
        Alamofire.request(.GET, "\(API.BaseURL)/user", parameters: params, encoding: .JSON, headers: nil).responseJSON { response in

            completion?(response)
        }
    }
    
    class func addPerson(username: String, password: String, name: String? = nil, timeZoneName: String? = nil, completion: APICompletionClosure?) {
        
        var params = [
            "username": username,
            "password": password
        ]
        
        if let name = name {
            params["name"] = name
        }
        
        if let timeZoneName = timeZoneName {
            params["timeZoneName"] = timeZoneName
        }
        
        Alamofire.request(.POST, "\(API.BaseURL)/user", parameters: params, encoding: .JSON, headers: nil).responseJSON { response in

            completion?(response)
        }
        
    }

    class func checkLogin(completion: APICompletionClosure?) {
        Alamofire.request(.GET, "\(API.BaseURL)/user").responseJSON { response in

            completion?(response)
        }
    }

    class func login(username: String, password: String, completion: APICompletionClosure?) {
        let params = [
            "username": username,
            "password": password
        ]

        Alamofire.request(.POST, "\(API.BaseURL)/user/login", parameters: params, encoding: .JSON, headers: nil).responseJSON { response in

            completion?(response)
        }
    }
    
}
