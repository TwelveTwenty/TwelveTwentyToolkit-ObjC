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

#import "TTSpawnMapping.h"

@interface TTSpawnMapping ()

@property (nonatomic, strong) Class spawnClass;
@property (nonatomic) TTSpawnType spawnType;

@end

@implementation TTSpawnMapping
{
	dispatch_once_t onceToken;
	id _singleton;
}

- (id)initWithParent:(id <TTInjectionMappingParent>)parent spawnClass:(Class)spawnClass spawnType:(TTSpawnType)spawnType
{
	self = [super initWithParent:parent object:nil];

	if (self)
	{
		self.spawnClass = spawnClass;
		self.spawnType = spawnType;
	}

	return self;
}

- (id)object
{
	switch (self.spawnType)
	{
		case TTSpawnTypeOnce:
			[self.parent removeChildMapping:self];

		default:
		case TTSpawnTypeEveryTime:
			return [[self.spawnClass alloc] init];

		case TTSpawnTypeSingleton:
			if (!_singleton)
			{
				dispatch_once(&onceToken, ^{_singleton = [[self.spawnClass alloc] init];});
			}

			return _singleton;
	}
}

@end