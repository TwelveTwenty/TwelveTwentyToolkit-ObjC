// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl/)
//
// Permission is hereby granted, free of charge, to any unifiedCard obtaining a copy
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

#import "TTTDependencyInjectionTestCase.h"

#import "TTInjector.h"

#import "TTTDISimpleObject.h"
#import "TTTDIBaseObject.h"
#import "TTTDIConcreteObject.h"

#import "TTTDISimpleSingleton.h"
#import "TTTDIBaseSingleton.h"
#import "TTTDIConcreteSingleton.h"

#import "TTTDIInjectableObject.h"

@interface TTTDependencyInjectionTestCase ()

@property (nonatomic, strong) TTInjector *injector;
@property (nonatomic, strong) id existingObject;
@property (nonatomic, strong) NSArray *simpleListObject;

@end


@implementation TTTDependencyInjectionTestCase

- (void)setUp
{
    self.injector = [[TTInjector alloc] init];
    
	[self.injector mapClass:[TTTDISimpleObject class]];
    [[self.injector mapClass:[TTTDIBaseObject class]] toSubclass:[TTTDIConcreteObject class]];
    [[self.injector mapClass:[TTTDISimpleSingleton class]] asSingleton];
    [[[self.injector mapClass:[TTTDIBaseSingleton class]] toSubclass:[TTTDIConcreteSingleton class]] asSingleton];

    self.existingObject = @[@"Hello", @"Object"];
    [[self.injector mapClass:[NSArray class]] toObject:self.existingObject];
    
    self.simpleListObject = @[@"Another", @"List"];
    [[self.injector mapClass:[NSArray class] withIdentifier:@"simpleList"] toObject:self.simpleListObject];

    [[self.injector mapClass:[NSDictionary class]] singleServing];

    [self.injector mapClass:[TTTDIInjectableObject class]];
}

- (void)tearDown
{
    self.injector = nil;
    self.existingObject = nil;
}

- (void)testSetup
{
	STAssertTrue(YES, @"Setup works");
}

- (void)testNoMapping
{
    BOOL assertionThrown = NO;
    
    @try {
        NSMutableSet *nilSet = [NSMutableSet objectFromInjector:self.injector];
        STAssertNil(nilSet, @"Request of a non-mapped class returns nil.");
    }
    @catch (NSException *exception) {
        assertionThrown = YES;
    }

    STAssertTrue(assertionThrown, @"Request of a non-mapped class throws an error.");
}

- (void)testSimpleSpawnMapping
{
    TTTDISimpleObject *objectA = [TTTDISimpleObject objectFromInjector:self.injector];
    
    STAssertTrue([objectA isKindOfClass:[TTTDISimpleObject class]], @"Requested object for mapped class returns an instance of that class.");

    TTTDISimpleObject *objectB = [TTTDISimpleObject objectFromInjector:self.injector];

    STAssertFalse(objectA == objectB, @"Consecutive requested objects with simple mapping return newly allocated objects.");
}

- (void)testOnceMapping
{
    NSDictionary *dictionaryA = [NSDictionary objectFromInjector:self.injector];
    
    STAssertTrue([dictionaryA isKindOfClass:[NSDictionary class]], @"Requested object for mapped class returns an instance of that class.");
    
    BOOL assertionThrown = NO;
    
    @try {
        NSDictionary *dictionaryB = [NSDictionary objectFromInjector:self.injector];
        STAssertNil(dictionaryB, @"Second requested of a `once` object returns nil.");
    }
    @catch (NSException *exception) {
        assertionThrown = YES;
    }
    
    STAssertTrue(assertionThrown, @"Second request of a `once` object throws an error.");
}


- (void)testSingletonMapping
{
    TTTDISimpleSingleton *objectA = [TTTDISimpleSingleton objectFromInjector:self.injector];
    
    STAssertTrue([objectA isKindOfClass:[TTTDISimpleSingleton class]], @"Requested object for mapped class returns an instance of that class.");
    
    TTTDISimpleSingleton *objectB = [TTTDISimpleSingleton objectFromInjector:self.injector];
    
    STAssertTrue(objectA == objectB, @"Consecutive requested singletons return the same object every time.");
}

- (void)testSingletonSubclassMapping
{
    TTTDIBaseSingleton *objectA = [TTTDIBaseSingleton objectFromInjector:self.injector];
    
    STAssertTrue([objectA isKindOfClass:[TTTDIConcreteSingleton class]], @"Requested object for mapped base class returns an instance of the concrete subclass.");
    
    TTTDIBaseSingleton *objectB = [TTTDIBaseSingleton objectFromInjector:self.injector];
    
    STAssertTrue(objectA == objectB, @"Consecutive requested singletons return the same object every time.");
}

- (void)testObjectMapping
{
    NSArray *object = [NSArray objectFromInjector:self.injector];
    
    STAssertEquals(object, self.existingObject, @"Requested object for object-mapping returns the existing object");
}

- (void)testPropertyInjection
{
    TTTDIInjectableObject *injectable = [TTTDIInjectableObject objectFromInjector:self.injector];
                                         
    STAssertTrue([injectable isKindOfClass:[TTTDIInjectableObject class]], @"Requested object for mapped class returns an instance of that class.");
                                         
    STAssertTrue([injectable.simpleInjectedObject isKindOfClass:[TTTDISimpleObject class]], @"Property marked with the injectable protocol is injected with a proper object.");
    
    STAssertNil(injectable.simpleNotInjectedObject, @"Property not marked with the injectable protocol is not injected, even if the property's type actually implements that protocol.");
}

- (void)testPropertyObjectInjection
{
    TTTDIInjectableObject *injectable = [TTTDIInjectableObject objectFromInjector:self.injector];
    
    STAssertTrue(injectable.simpleList == self.simpleListObject, @"Object marked with the injectable protocol is injected with the proper object based on its name/identifier.");
}

@end
