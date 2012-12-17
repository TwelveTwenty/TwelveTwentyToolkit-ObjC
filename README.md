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

###Dependency Injection
If you've never heard of it, it can be a bit hard to immediately grasp the concept and the power of [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection#Highly_coupled_dependency)(DI), but once you've worked with it, you will not want to go without again. DI is about much more than reducing the reliance on singletons, see the [benefits section on Wikipedia](http://en.wikipedia.org/wiki/Dependency_injection#Benefits). 

There are other existing frameworks that allow for dependency injection in Objective-C, with the [objection framework](https://github.com/atomicobject/objection) being the most prominent. Unfortunately, the syntactical sugar that objection adds to your code is somewhat 'weird', and because it's not instantly obvious what the meta-code does, it will confuse your colleagues and/or clients, and hardly get anyone excited about it.

Several features:

+ Runtime substitution of classes by specific subclasses
+ Protocol-annotation based injection of properties
+ Comparmentalized singletons (per injector instance)
+ Preset object injections, including named objects
+ Lazily instantiated objects
+ 100% custom initializers after alloc
+ Single-serving injections (unmap after use)