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
    case Edit
    case Add
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

    var mode: EditUserControllerMode = .Edit

    var userData = EditUserControllerData()

    let textFieldReuseIdentifier = "TextFieldCell"
    let buttonReuseIdentifier = "ButtonCell"

    var gestureRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditUserController.dismissKeyboard(_:)))
        gestureRecognizer?.cancelsTouchesInView = false

        title = mode == .Edit ? "Edit Account" : "Create New Account"

//        tableView.allowsSelection = false

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

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)

        view.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        view.removeGestureRecognizer(gestureRecognizer)
    }

    // MARK: - UITableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return ["", "", ""][section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return [4, 2, 1][section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: UITableViewCell

        if indexPath.section < 2 {
            cell = tableView.dequeueReusableCellWithIdentifier(textFieldReuseIdentifier, forIndexPath: indexPath) as! TextFieldCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(buttonReuseIdentifier, forIndexPath: indexPath)
        }

        switch indexPath.section {
        case 0:
            let cell = cell as! TextFieldCell
            cell.delegate = self

            cell.textField.secureTextEntry = false
            cell.textField.autocorrectionType = .No

            switch indexPath.row {
            case 0:
                cell.textField.placeholder = "Username"
                cell.textField.text = userData.username
                cell.textField.autocapitalizationType = .None
            case 1:
                cell.textField.placeholder = "Email"
                cell.textField.text = userData.email
                cell.textField.keyboardType = .EmailAddress
            case 2:
                cell.textField.placeholder = "First Name"
                cell.textField.text = userData.firstName
                cell.textField.autocapitalizationType = .Words
            case 3:
                cell.textField.placeholder = "Last Name"
                cell.textField.text = userData.lastName
                cell.textField.autocapitalizationType = .Words
            default:
                break
            }
        case 1:
            let cell = cell as! TextFieldCell
            cell.delegate = self

            cell.textField.secureTextEntry = true
            
            switch indexPath.row {
            case 0:
                cell.textField.placeholder = "Password"
            case 1:
                cell.textField.placeholder = "Confirm"
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = mode == .Edit ? "Save Changes" : "Create Account"
            default:
                break
            }
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return [false, false, true][indexPath.section]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        switch indexPath.section {
        case 2:
            switch indexPath.row {
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

    func textFieldCell(cell: TextFieldCell, didUpdateValue value: String?) {
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }

        switch indexPath.section {
        case 0:
            switch indexPath.row {
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
            switch indexPath.row {
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

        if mode == .Add {
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

    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func tappedButton() {
        if let errorStrings = validateFields() {
            let alert = UIAlertController(
                title: "Error",
                message: errorStrings.joinWithSeparator("\n"),
                preferredStyle: .Alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: .Cancel,
                handler: nil)
            )

            presentViewController(alert, animated: true, completion: nil)
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
