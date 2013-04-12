// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "TTTInjectionMapping.h"

#define injectAlloc allocWithInjector:[TTTInjector sharedInjector]
#define injectObject objectFromInjector:[TTTInjector sharedInjector]
#define injectObjectNamed(...) objectFromInjector:[TTTInjector sharedInjector] withIdentifier:[NSString stringWithFormat:__VA_ARGS__]
#define inject injectWithInjector:[TTTInjector sharedInjector]

/**
 The TTTInjectable protocol is used to 'mark' properties to be injected automatically.
 The injected objects need not implement the protocol explicitly.
 You can, for example, inject an array property like this:
 @property (strong) NSArray <TTTInjectable>*plants;
 */
@protocol TTTInjectable <NSObject>

@optional
- (void)didInjectProperties;

@end

/**
 This mapper protocol is used to narrow down the methods you call on the injector directly.
 The rest of its methods are accessed through the NSObject category class methods below.
 Example:
 
 [[[self.injector mapClass:[CustomClass class]] toObject:[CustomSubclass]] singleServing];
 [[self.injector mapClass:[NSArray class] withIdentifier:@"plants"] toObject:@[@"Tree", @"Grass"]];
 */
@protocol TTTInjectionMapper

- (id <TTInjectionMappingStart>)mapClass:(Class)class;

- (id <TTInjectionMappingStart>)mapClass:(Class)class withIdentifier:(NSString *)identifier;

- (id <TTInjectionMappingStart>)mapClass:(Class)class overwriteExisting:(BOOL)overwriteExisting;

- (id <TTInjectionMappingStart>)mapClass:(Class)class withIdentifier:(NSString *)identifier overwriteExisting:(BOOL)overwriteExisting;

- (void)unmapClass:(Class)class;

- (void)unmapClass:(Class)class withIdentifier:(NSString *)identifier;

@end

/**
 The TTTInjector public interface only deals with class methods for setting and getting a/the shared injector.
 You can manually keep a reference to one or more injector instances if you prefer.
 */
@interface TTTInjector : NSObject <TTTInjectionMapper>

+ (TTTInjector *)sharedInjector;

+ (id <TTTInjectionMapper>)sharedMappingInjector;

+ (TTTInjector *)setSharedInjector:(TTTInjector *)injector;

- (id)injectPropertiesIntoObject:(id)object;

@end

/**
 Retrieve mapped classes, objects or manually fire injection with these NSObject methods.
 Example:
 
    [[CustomClass allocWithInjector:[TTTInjector sharedInjector]] initWithFrame:CGRectZero];
 
 There's a shorthand macro for this above, so you if you use the sharedInjector, you may write:
 
    [[CustomClass injectAlloc] initWithFrame:CGRectZero];
 
 Or try identifier-based mappings:
 
    [NSArray objectFromInjector:[TTTInjector sharedInjector] withIdentifier:@"plants"];
 
 If objects are mapped with an identifier, properties that share that name will be automatically injected:
 
    @property (strong) NSArray <TTTInjectable>*plants;
 */
@interface NSObject (TTTInjector)

+ (id)allocWithInjector:(TTTInjector *)injector;

+ (id)objectFromInjector:(TTTInjector *)injector;

+ (id)objectFromInjector:(TTTInjector *)injector withIdentifier:(NSString *)identifier;

- (id)injectWithInjector:(TTTInjector *)injector;

@end