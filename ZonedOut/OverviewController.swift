//
//  OverviewController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

struct TimeZone {
    
    var timeZone: NSTimeZone
    var people: [Person]
    
    init(timeZone: NSTimeZone, people: [Person]) {
        self.timeZone = timeZone
        self.people = people
    }
    
}

class OverviewController: UITableViewController {
    
    var timeZones: [TimeZone]?
    
    let cellIdentifier = "OverviewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        let peopleOne = [
//            Person(name: "Famanda Ritz", timeZone: NSTimeZone(name: "America/Los_Angeles")!),
//            Person(name: "Harlie Cales", timeZone: NSTimeZone(name: "America/Los_Angeles")!)
//        ]
//        
//        let peopleTwo = [
//            Person(name: "Bob Gunderson", timeZone: NSTimeZone(name: "America/Montreal")!)
//        ]
//        
//        timeZones = [
//            TimeZone(timeZone: NSTimeZone(name: "America/Los_Angeles")!, people: peopleOne),
//            TimeZone(timeZone: NSTimeZone(name: "America/Montreal")!, people: peopleTwo)
//        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(PersonCell.self, forCellReuseIdentifier: cellIdentifier)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSessionStateChanged:", name: ZonedOut.Notification.UserSessionStateChanged, object: nil)

        API.checkLogin() { response in
            switch response.result {
            case .Success(let rawJSON):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // Not logged in yet, so show login
                        NSLog("checkLogin: Not logged in yet.")

                        User.sharedUser.currentPerson = nil

                        self.showLogin()
                    }
                    else {
                        // Logged in already
                        NSLog("checkLogin: Already logged in.")

                        let person = Person(rawJSON: rawJSON)

                        User.sharedUser.currentPerson = person
                    }
                }
                else {
                    self.showLogin()
                }
            case .Failure(let error):
                break
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
        print("User session changed: \(User.sharedUser.currentPerson)")
    }
    
    // MARK: UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let timeZones = timeZones else {
            return 0
        }
        
        return timeZones[section].people.count
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeZones?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let timeZones = timeZones else {
            return ""
        }
        
        return timeZones[section].timeZone.name
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PersonCell.PreferredHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PersonCell
        
        guard let person = timeZones?[indexPath.section].people[indexPath.row] else {
            return cell
        }
        
        cell.person = person
        
        return cell
    }

}

