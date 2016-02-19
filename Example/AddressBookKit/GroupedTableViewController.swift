//
//  ResultTableViewController.swift
//  AddressBookKit
//
//  Created by Kenneth on 19/2/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AddressBookKit

class GroupedTableViewController: UITableViewController {
    var recordsArray = [AddressBookRecord]()
    var recordType: String!
    
    override func viewDidLoad() {
        title = "All Records"
        AddressBookKit.requestPermission { [weak self] (success) -> Void in
            if success {
                self?.loadAddressBook()
            } else {
                self?.showAlert()
            }
        }
    }
    
    private func loadAddressBook() {
        switch recordType {
        case "PhoneNumbers":
            recordsArray = AddressBookKit.allRecords([.PhoneNumber])
        case "Emails":
            recordsArray = AddressBookKit.allRecords([.Email])
        default:
            break
        }
        tableView.reloadData()
    }

    private func showAlert() {
        let alertController = UIAlertController(
            title: "Contacts Access Denied",
            message: "This app requires access to your device's contacts.\n\nPlease enable contacts access for this app in Settings > Privacy > Contacts)",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "Close",
            style: .Default,
            handler:nil))
        
        alertController.addAction(UIAlertAction(
            title: "Settings",
            style: .Default,
            handler: { (_) in
                if let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(settingUrl)
                }
        }))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recordsArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch recordType {
        case "PhoneNumbers":
            return recordsArray[section].phoneNumbers.count
        case "Emails":
            return recordsArray[section].emails.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recordsArray[section].fullName
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        switch recordType {
        case "PhoneNumbers":
            cell.textLabel?.text = recordsArray[indexPath.section].phoneNumbers[indexPath.row]
        case "Emails":
            cell.textLabel?.text = recordsArray[indexPath.section].emails[indexPath.row]
        default:
            cell.textLabel?.text = ""
        }

        return cell
    }
}