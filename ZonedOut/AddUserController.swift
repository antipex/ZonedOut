//
//  AddUserController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddUserController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(hex: 0x235da2)
            navigationBar.barStyle = .BlackTranslucent
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAccount() {

        guard let usernameField = usernameField, let passwordField = passwordField, let emailField = emailField, let firstNameField = firstNameField, let lastNameField = lastNameField else {

            return
        }

        API.addUser(usernameField.text!, password: passwordField.text!, email: emailField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!) { response in

            switch response.result {
            case .Success(let rawJSON):
                let user = User(rawJSON: rawJSON)
                UserSession.sharedSession.currentUser = user

                SVProgressHUD.showSuccessWithStatus("Account created successfully")

                self.dismissViewControllerAnimated(true, completion: nil)
            case .Failure(let error):
                let alert = UIAlertController(title: "Error Creating Account", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

}
