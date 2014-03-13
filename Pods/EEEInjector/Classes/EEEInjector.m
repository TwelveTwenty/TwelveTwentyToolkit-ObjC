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

#import "EEEInjector.h"
#import "EEEIntrospectProperty.h"

static EEEInjector *_currentInjector;

@interface EEEInjector () <EEEInjectionMappingParent>

@property(nonatomic, strong) NSMutableDictionary *classMappings;

@end

@implementation EEEInjector

+ (instancetype)currentInjector
{
    return _currentInjector;
}

+ (instancetype)defaultCurrentInjector
{
    return [self setCurrentInjector:[[self alloc] init] force:NO];
}

+ (instancetype)setCurrentInjector:(EEEInjector *)injector force:(BOOL)force
{
    @synchronized (self)
    {
        if (!force && injector)
        {
            NSAssert(_currentInjector == nil, @"Won't setup the shared injector if there already is one.");
        }

        _currentInjector = injector;
    }
    return _currentInjector;
}

+ (EEEInjector *)sharedInjector
{
    return [self currentInjector];
}

+ (EEEInjector *)setSharedInjector
{
    return [self setSharedInjector:[[self alloc] init]];
}

+ (EEEInjector *)setSharedInjector:(EEEInjector *)injector
{
    @synchronized (self)
    {
        if (injector)
        {
            NSAssert(_currentInjector == nil, @"Won't setup the shared injector if there already is one.");
        }

        _currentInjector = injector;
    }
    return _currentInjector;
}

+ (NSString *)keyForClass:(Class)class withIdentifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"%@xC@%@", NSStringFromClass(class), identifier ? identifier : @""];
}

+ (NSString *)keyForProtocol:(Protocol *)proto withIdentifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"%@xP@%@", NSStringFromProtocol(proto), identifier ? identifier : @""];
}

- (id)init
{
    self = [super init];

    if (self)
    {
        self.classMappings = [NSMutableDictionary dictionary];

        [[self mapClass:[self class]] toObject:self];
    }

    return self;
}

- (id <EEEInjectionMapper>)asMapper
{
    return self;
}

#pragma mark - Mapping protocols and classes

- (id <EEEInjectionMappingStart>)mapClass:(Class)class
{
    return [self mapClass:class withIdentifier:nil];
}

- (id <EEEInjectionMappingStart>)mapClass:(Class)class withIdentifier:(NSString *)identifier
{
    return [self mapClass:class withIdentifier:identifier overwriteExisting:NO];
}

- (id <EEEInjectionMappingStart>)mapClass:(Class)class overwriteExisting:(BOOL)overwriteExisting
{
    return [self mapClass:class withIdentifier:nil overwriteExisting:overwriteExisting];
}

- (id <EEEInjectionMappingStart>)mapClass:(Class)class withIdentifier:(NSString *)identifier overwriteExisting:(BOOL)overwriteExisting
{
    NSString *key = [[self class] keyForClass:class withIdentifier:identifier];

    if (!overwriteExisting)
    {
        NSAssert([self.classMappings objectForKey:key] == nil, @"Attempted duplicate mapping for key %@", key);
    }

    EEEInjectionMapping *mapping = [[EEEInjectionMapping alloc] initWithParent:self mappedClass:class options:EEETerminationOptionNone];
    self.classMappings[key] = mapping;

    return mapping;
}

- (void)unmapClass:(Class)class
{
    [self unmapClass:class withIdentifier:nil];
}

- (void)unmapClass:(Class)class withIdentifier:(NSString *)identifier
{
    NSString *key = [[self class] keyForClass:class withIdentifier:identifier];
    NSAssert([self.classMappings objectForKey:key] != nil, @"Can't unmap a class if there's no such mapping (%@)", key);

    [self.classMappings removeObjectForKey:key];
}

- (void)removeChildMapping:(EEEInjectionMapping *)mapping
{
    [self.classMappings enumerateKeysAndObjectsUsingBlock:^(NSString *key, EEEInjectionMapping *existingMapping, BOOL *stop) {
        if (existingMapping == mapping)
        {
            [self.classMappings removeObjectForKey:key];
            *stop = YES;
        }
    }];
}

- (EEEInjector *)asInjector
{
    return self;
}


#pragma mark - Retrieving objects from mapped protocols and classes

- (EEEInjectionMapping *)mappingForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
    NSString *key = [[self class] keyForClass:mappedClass withIdentifier:identifier];
    EEEInjectionMapping *mapping = self.classMappings[key];

    if (!mapping)
    {
        key = [[self class] keyForClass:mappedClass withIdentifier:nil];
        mapping = self.classMappings[key];
    }

    if (!mapping && self.allowImplicitMapping)
    {
        mapping = [[EEEInjectionMapping alloc] initWithParent:self mappedClass:mappedClass options:EEETerminationOptionNone];
    }

    return mapping;
}

