//
//  OverviewController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class OverviewController: UITableViewController {
    
    var timeZones = [String: [User]]()
    
    let cellIdentifier = "OverviewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellIdentifier)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSessionStateChanged:", name: ZonedOut.Notification.UserSessionStateChanged, object: nil)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)

        let statusView = StatusView(frame: CGRectMake(0.0, 0.0, view.frame.size.width, navigationController!.navigationBar.frame.size.height))
        statusView.autoresizingMask = [.FlexibleWidth]
        navigationItem.titleView = statusView
        statusView.tapHandler = { [unowned self] in
            self.showChangeZone()
        }

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor.whiteColor()
            navigationBar.translucent = true
            navigationBar.barTintColor = UIColor(hex: 0x235da2)
            navigationBar.barStyle = .BlackTranslucent
        }

        API.checkLogin() { [unowned self] response in
            switch response.result {
            case .Success(let rawJSON):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // Not logged in yet, so show login
                        NSLog("checkLogin: Not logged in yet.")

                        UserSession.sharedSession.currentUser = nil

                        self.showLogin()
                    }
                    else {
                        // Logged in already
                        NSLog("checkLogin: Already logged in.")

                        let user = User(rawJSON: rawJSON)

                        UserSession.sharedSession.currentUser = user
                    }
                }
                else {
                    self.showLogin()
                }
            case .Failure(let error):
                let alert = UIAlertController(title: "Error Logging In", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    private func showLogin() {
        performSegueWithIdentifier("showLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userSessionStateChanged(notification: NSNotification) {
        if UserSession.sharedSession.currentUser == nil {
            showLogin()
        }

        refresh()
    }

    func refresh() {
        refreshControl?.beginRefreshing()

        timeZones.removeAll()

        guard let currentUser = UserSession.sharedSession.currentUser else {
            title = ""

            return
        }

        API.getAllUsers() { [unowned self] response in
            switch response.result {
            case .Success(let rawList):
                self.parseUserList(rawList)
            case .Failure(let error):
                self.refreshControl?.endRefreshing()

                let alert = UIAlertController(title: "Error Loading Users", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    private func parseUserList(rawList: AnyObject) {

        let JSONList = JSON(rawList)

        for (key, subJSON):(String, JSON) in JSONList {
            let user = User(JSONUser: subJSON)

            guard user.userId != UserSession.sharedSession.currentUser?.userId else {
                continue
            }

            guard let timeZoneName = user.timeZone?.displayName else {
                continue
            }

            if timeZones[timeZoneName] == nil {
                timeZones[timeZoneName] = [User]()
            }

            timeZones[timeZoneName]!.append(user)
        }

        refreshControl?.endRefreshing()

        tableView.reloadData()
    }
    
    // MARK: UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(timeZones.keys)

        return timeZones[keys[section]]?.count ?? 0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeZones.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(timeZones.keys)

        return keys[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserCell.PreferredHeight
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let keys = Array(timeZones.keys)

        let zoneName = keys[section]
        let zone = NSTimeZone(name: zoneName.stringByReplacingOccurrencesOfString(" ", withString: "_"))!

        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, h:mm a"
        formatter.timeZone = zone
        let formattedDate = formatter.stringFromDate(NSDate())

        let headerView = OverviewHeaderView(frame: CGRectZero)
        headerView.titleLabel.text = zoneName
        headerView.timeLabel.text = formattedDate

        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserCell
        let keys = Array(timeZones.keys)

        guard let user = timeZones[keys[indexPath.section]]?[indexPath.row] else {
            return cell
        }
        
        cell.user = user
        cell.selectionStyle = .None

        var index = 1

        for sectionIndex in 0..<indexPath.section {
            index += tableView.numberOfRowsInSection(sectionIndex)
        }

        index += indexPath.row
        cell.index = index
        
        return cell
    }

    func showChangeZone() {
        performSegueWithIdentifier("showChangeZone", sender: self)
    }

}

