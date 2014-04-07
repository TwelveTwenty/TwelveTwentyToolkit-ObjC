#TwelveTwentyToolkit-ObjC
This used to be one giant toolkit of reusable Objective-C classes. However, I'm slowly chopping the toolkit down in favor of smaller, more granular pods.

Here's a list of the subspecs that have been extracted out, into their own pods:

+ [EEEInjector](https://github.com/epologee/EEEInjector) - Dependency Injection
+ [EEEOperationCenter](https://github.com/epologee/EEEOperationCenter) - A `NSOperationQueue` based command pattern implementation
+ [EEEUnifiedAddressBook](https://github.com/epologee/EEEUnifiedAddressBook) - A Objective-C wrapper for the ABAddressBook framework, most notably unifies cards from different sync services like Facebook and Google.
+ [EEEManualLayout](https://github.com/epologee/EEEManualLayout) - A set of layout functions along the lines of `CGRectInset`, for when auto layout is not (yet) your style.