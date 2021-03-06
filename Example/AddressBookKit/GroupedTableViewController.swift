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
    private var groupedContacts = [GroupedContact]()
    
    override func viewDidLoad() {
        title = "Grouped Contacts"
        AddressBookKit.requestPermission { [weak self] (success) -> Void in
            if success {
                self?.loadAddressBook()
            } else {
                self?.showAlert()
            }
        }
    }
    
    private func loadAddressBook() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.groupedContacts = AddressBookKit.groupedContacts([.PhoneNumber, .Email])
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
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
        return groupedContacts.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contact = groupedContacts[section]
        return contact.phoneNumbers.count + contact.emails.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupedContacts[section].fullName
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let contact = groupedContacts[indexPath.section]
        
        if indexPath.row < contact.phoneNumbers.count {
            cell.textLabel?.text = "📞 " + contact.phoneNumbers[indexPath.row]
        } else {
            cell.textLabel?.text = "✉️ " + contact.emails[indexPath.row - contact.phoneNumbers.count]
        }
        return cell
    }
}