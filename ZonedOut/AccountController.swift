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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Edit Account"
        case 1:
            cell.textLabel?.text = "Log Out"
        default:
            break
        }


        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.row {
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
        performSegueWithIdentifier("showEditUser", sender: self)
    }
    
    func logOut() {
        API.logout() { [unowned self] response in
            UserSession.sharedSession.currentUser = nil

            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditUser" {
            let destViewController = segue.destinationViewController as! EditUserController

            destViewController.userData = EditUserControllerData(user: UserSession.sharedSession.currentUser)
        }
    }

}
