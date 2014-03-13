# [wip]EEEInjector

<!--[![Version](http://cocoapod-badges.herokuapp.com/v/EEEInjector/badge.png)](http://cocoadocs.org/docsets/EEEInjector)
[![Platform](http://cocoapod-badges.herokuapp.com/p/EEEInjector/badge.png)](http://cocoadocs.org/docsets/EEEInjector)-->

## This is a work-in-progress project.

Use the TTTInjector from https://github.com/TwelveTwenty/TwelveTwentyToolkit-ObjC if you need it right now. This project will eventually replace the dependency injection part of that toolkit.

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

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Requirements

## Installation

EEEInjector is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "EEEInjector"

## Author

Eric-Paul Lecluse, e@epologee.com

## License

EEEInjector is available under the MIT license. See the LICENSE file for more info.

