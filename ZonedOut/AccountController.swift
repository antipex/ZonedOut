//
//  AccountController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

class AccountController: UITableViewController {

    let cellIdentifier = "accountCell"

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.textLabel?.text = "Edit Account"
        case 1:
            cell.textLabel?.text = "Log Out"
        default:
            break
        }


        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (indexPath as NSIndexPath).row {
        case 0:
            showEditUser()
        case 1:
            logOut()
        default:
            break
        }

    }

    // MARK: - Actions

    func showEditUser() {
        performSegue(withIdentifier: "showEditUser", sender: self)
    }
    
    func logOut() {
        API.logout() { [unowned self] response in
            UserSession.sharedSession.currentUser = nil

            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditUser" {
            let destViewController = segue.destination as! EditUserController

            destViewController.userData = EditUserControllerData(user: UserSession.sharedSession.currentUser)
        }
    }

}
