//
//  AddressBookKit.swift
//  Pods
//
//  Created by Kenneth Tsang on 19/2/2016.
//
//

import Foundation
import AddressBook

public struct AddressBookKit {
    
    //MARK: Grouped Contacts
    public static func groupedContacts(types: [AddressBookContactType]) -> [GroupedContact] {
        
        var recordsArray = [GroupedContact]()

        guard let addressBookRef = ABAddressBookCreateWithOptions(nil, nil)?.takeRetainedValue() else { return recordsArray }
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as [ABRecordRef]

        for recordRef in allPeople {
            // Full Name
            var addressBookRecord = GroupedContact()
            addressBookRecord.firstName = ABRecordCopyValue(recordRef, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.middleName = ABRecordCopyValue(recordRef, kABPersonMiddleNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.lastName = ABRecordCopyValue(recordRef, kABPersonLastNameProperty)?.takeRetainedValue() as? String
            
            // Skip this record is no name
            if addressBookRecord.fullName.isEmpty { continue }
            
            // Phone Numbers
            if types.contains(AddressBookContactType.PhoneNumber) {
                if let values = self.addressBookMultiValue(recordRef, propertyID: kABPersonPhoneProperty) {
                    addressBookRecord.phoneNumbers.appendContentsOf(values)
                }
            }
            
            // Emails
            if types.contains(AddressBookContactType.Email) {
                if let values = self.addressBookMultiValue(recordRef, propertyID: kABPersonEmailProperty) {
                    addressBookRecord.emails.appendContentsOf(values)
                }
            }
            
            // Skip this record if phone numbers and emails are empty
            if addressBookRecord.isEmpty { continue }
            
            // Append the record
            recordsArray.append(addressBookRecord)
        }
        
        // Return sorted array
        return recordsArray.sort {
            $0.fullName < $1.fullName
        }
    }
    
    //MARK: Plain Contacts
    public static func plainContacts(type: AddressBookContactType) -> [PlainContact] {
        switch type {
        case .PhoneNumber:
            return groupedContacts([.PhoneNumber]).flatMap {
                $0.plainPhoneNumbers
            }
        case .Email:
            return groupedContacts([.Email]).flatMap {
                $0.plainEmails
            }
        }
        
    }
    
    //MARK: Extract multiple values (phone numbers, emails) from ABRecordRef
    private static func addressBookMultiValue(recordRef: ABRecordRef, propertyID: ABPropertyID) -> [String]? {
        guard let multiValueRef: ABMultiValueRef = ABRecordCopyValue(recordRef, propertyID)?.takeRetainedValue() else { return nil }
        let count = ABMultiValueGetCount(multiValueRef)
        return Array(0..<count).flatMap {
            ABMultiValueCopyValueAtIndex(multiValueRef, $0)?.takeRetainedValue() as? String
        }
    }

    //MARK: Request Permission
    public static func requestPermission(completion: ((success: Bool)->Void)?) {
        switch ABAddressBookGetAuthorizationStatus() {
            
        case .Authorized:
            if let completion = completion {
                completion(success: true)
            }
            
        case .NotDetermined:
            let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            ABAddressBookRequestAccessWithCompletion(addressBookRef) {
                (granted: Bool, error: CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        if let completion = completion {
                            completion(success: true)
                        }
                    } else {
                        if let completion = completion {
                            completion(success: false)
                        }
                    }
                }
            }
            
        default:
            if let completion = completion {
                completion(success: false)
            }
        }
    }
}