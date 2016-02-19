//
//  MenuTableViewController.swift
//  AddressBookKit
//
//  Created by Kenneth on 19/2/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("GroupSegue", sender: "PhoneNumbers")
        case 1:
            performSegueWithIdentifier("GroupSegue", sender: "Emails")
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? GroupedTableViewController {
            vc.recordType = sender as! String
        }
    }
}