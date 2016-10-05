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

    var timeZones = [String: [TimeZone]]()

    let cellIdentifier = "zoneCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Change Time Zone"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let allZones = TimeZone.knownTimeZoneIdentifiers

        for zone in allZones {
            let regionComponents = zone.components(separatedBy: "/")
            let region = regionComponents[0]

            if timeZones[region] == nil {
                timeZones[region] = [TimeZone]()
            }

            timeZones[region]!.append(TimeZone(identifier: zone)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return timeZones.keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let regions = Array(timeZones.keys)

        return regions[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zonesForSection(section).count
    }

//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return Array(timeZones.keys)
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let timeZone = zonesForSection((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]

        if let currentTimeZone = UserSession.sharedSession.currentUser?.timeZone {
            if currentTimeZone.identifier == timeZone.identifier {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        else {
            cell.accessoryType = .none
        }

        cell.textLabel?.text = timeZone.identifier

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeZone = zonesForSection((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]

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

    func zonesForSection(_ section: Int) -> [TimeZone] {
        let regions = Array(timeZones.keys)

        return timeZones[regions[section]]!
    }

}
