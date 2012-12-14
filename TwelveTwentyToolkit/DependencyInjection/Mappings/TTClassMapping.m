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

#import "TTClassMapping.h"
#import "TTSpawnMapping.h"

@interface TTClassMapping ()

@property (nonatomic, strong) Class mappedClass;
@property (nonatomic, strong) TTObjectMapping *childMapping;

@end

@implementation TTClassMapping

- (id)initWithParent:(id <TTInjectionMappingParent>)parent mappedClass:(Class)mappedClass
{
	self = [super initWithParent:parent object:nil];

	if (self)
	{
		self.mappedClass = mappedClass;
		self.childMapping = [[TTSpawnMapping alloc] initWithParent:self spawnClass:self.mappedClass spawnType:TTSpawnTypeEveryTime];
	}

	return self;
}

- (void)asSingleton
{
	self.childMapping = [[TTSpawnMapping alloc] initWithParent:self spawnClass:self.mappedClass spawnType:TTSpawnTypeSingleton];
}

- (void)once
{
	self.childMapping = [[TTSpawnMapping alloc] initWithParent:self spawnClass:self.mappedClass spawnType:TTSpawnTypeOnce];
}

- (void)toObject:(id)object
{
	self.childMapping = [[TTObjectMapping alloc] initWithParent:self object:object];
}

- (id <TTSubclassMapping>)toSubclass:(Class)class
{
	self.childMapping = [[TTClassMapping alloc] initWithParent:self mappedClass:class];

	return (id <TTSubclassMapping>) self.childMapping;
}

- (id)object
{
	NSAssert(self.childMapping != nil, @"%@ requires a child mapping. Use `toSubclass:`, `toObject:`, `asSingleton` or `once` to set it.", self);

	if (self.childMapping)
	{
		return [self.childMapping object];
	}

	return nil;
}

- (void)removeChildMapping:(TTObjectMapping *)mapping
{
	[self.parent removeChildMapping:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p mapped='%@'>%@</%@>", [self class], &self, self.mappedClass, self.childMapping, [self class]];
}

@end