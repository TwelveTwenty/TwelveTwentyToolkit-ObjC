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

@class EEEInjectionMapping;

@protocol EEEInjectionMappingEnd

- (void)singleServing;

@end

@protocol EEEInjectionMapping <EEEInjectionMappingEnd>

- (id <EEEInjectionMappingEnd>)allocOnly;

- (void)asSingleton;

@end

@protocol EEEInjectionMappingStart <EEEInjectionMapping>

- (id <EEEInjectionMapping>)toSubclass:(Class)class;

- (id <EEEInjectionMappingEnd>)toObject:(id)object;

typedef id (^EEEInjectionBlock)();
- (id <EEEInjectionMappingEnd>)toBlock:(EEEInjectionBlock)block;

@end

typedef enum
{
	EEETerminationOptionNone = 0,
	EEETerminationOptionSingleServing = 1 << 0, // unmap after calling `object` or `targetClass`.
	EEETerminationOptionSingleton = 1 << 1, // alloc/init singleton. The opposite performs alloc/init every time.
	EEETerminationOptionAllocOnly = 1 << 2 // object can't be called on a mapping like this.
} EEETerminationOption;

@protocol EEEInjectionMappingParent <NSObject>

- (void)removeChildMapping:(EEEInjectionMapping *)mapping;

@end

@interface EEEInjectionMapping : NSObject <EEEInjectionMappingStart, EEEInjectionMappingParent>

@property (nonatomic, strong, readonly) Class targetClass;
@property (nonatomic, strong, readonly) id targetObject;
@property (nonatomic, strong, readonly) NSMutableDictionary *injectables;

- (id)initWithParent:(id <EEEInjectionMappingParent>)parent mappedClass:(Class)mappedClass options:(EEETerminationOption)options;

@end

