//
//  MenuTableViewController.swift
//  AddressBookKit
//
//  Created by Kenneth on 19/2/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "PlainPhoneNumbersSegue":
                if let vc = segue.destinationViewController as? PlainTableViewController {
                    vc.contactType = .PhoneNumber
                }
            case "PlainEmailsSegue":
                if let vc = segue.destinationViewController as? PlainTableViewController {
                    vc.contactType = .Email
                }
            default:
                break
            }
        }
    }
}