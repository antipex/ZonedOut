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

    class func getUser(userId: Int, completion: APICompletionClosure?) {
        return API.getUser(userId, username: nil, completion: completion)
    }
    
    class func getUser(username: String, completion: APICompletionClosure?) {
        return API.getUser(nil, username: username, completion: completion)
    }

    class func getUser(userId: Int?, username: String?, completion: APICompletionClosure?) {
        var params = [String: AnyObject]()
        
        if let userId = userId {
            params["id"] = userId
        }
        
        if let username = username {
            params["username"] = username
        }
        
        Alamofire.request(.GET, "\(API.BaseURL)/user", parameters: params, encoding: .JSON, headers: nil).responseJSON { response in

            completion?(response)
        }
    }
    
    class func addUser(username: String, password: String, email: String, firstName: String, lastName: String, timeZoneName: String? = nil, completion: APICompletionClosure?) {
        
        var params = [
            "username": username,
            "password": password,
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        if let timeZoneName = timeZoneName {
            params["timeZoneName"] = timeZoneName
        }
        
        Alamofire.request(.POST, "\(API.BaseURL)/user", parameters: params, encoding: .JSON, headers: nil).responseJSON { response in

            completion?(response)
        }
        
    }

    class func getAllUsers(completion: APICompletionClosure?) {
        Alamofire.request(.GET, "\(API.BaseURL)/users").responseJSON { response in

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

    class func logout(completion: APICompletionClosure?) {
        Alamofire.request(.POST, "\(API.BaseURL)/user/logout").responseJSON { response in

            completion?(response)
        }
    }
    
}
