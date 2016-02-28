//
//  PlainTableViewController.swift
//  AddressBookKit
//
//  Created by Kenneth on 28/2/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AddressBookKit

class PlainTableViewController: UITableViewController {
    var contactType = AddressBookContactType.PhoneNumber
    private var plainContacts = [PlainContact]()
    
    override func viewDidLoad() {
        title = "Plain Contacts"
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
            self.plainContacts = AddressBookKit.plainContacts(self.contactType)
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plainContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let contact = plainContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.value
        return cell
    }
}