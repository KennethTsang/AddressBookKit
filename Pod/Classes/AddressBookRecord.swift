//
//  AddressBookRecord.swift
//  Pods
//
//  Created by Kenneth on 22/2/2016.
//
//

import Foundation

public enum AddressBookRecordType {
    case PhoneNumber
    case Email
}

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