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

#import "EEEIntrospectProperty.h"

typedef enum
{
	TTPropertyFlagCopy = 1 << 0,
	TTPropertyFlagDynamic = 1 << 1,
	TTPropertyFlagNonAtomic = 1 << 2,
	TTPropertyFlagReadOnly = 1 << 3,
	TTPropertyFlagStrong = 1 << 4,
	TTPropertyFlagWeak = 1 << 5
} TTPropertyFlag;

@interface EEEIntrospectProperty ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *typeEncoding;
@property (nonatomic, copy, readwrite) Class typeClass;
@property (nonatomic, copy, readwrite) NSArray *typeProtocols;
@property (nonatomic, copy, readwrite) NSString *customGetter;
@property (nonatomic, copy, readwrite) NSString *customSetter;
@property (nonatomic, copy, readwrite) NSString *iVarName;
@property (nonatomic, readwrite) BOOL isObject;
@property (nonatomic) int flags;

@end

@implementation EEEIntrospectProperty

+ (NSArray *)propertiesOfClass:(Class)introspectClass
{
	unsigned int count;
	objc_property_t *list = class_copyPropertyList(introspectClass, &count);
	NSMutableArray *properties = [NSMutableArray array];
	for (unsigned i = 0; i < count; i++)
	{
		objc_property_t prop = list[i];
		[properties addObject:[[self alloc] initWithProperty:prop]];
	}

	free(list);
    
    Class superClass = class_getSuperclass( introspectClass );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        NSArray *superProperties = [self propertiesOfClass:superClass];
        if ([superProperties count])
        {
            [properties addObjectsFromArray:superProperties];
        }
    }
    
	return properties;
}

- (id)initWithProperty:(objc_property_t)prop
{
	self = [super init];
	if (self)
	{
		self.name = [NSString stringWithUTF8String:property_getName(prop)];
		NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(prop)];

		NSArray *pairs = [attributes componentsSeparatedByString:@","];
		self.flags = 0;
		for (NSString *pair in pairs)
		{
			NSString *attribute = [pair substringToIndex:1];
			NSString *value = [pair substringFromIndex:1];

			if ([@"T" isEqualToString:attribute])
			{
				// type encoding
				self.typeEncoding = [value length] ? value : @"id";

				if ([@"@" isEqualToString:[value substringToIndex:1]])
				{
					self.isObject = YES;

					NSMutableArray *protocols = [NSMutableArray array];
					if ([value length] > 3)
					{
						NSString *objectDesignation = [value substringFromIndex:2];
						objectDesignation = [objectDesignation substringToIndex:[objectDesignation length] - 1];

						NSMutableArray *chunks = [[objectDesignation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] mutableCopy];
						NSString *classDesignation = [chunks objectAtIndex:0];
						[chunks removeObjectAtIndex:0];

						self.typeClass = [classDesignation length] ? NSClassFromString(classDesignation) : [NSObject class];
                        NSParameterAssert(self.typeClass);

						while ([chunks count])
						{
							NSString *protoName = [chunks lastObject];
							Protocol *proto = NSProtocolFromString(protoName);
							if (proto)
							{
								[protocols insertObject:proto atIndex:0];
							}
							else if ([protoName length])
							{
                                // Food for thought: should this throw an assertion exception, or not?
//								DLog(@"Protocol named %@ can't be found. The compiler needs at least one implementation for this to work. Are you sure you have a class that implements it?", protoName);
							}
							[chunks removeLastObject];
						}
					}
					self.typeProtocols = protocols;
				}
				else
				{
					self.typeClass = [NSObject class];
				}
			}
			else if ([@"V" isEqualToString:attribute])
			{
				// backing ivar name
				self.iVarName = value;
			}
			else if ([@"C" isEqualToString:attribute])
			{
				// copy
				self.flags |= TTPropertyFlagCopy;
			}
			else if ([@"G" isEqualToString:attribute])
			{
				// custom getter
				self.customGetter = value;
			}
			else if ([@"S" isEqualToString:attribute])
			{
				// custom setter
				self.customSetter = value;
			}
			else if ([@"D" isEqualToString:attribute])
			{
				// dynamic
				self.flags |= TTPropertyFlagDynamic;
			}
			else if ([@"N" isEqualToString:attribute])
			{
				// nonatomic
				self.flags |= TTPropertyFlagNonAtomic;
			}
			else if ([@"R" isEqualToString:attribute])
			{
				// read-only
				self.flags |= TTPropertyFlagReadOnly;
			}
			else if ([@"&" isEqualToString:attribute])
			{
				// strong
				self.flags |= TTPropertyFlagStrong;
			}
			else if ([@"W" isEqualToString:attribute])
			{
				// weak
				self.flags |= TTPropertyFlagWeak;
			}
		}

	}

	return self;
}

- (BOOL)implementsProtocol:(Protocol *)proto
{
	for (Protocol *implementedProtocol in self.typeProtocols)
	{
		if (implementedProtocol == proto)
		{
			return YES;
		}
	}

	return NO;
}

- (BOOL)copyFlag
{
	return self.flags & TTPropertyFlagCopy;
}

- (BOOL)dynamicFlag
{
	return self.flags & TTPropertyFlagDynamic;
}

- (BOOL)nonAtomicFlag
{
	return self.flags & TTPropertyFlagNonAtomic;
}

- (BOOL)readOnlyFlag
{
	return self.flags & TTPropertyFlagReadOnly;
}

- (BOOL)strongFlag
{
	return self.flags & TTPropertyFlagStrong;
}

- (BOOL)weakFlag
{
	return self.flags & TTPropertyFlagWeak;
}

- (NSString *)description
{
	NSMutableArray *protocolNames = [NSMutableArray array];

	for (Protocol *proto in self.typeProtocols)
	{
		[protocolNames addObject:NSStringFromProtocol(proto)];
	}

	return [NSString stringWithFormat:@"<%@ name='%@' encoding='%@' type='%@' protocols='%@' readOnly='%@' strong='%@' weak='%@'>", [self class], self.name, self.typeEncoding, self.typeClass, [protocolNames componentsJoinedByString:@","], self.readOnlyFlag ? @"yes" : @"no", self.strongFlag ? @"yes" : @"no", self.weakFlag ? @"yes" : @"no"];
}

@end