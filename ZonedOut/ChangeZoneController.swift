//
//  ChangeZoneController.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangeZoneController: UITableViewController {

    var timeZones = [String: [NSTimeZone]]()

    let cellIdentifier = "zoneCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Change Time Zone"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let allZones = NSTimeZone.knownTimeZoneNames()

        for zone in allZones {
            let regionComponents = zone.componentsSeparatedByString("/")
            let region = regionComponents[0]

            if timeZones[region] == nil {
                timeZones[region] = [NSTimeZone]()
            }

            timeZones[region]!.append(NSTimeZone(name: zone)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeZones.keys.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let regions = Array(timeZones.keys)

        return regions[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zonesForSection(section).count
    }

//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return Array(timeZones.keys)
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let timeZone = zonesForSection(indexPath.section)[indexPath.row]

        if let currentTimeZone = UserSession.sharedSession.currentUser?.timeZone {
            if currentTimeZone.name == timeZone.name {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        }
        else {
            cell.accessoryType = .None
        }

        cell.textLabel?.text = timeZone.name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let timeZone = zonesForSection(indexPath.section)[indexPath.row]

        API.updateUserTimeZone(UserSession.sharedSession.currentUser!, timeZone: timeZone) { [unowned self] response in

            switch response.result {
            case .Success(let rawJSON):
                let user = User(rawJSON: rawJSON)

                UserSession.sharedSession.currentUser = user

                self.navigationController?.popViewControllerAnimated(true)
            case .Failure(let error):
                SVProgressHUD.showErrorWithStatus("An error occurred while updating the time zone.")
                print("Error updating time zone: \(error.localizedDescription)")
            }
        }
    }

    func zonesForSection(section: Int) -> [NSTimeZone] {
        let regions = Array(timeZones.keys)

        return timeZones[regions[section]]!
    }

}
