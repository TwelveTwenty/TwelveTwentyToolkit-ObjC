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

@interface TTInjector () <TTInjectionMappingParent>

@property (nonatomic, strong) NSMutableDictionary *classMappings;
@property (nonatomic, strong) NSMutableDictionary *injections;

@end

@implementation TTInjector

+ (TTInjector *)sharedInjector
{
	NSAssert(_sharedInjector != nil, @"Use `setSharedInjector:` before accessing `sharedInjector`.");
	return _sharedInjector;
}

+ (id <TTInjectionMapper>)sharedMappingInjector
{
	return (id <TTInjectionMapper>) [self sharedInjector];
}

+ (id <TTInjectionMapper>)setSharedInjector:(TTInjector *)injector
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{_sharedInjector = injector;});
	return _sharedInjector;
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
		self.injections = [NSMutableDictionary dictionary];
	}

	return self;
}

#pragma mark - Mapping protocols and classes

- (id <TTInjectionMappingStart>)mapClass:(Class)class
{
	return [self mapClass:class withIdentifier:nil];
}

- (id <TTInjectionMappingStart>)mapClass:(Class)class withIdentifier:(NSString *)identifier
{
	NSString *key = [[self class] keyForClass:class withIdentifier:identifier];
	NSAssert([self.classMappings objectForKey:key] == nil, @"Attempted duplicate mapping for key %@", key);

	TTInjectionMapping *mapping = [[TTInjectionMapping alloc] initWithParent:self mappedClass:class options:TTTerminationOptionNone];
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

- (void)removeChildMapping:(TTInjectionMapping *)mapping
{
	[self.classMappings enumerateKeysAndObjectsUsingBlock:^(NSString *key, TTInjectionMapping *existingMapping, BOOL *stop) {
		if (existingMapping == mapping)
		{
			[self.classMappings removeObjectForKey:key];
			*stop = YES;
		}
	}];
}

#pragma mark - Retrieving objects from mapped protocols and classes

- (TTInjectionMapping *)mappingForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
	NSString *key = [[self class] keyForClass:mappedClass withIdentifier:identifier];
	TTInjectionMapping *mapping = self.classMappings[key];
	return mapping;
}

- (id)objectForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
	TTInjectionMapping *mapping = [self mappingForMappedClass:mappedClass withIdentifier:identifier];
	return [self injectPropertiesIntoObject:[mapping targetObject]];
}

- (Class)classForMappedClass:(Class)mappedClass withIdentifier:(NSString *)identifier
{
	TTInjectionMapping *mapping = [self mappingForMappedClass:mappedClass withIdentifier:identifier];
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
			id value = [self objectForMappedClass:prop.typeClass withIdentifier:prop.name];
			if (!value) value = [self objectForMappedClass:prop.typeClass withIdentifier:nil];
			NSAssert(value != nil, @"No mapping found for property %@ marked with <TTInjectable>", prop.name);
			[object setValue:value forKey:prop.name];
		}
	}

	return @(count);
}

@end

@implementation NSObject (TTInjector)

+ (id)allocWithInjector:(TTInjector *)injector
{
	Class targetClass = [injector classForMappedClass:self withIdentifier:nil];
	return [targetClass alloc];
}

+ (id)objectFromInjector:(TTInjector *)injector
{
    return [self objectFromInjector:injector withIdentifier:nil];
}

+ (id)objectFromInjector:(TTInjector *)injector withIdentifier:(NSString *)identifier
{
	id value =  [injector objectForMappedClass:self withIdentifier:identifier];
    NSAssert(value != nil, @"No value found mapped to %@", [self class]);
    return value;
}

- (id)injectWithInjector:(TTInjector *)injector
{
	[injector injectPropertiesIntoObject:(id <TTInjectable>) self];
	return self;
}

@end