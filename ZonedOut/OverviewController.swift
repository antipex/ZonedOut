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

        tableView.register(UserCell.self, forCellReuseIdentifier: cellIdentifier)

        NotificationCenter.default.addObserver(self, selector: #selector(OverviewController.userSessionStateChanged(_:)), name: NSNotification.Name(rawValue: ZonedOut.Notification.UserSessionStateChanged), object: nil)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(OverviewController.refresh), for: .valueChanged)

        let statusView = StatusView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: navigationController!.navigationBar.frame.size.height))
        statusView.autoresizingMask = [.flexibleWidth]
        navigationItem.titleView = statusView
        statusView.tapHandler = { [unowned self] in
            self.showChangeZone()
        }

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor.white
            navigationBar.isTranslucent = true
            navigationBar.barTintColor = UIColor(hex: 0x235da2)
            navigationBar.barStyle = .blackTranslucent
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
            case .Failure:
                self.showLogin()

                //let alert = UIAlertController(title: "Error Logging In", message: error.localizedDescription, preferredStyle: .Alert)
                //alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                //self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    fileprivate func showLogin() {
        performSegue(withIdentifier: "showLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userSessionStateChanged(_ notification: Notification) {
        if UserSession.sharedSession.currentUser == nil {
            showLogin()
        }

        refresh()
    }

    func refresh() {
        refreshControl?.beginRefreshing()

        timeZones.removeAll()

        tableView.reloadData()

        guard let _ = UserSession.sharedSession.currentUser else {
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

    fileprivate func parseUserList(_ rawList: AnyObject) {

        let JSONList = JSON(rawList)

        for (_, subJSON):(String, JSON) in JSONList {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(timeZones.keys)

        return timeZones[keys[section]]?.count ?? 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return timeZones.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(timeZones.keys)

        return keys[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.PreferredHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let keys = Array(timeZones.keys)

        let zoneName = keys[section]
        let zone = TimeZone(identifier: zoneName.replacingOccurrences(of: " ", with: "_"))!

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, h:mm a"
        formatter.timeZone = zone
        let formattedDate = formatter.string(from: Date())

        let headerView = OverviewHeaderView(frame: CGRect.zero)
        headerView.titleLabel.text = zoneName
        headerView.timeLabel.text = formattedDate

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        let keys = Array(timeZones.keys)

        guard let user = timeZones[keys[(indexPath as NSIndexPath).section]]?[(indexPath as NSIndexPath).row] else {
            return cell
        }
        
        cell.user = user
        cell.selectionStyle = .none

        var index = 1

        for sectionIndex in 0..<(indexPath as NSIndexPath).section {
            index += tableView.numberOfRows(inSection: sectionIndex)
        }

        index += (indexPath as NSIndexPath).row
        cell.index = index
        
        return cell
    }

    func showChangeZone() {
        performSegue(withIdentifier: "showChangeZone", sender: self)
    }

}

