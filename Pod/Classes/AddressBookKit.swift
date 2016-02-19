//
//  AddressBookKit.swift
//  Pods
//
//  Created by Kenneth Tsang on 19/2/2016.
//
//

import Foundation
import AddressBook

public enum AddressBookRecordType {
    case PhoneNumber
    case Email
}

//MARK: Address Book Record
public struct AddressBookRecord {
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?

    public var fullName: String? {
        let nameParts = [firstName, middleName, lastName].filter {
            guard let namePart = $0 else { return false }
            return !namePart.isEmpty
        }
        if nameParts.count == 0 {
            return nil
        } else {
            return nameParts.map { $0! }.joinWithSeparator(" ")
        }
    }
    
    public var phoneNumbers = [String]()
    public var emails = [String]()
}

public struct AddressBookKit {
    
    //MARK: Get Device's Address Book
    public static func allRecords(types: [AddressBookRecordType]) -> [AddressBookRecord] {
        
        var recordsArray = [AddressBookRecord]()

        guard let addressBookRef = ABAddressBookCreateWithOptions(nil, nil)?.takeRetainedValue() else { return recordsArray }
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as [ABRecordRef]
        
        for abRecord in allPeople {
            // Full Name
            var addressBookRecord = AddressBookRecord()
            addressBookRecord.firstName = ABRecordCopyValue(abRecord, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.middleName = ABRecordCopyValue(abRecord, kABPersonMiddleNameProperty)?.takeRetainedValue() as? String
            addressBookRecord.lastName = ABRecordCopyValue(abRecord, kABPersonLastNameProperty)?.takeRetainedValue() as? String
            guard let _ = addressBookRecord.fullName else { continue }
            
            if types.contains(AddressBookRecordType.PhoneNumber) {
                if let phoneNumRef: ABMultiValueRef = ABRecordCopyValue(abRecord, kABPersonPhoneProperty)?.takeRetainedValue() {
                    let phoneNumCount = ABMultiValueGetCount(phoneNumRef)
                    for i in 0..<phoneNumCount {
                        if let phone = ABMultiValueCopyValueAtIndex(phoneNumRef, i)?.takeRetainedValue() as? String {
                            addressBookRecord.phoneNumbers.append(phone)
                        }
                    }
                }
            }
            
            if types.contains(AddressBookRecordType.Email) {
                if let emailRef: ABMultiValueRef = ABRecordCopyValue(abRecord, kABPersonEmailProperty)?.takeRetainedValue() {
                    let emailCount = ABMultiValueGetCount(emailRef)
                    for i in 0..<emailCount {
                        if let email = ABMultiValueCopyValueAtIndex(emailRef, i)?.takeRetainedValue() as? String {
                            addressBookRecord.emails.append(email)
                        }
                    }
                }
            }

            if addressBookRecord.phoneNumbers.count > 0 || addressBookRecord.emails.count > 0 {
                recordsArray.append(addressBookRecord)
            }
        }
        
        return recordsArray.sort {// (a, b) -> Bool in
            return $0.fullName < $1.fullName
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