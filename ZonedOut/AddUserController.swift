//
//  AddUserController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 21/02/2016.
//  Copyright © 2016 Kyle Rohr. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddUserController: EditUserController {

    override func viewDidLoad() {
        mode = .add

        super.viewDidLoad()
    }

    // MARK: - Actions

    override func passedValidation() {
        API.addUser(userData.username, password: userData.password, email: userData.email, firstName: userData.firstName, lastName: userData.lastName) { response in

            switch response.result {
            case .success(let rawJSON):
                let user = User(rawJSON: rawJSON)
                UserSession.sharedSession.currentUser = user

                SVProgressHUD.showSuccess(withStatus: "Account created successfully")

                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                let alert = UIAlertController(title: "Could not create account", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
