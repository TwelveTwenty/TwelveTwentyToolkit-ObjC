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

#import "EEEInjectionMapping.h"
#import "EEEIntrospectProperty.h"
#import "EEEInjector.h"

#define IS_SINGLETON (self.options & EEETerminationOptionSingleton)
#define IS_SINGLE_SERVING (self.options & EEETerminationOptionSingleServing)
#define IS_ALLOC_ONLY (self.options & EEETerminationOptionAllocOnly)

@interface EEEInjectionMapping ()

@property(nonatomic, strong) Class mappedClass;
@property(nonatomic, strong) EEEInjectionMapping *childMapping;
@property(nonatomic) EEETerminationOption options;
@property(nonatomic, weak, readwrite) id <EEEInjectionMappingParent> parent;
@property(nonatomic, strong, readwrite) id targetObject;
@property(nonatomic, strong, readwrite) EEEInjectionBlock targetBlock;
@property(nonatomic, readonly) EEEInjectionMapping *endMapping;
@property(nonatomic, strong) NSMutableDictionary *injectables;

@end

@implementation EEEInjectionMapping
{
    dispatch_once_t _onceToken;
    id _singleton;
}

#pragma mark Class mapping source

- (id)initWithParent:(id <EEEInjectionMappingParent>)parent mappedClass:(Class)mappedClass options:(EEETerminationOption)options
{
    self = [super init];

    if (self)
    {
        self.parent = parent;
        self.mappedClass = mappedClass;
        self.options = options;
        self.injectables = [NSMutableDictionary dictionary];
        {
            NSArray *properties = [EEEIntrospectProperty propertiesOfClass:mappedClass];
            for (EEEIntrospectProperty *prop in properties)
            {
                if (prop.isObject && [prop implementsProtocol:@protocol(EEEInjectable)])
                {
                    self.injectables[prop.name] = prop.typeClass;
                }
            }
        }
    }

    return self;
}

- (id <EEEInjectionMappingEnd>)toObject:(id)object
{
    self.targetObject = object;
    [self assertIntegrity];
    return self;
}

- (id <EEEInjectionMappingEnd>)toBlock:(EEEInjectionBlock)block
{
    self.targetBlock = block;
    [self assertIntegrity];
    return self;
}

#pragma mark Class mapping target

- (id <EEEInjectionMapping>)toSubclass:(Class)class
{
    self.childMapping = [[EEEInjectionMapping alloc] initWithParent:self mappedClass:class options:EEETerminationOptionNone];
    [self assertIntegrity];
    return (id <EEEInjectionMapping>) self.childMapping;
}

- (id <EEEInjectionMappingEnd>)allocOnly
{
    self.options |= EEETerminationOptionAllocOnly;
    [self assertIntegrity];
    return self;
}

- (void)asSingleton
{
    self.options |= EEETerminationOptionSingleton;
    [self assertIntegrity];
}

- (void)singleServing
{
    self.options |= EEETerminationOptionSingleServing;
    [self assertIntegrity];
}

- (void)assertIntegrity
{
    NSAssert(!(IS_SINGLE_SERVING && IS_SINGLETON), @"Can't mix `singleServing` with `asSingleton`");
    NSAssert(!(_targetObject != nil && IS_SINGLETON), @"Can't mix `toObject:` with `asSingleton`");
    NSAssert(!(IS_ALLOC_ONLY && IS_SINGLETON), @"Can't mix `allocOnly` with `asSingleton`");
    NSAssert(!(_targetObject != nil && IS_ALLOC_ONLY), @"Can't mix `allocOnly` with `toObject:`");
}

#pragma mark - Class and object retrieval

- (Class)targetClass
{
    if (self.childMapping != nil)
    {
        return [self.childMapping targetClass];
    }

    [self checkRemoveFromParent];

    return self.mappedClass;
}

- (id)targetObject
{
    if (self.childMapping != nil)
    {
        return [self.childMapping targetObject];
    }

    NSAssert(!IS_ALLOC_ONLY, @"Can't retrieve object from alloc-only mapping. Use `targetClass`");

    [self checkRemoveFromParent];

    if (_targetObject != nil)
    {
        return _targetObject;
    }
    else if (IS_SINGLETON)
    {
        dispatch_once(&_onceToken, ^{_singleton = [[self.mappedClass alloc] init];});
        return _singleton;
    }
    else if (_targetBlock != nil)
    {
        return _targetBlock();
    }
    else
    {
        return [[self.mappedClass alloc] init];
    }
}

#pragma mark - Removing parent mapping

- (void)checkRemoveFromParent
{
    if (IS_SINGLE_SERVING)
    {
        [self.parent removeChildMapping:self];
        self.parent = nil;
    }
}

- (void)removeChildMapping:(EEEInjectionMapping *)mapping
{
    // bubble up to the injector.
    [self.parent removeChildMapping:self];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p mapped='%@'>%@</%@>", [self class], &self, self.mappedClass, self.childMapping ?: @"no child mapping", [self class]];
}

@end