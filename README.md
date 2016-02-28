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

Copy `AddressBookKit.swift` and `AddressBookDataType.swift` into your project.

## Usage

Ask for Contacts permission

```swift
AddressBookKit.requestPermission { [weak self] (success) -> Void in
	if success {
		// Success, read address book here...
		// Example:
		let phoneNumbers = AddressBookKit.plainContacts(.PhoneNumber)
	} else {
		// No Permission
	}
}
```

`AddressBookKit.plainContacts()` will returns an array of `PlainContact`. Example:

```swift
let phoneNumbers = AddressBookKit.plainContacts(.PhoneNumber)
let emails = AddressBookKit.plainContacts(.Email)
```

`AddressBookKit.groupedContacts()` will returns an array of `GroupedContact`. Example:

```swift
let phoneNumbers = AddressBookKit.groupedContacts([.PhoneNumber])
let emails = AddressBookKit.groupedContacts([.Email])
let phonesAndEmails = AddressBookKit.groupedContacts([.PhoneNumber, .Email])
```

## What is PlainContact?

Varible | Type | Description
--- | --- | ---
*firstName* | String? | First Name
*middleName* | String? | Middle Name
*lastName* | String? | Last Name
*fullName* | String | Full Name
*value* | [String] | A String representing phone number or email

## What is GroupedContact?

Varible | Type | Description
--- | --- | ---
*firstName* | String? | First Name
*middleName* | String? | Middle Name
*lastName* | String? | Last Name
*fullName* | String | Full Name
*phoneNumbers* | [String] | An array of phone numbers in this contact
*emails* | [String] | An array of Emails in this contact

## Author

Kenneth Tsang, kenneth.tsang@me.com

## License

AddressBookKit is available under the MIT license. See the LICENSE file for more info.
