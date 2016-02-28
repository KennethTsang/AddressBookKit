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
        
        for abRecord in allPeople {
            // Full Name
            var addressBookRecord = GroupedContact()
            addressBookRecord.firstName = ABRecordCopyValue(abRecord, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.middleName = ABRecordCopyValue(abRecord, kABPersonMiddleNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.lastName = ABRecordCopyValue(abRecord, kABPersonLastNameProperty)?.takeRetainedValue() as? String
            if addressBookRecord.fullName.isEmpty { continue }

            if types.contains(AddressBookContactType.PhoneNumber) {
                if let phoneNumbers = self.addressBookMultiValue(abRecord, propertyID: kABPersonPhoneProperty) {
                    addressBookRecord.phoneNumbers.appendContentsOf(phoneNumbers)
                }
            }
            
            if types.contains(AddressBookContactType.Email) {
                if let emails = self.addressBookMultiValue(abRecord, propertyID: kABPersonEmailProperty) {
                    addressBookRecord.emails.appendContentsOf(emails)
                }
            }

//            if types.contains(AddressBookContactType.PhoneNumber) {
//                if let phoneNumRef: ABMultiValueRef = ABRecordCopyValue(abRecord, kABPersonPhoneProperty)?.takeRetainedValue() {
//                    let phoneNumCount = ABMultiValueGetCount(phoneNumRef)
//                    for i in 0..<phoneNumCount {
//                        if let phone = ABMultiValueCopyValueAtIndex(phoneNumRef, i)?.takeRetainedValue() as? String {
//                            addressBookRecord.phoneNumbers.append(phone)
//                        }
//                    }
//                }
//            }
//            
//            if types.contains(AddressBookContactType.Email) {
//                if let emailRef: ABMultiValueRef = ABRecordCopyValue(abRecord, kABPersonEmailProperty)?.takeRetainedValue() {
//                    let emailCount = ABMultiValueGetCount(emailRef)
//                    for i in 0..<emailCount {
//                        if let email = ABMultiValueCopyValueAtIndex(emailRef, i)?.takeRetainedValue() as? String {
//                            addressBookRecord.emails.append(email)
//                        }
//                    }
//                }
//            }
            
            if addressBookRecord.phoneNumbers.count > 0 || addressBookRecord.emails.count > 0 {
                recordsArray.append(addressBookRecord)
            }
        }
        
        return recordsArray.sort {
            return $0.fullName < $1.fullName
        }
    }
    
    private static func addressBookMultiValue(recordRef: ABRecordRef, propertyID: ABPropertyID) -> [String]? {
        guard let multiValueRef: ABMultiValueRef = ABRecordCopyValue(recordRef, propertyID)?.takeRetainedValue() else { return nil }
        let count = ABMultiValueGetCount(multiValueRef)
        return Array(0..<count).flatMap {
                ABMultiValueCopyValueAtIndex(multiValueRef, $0)?.takeRetainedValue() as? String
        }
    }
    
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