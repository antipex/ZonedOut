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
            field.backgroundColor = UIColor.white
            field.layer.cornerRadius = 3.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func attemptLogin() {
        guard let usernameField = usernameField, let passwordField = passwordField else {
            return
        }

        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }

        SVProgressHUD.show(withStatus: "Logging in...")

        API.login(username, password: password) { response in

            SVProgressHUD.dismiss()

            switch response.result {
            case .success(let rawJSON):
                print("#: \(rawJSON)")
                guard let statusCode = response.response?.statusCode else {
                    break
                }

                if statusCode == 401 {
                    let json = JSON(rawJSON)

                    let alert = UIAlertController(title: "Error Logging In", message: json["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let user = User(rawJSON: rawJSON)

                    UserSession.sharedSession.currentUser = user

                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error Logging In", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
