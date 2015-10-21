//
//  LoginController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 19/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var passwordField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for field in [usernameField!, passwordField!] {
            field.backgroundColor = UIColor.whiteColor()
            field.layer.cornerRadius = 3.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBarHidden = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBarHidden = false
    }

    @IBAction func attemptLogin() {
        guard let usernameField = usernameField, let passwordField = passwordField else {
            return
        }

        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }

        SVProgressHUD.showWithStatus("Logging in...")

        API.login(username, password: password) { response in

            SVProgressHUD.dismiss()

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

}
