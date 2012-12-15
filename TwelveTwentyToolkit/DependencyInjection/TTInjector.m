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

static TTInjector *_sharedInjector;

@interface TTInjector () <TTClassMappingParentNode>

@property (nonatomic, strong) NSMutableDictionary *classMappings;
@property (nonatomic, strong) NSMutableDictionary *injections;

@end

@implementation TTInjector

+ (TTInjector *)sharedInjector
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
		self.classMappings = [NSMutableDictionary dictionary];
		self.injections = [NSMutableDictionary dictionary];
	}

	return self;
}

#pragma mark - Mapping protocols and classes

- (id <TTClassMappingSource>)mapClass:(Class)class
{
	NSString *key = NSStringFromClass(class);
	NSAssert([self.classMappings objectForKey:key] == nil, @"Attempted duplicate mapping for class %@", key);

	TTClassMappingTarget *mapping = [[TTClassMappingTarget alloc] initWithParent:self mappedClass:class options:TTTerminationOptionNone];
	self.classMappings[key] = mapping;

	return mapping;
}

- (void)unmapClass:(Class)class
{
	NSString *key = NSStringFromClass(class);
	NSAssert([self.classMappings objectForKey:key] != nil, @"Can't unmap a class if there's no such mapping (%@)", key);

	[self.classMappings removeObjectForKey:key];
}

- (void)removeChildMapping:(TTClassMappingTarget *)mapping
{
	[self.classMappings enumerateKeysAndObjectsUsingBlock:^(NSString *key, TTClassMappingTarget *existingMapping, BOOL *stop) {
		if (existingMapping == mapping)
		{
			[self.classMappings removeObjectForKey:key];
			*stop = YES;
		}
	}];
}

#pragma mark - Retrieving objects from mapped protocols and classes

- (TTClassMappingTarget *)mappingForMappedClass:(Class)mappedClass
{
	NSString *key = NSStringFromClass(mappedClass);
	NSAssert([self.classMappings objectForKey:key] != nil, @"No mapping found for class %@. Call `mapClass:` first.", key);
	TTClassMappingTarget *mapping = self.classMappings[key];
	return mapping;
}

- (id)objectForMappedClass:(Class)mappedClass
{
	TTClassMappingTarget *mapping = [self mappingForMappedClass:mappedClass];
	return [self injectPropertiesIntoObject:[mapping targetObject]];
}

- (Class)classForMappedClass:(Class)mappedClass
{
	TTClassMappingTarget *mapping = [self mappingForMappedClass:mappedClass];
	return [mapping targetClass];
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
			[object setValue:[self objectForMappedClass:prop.typeClass] forKey:prop.name];
		}
	}

	return @(count);
}

@end

@implementation NSObject (TTInjector)

+ (id)allocFromInjector:(TTInjector *)injector
{
	Class targetClass = [injector classForMappedClass:self];
	return [targetClass alloc];
}

+ (id)objectFromInjector:(TTInjector *)injector
{
	return [injector objectForMappedClass:self];
}

@end