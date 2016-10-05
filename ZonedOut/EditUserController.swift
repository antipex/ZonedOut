//
//  EditUserController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SVProgressHUD

enum EditUserControllerMode {
    case edit
    case add
}

struct EditUserControllerData {
    var userId = 0
    var username = ""
    var email = ""
    var firstName = ""
    var lastName = ""
    var password = ""
    var passwordConfirm = ""

    init(user: User? = nil) {
        if let user = user {
            userId = user.userId
            username = user.username
            email = user.email
            firstName = user.firstName
            lastName = user.lastName
        }
    }

    var includesPassword: Bool {
        return password.characters.count > 0
    }
}

class EditUserController: UITableViewController, TextFieldCellDelegate {

    var mode: EditUserControllerMode = .edit

    var userData = EditUserControllerData()

    let textFieldReuseIdentifier = "TextFieldCell"
    let buttonReuseIdentifier = "ButtonCell"

    var gestureRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditUserController.dismissKeyboard(_:)))
        gestureRecognizer?.cancelsTouchesInView = false

        title = mode == .edit ? "Edit Account" : "Create New Account"

//        tableView.allowsSelection = false

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(hex: 0x235da2)
            navigationBar.barStyle = .blackTranslucent
            navigationBar.tintColor = UIColor.white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.removeGestureRecognizer(gestureRecognizer)
    }

    // MARK: - UITableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return ["", "", ""][section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return [4, 2, 1][section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell

        if (indexPath as NSIndexPath).section < 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: textFieldReuseIdentifier, for: indexPath) as! TextFieldCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: buttonReuseIdentifier, for: indexPath)
        }

        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = cell as! TextFieldCell
            cell.delegate = self

            cell.textField.isSecureTextEntry = false
            cell.textField.autocorrectionType = .no

            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textField.placeholder = "Username"
                cell.textField.text = userData.username
                cell.textField.autocapitalizationType = .none
            case 1:
                cell.textField.placeholder = "Email"
                cell.textField.text = userData.email
                cell.textField.keyboardType = .emailAddress
            case 2:
                cell.textField.placeholder = "First Name"
                cell.textField.text = userData.firstName
                cell.textField.autocapitalizationType = .words
            case 3:
                cell.textField.placeholder = "Last Name"
                cell.textField.text = userData.lastName
                cell.textField.autocapitalizationType = .words
            default:
                break
            }
        case 1:
            let cell = cell as! TextFieldCell
            cell.delegate = self

            cell.textField.isSecureTextEntry = true
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textField.placeholder = "Password"
            case 1:
                cell.textField.placeholder = "Confirm"
            default:
                break
            }
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textLabel?.text = mode == .edit ? "Save Changes" : "Create Account"
            default:
                break
            }
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {

        return [false, false, true][(indexPath as NSIndexPath).section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath as NSIndexPath).section {
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:
                tappedButton()
            default:
                break
            }
        default:
            break
        }
    }

    // MARK: - TextFieldCellDelegate

    func textFieldCell(_ cell: TextFieldCell, didUpdateValue value: String?) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0:
                userData.username = value ?? ""
            case 1:
                userData.email = value ?? ""
            case 2:
                userData.firstName = value ?? ""
            case 3:
                userData.lastName = value ?? ""
            default:
                break
            }
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                userData.password = value ?? ""
            case 1:
                userData.passwordConfirm = value ?? ""
            default:
                break
            }
        default:
            break
        }
    }

    // MARK: - Helpers

    /**
    Validate fields

    - returns: Array of error strings or nil if no errors
    */
    func validateFields() -> [String]? {
        var errorStrings = [String]()

        if userData.username.characters.count == 0 {
            errorStrings.append("Username is required")
        }

        if userData.email.characters.count == 0 {
            errorStrings.append("Email is required")
        }

        if userData.firstName.characters.count == 0 {
            errorStrings.append("First name is required")
        }

        if userData.lastName.characters.count == 0 {
            errorStrings.append("Last name is required")
        }

        func checkPasswordsMatch() {
            if userData.password != userData.passwordConfirm {
                errorStrings.append("Passwords must match")
            }
        }

        if mode == .add {
            if !userData.includesPassword {
                errorStrings.append("Password is required")
            }

            checkPasswordsMatch()
        }
        else {
            if userData.includesPassword {
                checkPasswordsMatch()
            }
        }

        return errorStrings.count > 0 ? errorStrings : nil
    }

    // MARK: - Actions

    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    fileprivate func tappedButton() {
        if let errorStrings = validateFields() {
            let alert = UIAlertController(
                title: "Error",
                message: errorStrings.joined(separator: "\n"),
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil)
            )

            present(alert, animated: true, completion: nil)
        }
        else {
            passedValidation()
        }
    }

    func passedValidation() {
        guard let user = UserSession.sharedSession.currentUser else {
            return
        }

        API.updateUser(user, username: userData.username, password: userData.includesPassword ? userData.password : nil, email: userData.email, firstName: userData.firstName, lastName: userData.lastName) { response in

            switch response.result {
            case .Success(let rawJSON):
                let user = User(rawJSON: rawJSON)
                UserSession.sharedSession.currentUser = user

                SVProgressHUD.showSuccessWithStatus("Account updated successfully")

                self.navigationController?.popViewControllerAnimated(true)
            case .Failure(let error):
                let alert = UIAlertController(title: "Could not update account", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

}
