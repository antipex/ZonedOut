//
//  LoginController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginController: UIViewController {

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var passwordField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func attemptLogin() {
        guard let usernameField = usernameField, let passwordField = passwordField else {
            return
        }

        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }

        API.login(username, password: password) { response in

            switch response.result {
            case .Success(let rawJSON):
                guard let statusCode = response.response?.statusCode else {
                    break
                }

                if statusCode == 401 {
                    let alert = UIAlertController(title: "Error Logging In", message: rawJSON["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    let user = User(rawJSON: rawJSON)

                    UserSession.sharedSession.currentUser = user

                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            case .Failure(let error):
                let alert = UIAlertController(title: "Error Logging In", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
