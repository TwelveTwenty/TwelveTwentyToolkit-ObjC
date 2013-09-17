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

@class TTTInjectionMapping;

@protocol TTInjectionMappingEnd

- (void)singleServing;

@end

@protocol TTTInjectionMapping <TTInjectionMappingEnd>

- (id <TTInjectionMappingEnd>)allocOnly;

- (void)asSingleton;

@end

@protocol TTInjectionMappingStart <TTTInjectionMapping>

- (id <TTTInjectionMapping>)toSubclass:(Class)class;

- (id <TTInjectionMappingEnd>)toObject:(id)object;

typedef id (^TTTInjectionBlock)();
- (id <TTInjectionMappingEnd>)toBlock:(TTTInjectionBlock)block;

@end

typedef enum
{
	TTTerminationOptionNone = 0,
	TTTerminationOptionSingleServing = 1 << 0, // unmap after calling `object` or `targetClass`.
	TTTerminationOptionSingleton = 1 << 1, // alloc/init singleton. The opposite performs alloc/init every time.
	TTTerminationOptionAllocOnly = 1 << 2 // object can't be called on a mapping like this.
} TTTerminationOption;

@protocol TTInjectionMappingParent <NSObject>

- (void)removeChildMapping:(TTTInjectionMapping *)mapping;

@end

@interface TTTInjectionMapping : NSObject <TTInjectionMappingStart, TTInjectionMappingParent>

@property (nonatomic, strong, readonly) Class targetClass;
@property (nonatomic, strong, readonly) id targetObject;
@property (nonatomic, strong, readonly) NSMutableDictionary *injectables;

- (id)initWithParent:(id <TTInjectionMappingParent>)parent mappedClass:(Class)mappedClass options:(TTTerminationOption)options;

@end

