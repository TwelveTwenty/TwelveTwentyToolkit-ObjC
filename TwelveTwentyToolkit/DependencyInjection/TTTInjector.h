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

#define injectClass ttt_classWithInjector:[TTTInjector currentInjector]
#define injectAlloc ttt_allocWithInjector:[TTTInjector currentInjector]
#define injectObject ttt_objectFromInjector:[TTTInjector currentInjector]
#define injectObjectNamed(name) ttt_objectFromInjector:[TTTInjector currentInjector] withIdentifier:name
#define inject ttt_injectWithInjector:[TTTInjector currentInjector]

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

@class TTTInjector;

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

- (TTTInjector *)asInjector;

@end

/**
 The TTTInjector public interface only deals with class methods for setting and getting a/the shared injector.
 You can manually keep a reference to one or more injector instances if you prefer.
 */
@interface TTTInjector : NSObject <TTTInjectionMapper>

@property(nonatomic) BOOL allowImplicitMapping;

+ (instancetype)currentInjector;

+ (instancetype)defaultCurrentInjector;

+ (instancetype)setCurrentInjector:(TTTInjector *)injector force:(BOOL)force;

+ (TTTInjector *)sharedInjector DEPRECATED_ATTRIBUTE; // Replaced by currentInjector

+ (TTTInjector *)setSharedInjector DEPRECATED_ATTRIBUTE; // Replaced by defaultCurrentInjector

+ (TTTInjector *)setSharedInjector:(TTTInjector *)injector DEPRECATED_ATTRIBUTE; // Replaced by setCurrentInjector:force:

- (id <TTTInjectionMapper>)asMapper;

- (id)injectPropertiesIntoObject:(id)object;

@end

/**
 Retrieve mapped classes, objects or manually fire injection with these NSObject methods.
 Example:
 
    [[CustomClass ttt_allocWithInjector:[TTTInjector sharedInjector]] initWithFrame:CGRectZero];
 
 There's a shorthand macro for this above, so you if you use the sharedInjector, you may write:
 
    [[CustomClass injectAlloc] initWithFrame:CGRectZero];
 
 Or try identifier-based mappings:
 
    [NSArray ttt_objectFromInjector:[TTTInjector sharedInjector] withIdentifier:@"plants"];
 
 If objects are mapped with an identifier, properties that share that name will be automatically injected:
 
    @property (strong) NSArray <TTTInjectable>*plants;
 */
@interface NSObject (TTTInjector)

+ (Class)ttt_classWithInjector:(TTTInjector *)injector;

+ (instancetype)ttt_allocWithInjector:(TTTInjector *)injector;

+ (instancetype)ttt_objectFromInjector:(TTTInjector *)injector;

+ (instancetype)ttt_objectFromInjector:(TTTInjector *)injector withIdentifier:(NSString *)identifier;

- (instancetype)ttt_injectWithInjector:(TTTInjector *)injector;

@end