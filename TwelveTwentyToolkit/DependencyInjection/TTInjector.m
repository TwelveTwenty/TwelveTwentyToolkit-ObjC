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

#import "TTInjector.h"
#import "TTIntrospectProperty.h"
#import "TTInjectable.h"

static TTInjector *_sharedInjector;

@interface TTInjector () <TTInjectionMappingParent>

@property (nonatomic, strong) NSMutableDictionary *mappedClasses;
@property (nonatomic, strong) NSMutableDictionary *injections;

@end

@implementation TTInjector

+ (id <TTInjectorSpawning>)sharedInjector
{
	NSAssert(_sharedInjector != nil, @"Use `setSharedInjector:` before accessing `sharedInjector`.");
	return _sharedInjector;
}

+ (id <TTInjectorMapping>)sharedMappingInjector
{
	return (id <TTInjectorMapping>) [self sharedInjector];
}

+ (TTInjector *)setSharedInjector:(TTInjector *)injector
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{_sharedInjector = injector;});
	return _sharedInjector;
}

- (id)init
{
	self = [super init];

	if (self)
	{
		self.mappedClasses = [NSMutableDictionary dictionary];
		self.injections = [NSMutableDictionary dictionary];
	}

	return self;
}

#pragma mark - Mapping protocols and classes

- (id <TTClassMapping>)mapClass:(Class)class
{
	NSString *key = NSStringFromClass(class);
	NSAssert([self.mappedClasses objectForKey:key] == nil, @"Attempted duplicate mapping for class %@", key);

	TTClassMapping *mapping = [[TTClassMapping alloc] initWithParent:self mappedClass:class];
	self.mappedClasses[key] = mapping;

	return mapping;
}

- (void)unmapClass:(Class)class
{
	NSString *key = NSStringFromClass(class);
	NSAssert([self.mappedClasses objectForKey:key] != nil, @"Can't unmap a class if there's no such mapping (%@)", key);

	[self.mappedClasses removeObjectForKey:key];
}

- (void)removeChildMapping:(TTObjectMapping *)mapping
{
	[self.mappedClasses enumerateKeysAndObjectsUsingBlock:^(NSString *key, TTObjectMapping *existingMapping, BOOL *stop) {
		if (existingMapping == mapping)
		{
			[self.mappedClasses removeObjectForKey:key];
			*stop = YES;
		}
	}];
}

#pragma mark - Retrieving objects from mapped protocols and classes

- (id)objectForClass:(Class)class
{
	NSString *key = NSStringFromClass(class);
	NSAssert([self.mappedClasses objectForKey:key] != nil, @"No mapping found for class %@. Call `mapClass:` first.", key);
	return [self injectPropertiesIntoObject:[(TTObjectMapping *) self.mappedClasses[key] object]];
}

#pragma mark - Property injection

- (id)injectPropertiesIntoObject:(id <TTInjectable>)object
{
	if ([object conformsToProtocol:@protocol(TTInjectable)])
	{
		NSString *address = [NSString stringWithFormat:@"%p", &object];

		if (!self.injections[address])
		{
			self.injections[address] = [self performInjectionOnObject:object];

			if ([object respondsToSelector:@selector(didInjectProperties)])
			{
				[object didInjectProperties];
			}
		}
	}

	return object;
}

- (NSNumber *)performInjectionOnObject:(NSObject <TTInjectable> *)object
{
	NSArray *properties = [TTIntrospectProperty propertiesOfClass:[object class]];

	int count = 0;

	for (TTIntrospectProperty *prop in properties)
	{
		if (prop.isObject && [prop implementsProtocol:@protocol(TTInjectable)])
		{
			count++;
			[object setValue:[self objectForClass:prop.typeClass] forKey:prop.name];
		}
	}

	return @(count);
}

@end