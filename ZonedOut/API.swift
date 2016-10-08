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

    /// Base URL for API requests without trailing slash
    static let BaseURL = "http://zonedout.antipex.com"

    typealias APICompletionClosure = (DataResponse<Any>) -> Void

    /**
     Fetch a user account by ID

     - parameter userId:     User ID to fetch
     - parameter completion: `APICompletionClosure`
     */
    class func getUser(_ userId: Int, completion: APICompletionClosure?) {
        return API.getUser(userId, username: nil, completion: completion)
    }

    /**
     Fetch a user account by username

     - parameter username:   Username to fetch
     - parameter completion: `APICompletionClosure`
     */
    class func getUser(_ username: String, completion: APICompletionClosure?) {
        return API.getUser(nil, username: username, completion: completion)
    }

    /**
     Fetch a user by user ID or username

     - parameter userId:     User ID to fetch
     - parameter username:   Username to fetch
     - parameter completion: `APICompletionClosure`
     */
    class func getUser(_ userId: Int?, username: String?, completion: APICompletionClosure?) {
        var params = [String: AnyObject]()
        
        if let userId = userId {
            params["id"] = userId as AnyObject?
        }
        
        if let username = username {
            params["username"] = username as AnyObject?
        }


        Alamofire.request("\(API.BaseURL)/user", method: .get, parameters: params, encoding: JSONEncoding.default).responseJSON { response in

            completion?(response)
        }
    }

    /**
     Add a new user account

     - parameter username:     Desired username
     - parameter password:     Password
     - parameter email:        Email address
     - parameter firstName:    First name
     - parameter lastName:     Last name
     - parameter timeZoneName: Time zone name
     - parameter completion:   `APICompletionClosure`
     */
    class func addUser(_ username: String, password: String, email: String, firstName: String, lastName: String, timeZoneName: String? = nil, completion: APICompletionClosure?) {
        
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

        Alamofire.request("\(API.BaseURL)/user", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in

            completion?(response)
        }
        
    }

    /**
     Update a user's time zone

     - parameter user:       `User` to update
     - parameter timeZone:   New time zone
     - parameter completion: `APICompletionClosure`
     */
    class func updateUserTimeZone(_ user: User, timeZone: TimeZone, completion: APICompletionClosure?) {
        let params = [
            "timeZoneName": timeZone.identifier
        ]

        Alamofire.request("\(API.BaseURL)/user/\(user.userId)", method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON { response in

            completion?(response)
        }
    }

    /**
     Update a user account

     - parameter user:       `User` to update
     - parameter username:   Username
     - parameter password:   Password (optional; set to nil to skip)
     - parameter email:      Email
     - parameter firstName:  First name
     - parameter lastName:   Last name
     - parameter completion: `APICompletionClosure`
     */
    class func updateUser(_ user: User, username: String, password: String?, email: String, firstName: String, lastName: String, completion: APICompletionClosure?) {

        var params = [
            "username": username,
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]

        if let password = password {
            params["password"] = password
        }

        Alamofire.request("\(API.BaseURL)/user/\(user.userId)", method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON { response in

            completion?(response)
        }
    }

    /**
     Get all user accounts

     - parameter completion: `APICompletionClosure`
     */
    class func getAllUsers(_ completion: APICompletionClosure?) {
        Alamofire.request("\(API.BaseURL)/users").responseJSON { response in

            completion?(response)
        }
    }

    /**
     Check to see if a user is logged in

     - parameter completion: `APICompletionClosure`
     */
    class func checkLogin(_ completion: APICompletionClosure?) {
        Alamofire.request("\(API.BaseURL)/user").responseJSON { response in

            completion?(response)
        }
    }

    /**
     Log in a user

     - parameter username:   Username
     - parameter password:   Password
     - parameter completion: `APICompletionClosure`
     */
    class func login(_ username: String, password: String, completion: APICompletionClosure?) {
        let params = [
            "username": username,
            "password": password
        ]

        Alamofire.request("\(API.BaseURL)/user/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in

            completion?(response)
        }
    }

    /**
     Log out the currently logged-in user

     - parameter completion: `APICompletionClosure`
     */
    class func logout(_ completion: APICompletionClosure?) {
        Alamofire.request("\(API.BaseURL)/user/logout", method: .post).responseJSON { response in

            completion?(response)
        }
    }
    
}