- (id)objectForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
    EEEInjectionMapping *mapping = [self mappingForMappedClass:mappedClass withIdentifier:identifier];
    return [self injectPropertiesIntoObject:[mapping targetObject] withMapping:mapping];
}

- (Class)classForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
    EEEInjectionMapping *mapping = [self mappingForMappedClass:mappedClass withIdentifier:identifier];
    return [mapping targetClass];
}


#pragma mark - Property injection

- (id)injectPropertiesIntoObject:(id)object
{
    return [self injectPropertiesIntoObject:object withMapping:nil];
}

- (id)injectPropertiesIntoObject:(id)object withMapping:(EEEInjectionMapping *)mapping
{
    if (!mapping && self.allowImplicitMapping)
    {
        // Multiple injection calls on the same object-kind could cause multiple mappings
        // to be created implicitly, overwriting each other as values in the classMappings
        // dictionary. This @synchronized block prevents this to cause race conditions and
        // over-released mapping objects.
        @synchronized (object)
        {
            if (!mapping && self.allowImplicitMapping)
            {
                NSString *key = [[self class] keyForClass:[object class] withIdentifier:nil];
                mapping = [[EEEInjectionMapping alloc] initWithParent:self mappedClass:[object class] options:EEETerminationOptionNone];
                self.classMappings[key] = mapping;
            }
        }
    }
    BOOL previouslyInjected = [self performInjectionOnObject:object withMapping:mapping];

    if (!previouslyInjected && [object respondsToSelector:@selector(didInjectProperties)])
    {
        [object didInjectProperties];
    }

    return object;
}

- (BOOL)performInjectionOnObject:(NSObject <EEEInjectable> *)object withMapping:(EEEInjectionMapping *)mapping
{
    __block int count = 0;
    __block BOOL nonNilPropertiesFound = NO;
    if (mapping)
    {
        [mapping.injectables enumerateKeysAndObjectsUsingBlock:^(NSString *identifier, Class typeClass, BOOL *stop) {
            if ([object valueForKey:identifier] == nil)
            {
                count++;
                id value = [self objectForMappedClass:typeClass withIdentifier:identifier];
                [object setValue:value forKey:identifier];
            }
            else
            {
                nonNilPropertiesFound = YES;
            }
        }];
    }
    else
    {
        NSArray *properties = [EEEIntrospectProperty propertiesOfClass:[object class]];

        for (EEEIntrospectProperty *prop in properties)
        {
            if (prop.isObject && [prop implementsProtocol:@protocol(EEEInjectable)])
            {
                if ([object valueForKey:prop.name] == nil)
                {
                    count++;
                    id value = [self objectForMappedClass:prop.typeClass withIdentifier:prop.name];
                    if (!value) value = [self objectForMappedClass:prop.typeClass withIdentifier:nil];
                    NSAssert(value != nil, @"No mapping found for property %@ marked with <EEEInjectable>", prop.name);
                    [object setValue:value forKey:prop.name];
                }
                else
                {
                    nonNilPropertiesFound = YES;
                }
            }
        }
    }

    return nonNilPropertiesFound;
}

@end

@implementation NSObject (EEEInjector)

+ (Class)eee_classWithInjector:(EEEInjector *)injector
{
    NSAssert(injector, @"Can't inject from nil injector.");
    return [injector classForMappedClass:self withIdentifier:nil];
}

+ (id)eee_allocWithInjector:(EEEInjector *)injector
{
    NSAssert(injector, @"Can't inject from nil injector.");
    Class targetClass = [injector classForMappedClass:self withIdentifier:nil];
    return [targetClass alloc];
}

+ (instancetype)eee_objectFromInjector:(EEEInjector *)injector
{
    NSAssert(injector, @"Can't inject from nil injector.");
    return [self eee_objectFromInjector:injector withIdentifier:nil];
}

+ (instancetype)eee_objectFromInjector:(EEEInjector *)injector withIdentifier:(NSString *)identifier
{
    NSAssert(injector, @"Can't inject from nil injector.");
    id value = [injector objectForMappedClass:self withIdentifier:identifier];
    NSAssert(value != nil, @"No value found mapped to %@. Use allowImplicitMapping to prevent this from happening", [self class]);
    return value;
}

- (instancetype)eee_injectWithInjector:(EEEInjector *)injector
{
    NSAssert(injector, @"Can't inject from nil injector.");
    [injector injectPropertiesIntoObject:(id <EEEInjectable>) self withMapping:nil ];
    return self;
}

@end