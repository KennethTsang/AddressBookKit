//
//  AddressBookRecord.swift
//  Pods
//
//  Created by Kenneth on 22/2/2016.
//
//

import Foundation

public enum AddressBookContactType {
    case PhoneNumber
    case Email
}

public struct PlainContact {
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    
    public var fullName: String {
        return [firstName, middleName, lastName].flatMap { $0 }.joinWithSeparator(" ")
    }
    
    public var value: String
}

public struct GroupedContact {
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    
    public var fullName: String {
        return [firstName, middleName, lastName].flatMap { $0 }.joinWithSeparator(" ")
    }
    
    public var phoneNumbers = [String]()
    public var emails = [String]()
    
    var isEmpty: Bool {
        return phoneNumbers.isEmpty && emails.isEmpty
    }
    
    var plainPhoneNumbers: [PlainContact] {
        return phoneNumbers.flatMap {
            PlainContact(firstName: firstName, middleName: middleName, lastName: lastName, value: $0)
        }
    }

    var plainEmails: [PlainContact] {
        return emails.flatMap {
            PlainContact(firstName: firstName, middleName: middleName, lastName: lastName, value: $0)
        }
    }
}