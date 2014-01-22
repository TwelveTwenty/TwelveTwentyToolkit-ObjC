#TwelveTwentyToolkit-ObjC
Twelve Twenty's Toolkit of reusable Objective-C classes.

##Granularity through Cocoapods
This library is a collection of classes used by us here at Twelve Twenty. They contain a range of classes, categories and regular C utility functions.

If you want to use these files in your project, we recommend using the magnificient [Cocoapods](http://cocoapods.org) project. Check out the subspecs for control over granular use of the toolkit.

##Toolkit contents
###Unified Address Book
The Unified Address Book is an Objective-C wrapper around Apple's `Address Book` API. It solves three common issues when dealing with the C-API directly:

+ Unify (or de-duplicate) the cards introduced by 3rd party synching services, like Facebook, Google Contacts, etc., while still being able to use search.
+ Block based API for easy access requests on iOS 6, with backwards compatibility to iOS 5.
+ Objective-C access methods for all properties of an address book card (names, titles as `NSString`, emails and service urls as `NSArray`)