# AddressBookKit

[![Version](https://img.shields.io/cocoapods/v/AddressBookKit.svg?style=flat)](http://cocoapods.org/pods/AddressBookKit)
[![License](https://img.shields.io/cocoapods/l/AddressBookKit.svg?style=flat)](http://cocoapods.org/pods/AddressBookKit)
[![Platform](https://img.shields.io/cocoapods/p/AddressBookKit.svg?style=flat)](http://cocoapods.org/pods/AddressBookKit)
[![Language](https://img.shields.io/badge/Language-Swift-orange.svg?style=flat)](http://cocoapods.org/pods/AddressBookKit)

## Requirements

iOS 8.0 or above

## Installation

AddressBookKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AddressBookKit"
```

or

Copy `AddressBookKit.swift` and `AddressBookRecord.swift` into your project.

## Usage

```swift
AddressBookKit.requestPermission { [weak self] (success) -> Void in
	if success {
		let allPhoneNumbers = AddressBookKit.allRecords([.PhoneNumber])
		let allEmails = AddressBookKit.allRecords([.Email])
		let allPhonesAndEmails = AddressBookKit.allRecords([.PhoneNumber, .Email])
	} else {
		// No Permission
	}
}
```

`AddressBookKit.allRecords` will returns an array of `AddressBookRecord`

## Contents of AddressBookRecord

Varible | Type | Description
--- | --- | ---
*firstName* | String? | First Name
*middleName* | String? | Middle Name
*lastName* | String? | Last Name
*fullName* | String? | Full Name
*phoneNumbers* | [String] | An array of phone numbers in this contact
*emails* | [String] | An array of Emails in this contact

## Author

Kenneth Tsang, kenneth.tsang@me.com

## License

AddressBookKit is available under the MIT license. See the LICENSE file for more info.
