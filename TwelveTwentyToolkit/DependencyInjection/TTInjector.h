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
#import "TTInjectionMapping.h"

#define injectAlloc allocWithInjector:[TTInjector sharedInjector]
#define injectObject objectFromInjector:[TTInjector sharedInjector]
#define inject injectWithInjector:[TTInjector sharedInjector]

@protocol TTInjectable <NSObject>

@optional
- (void)didInjectProperties;

@end

@protocol TTInjectionMapper

- (id <TTInjectionMappingStart>)mapClass:(Class)class;

- (void)unmapClass:(Class)class;

@end

@interface TTInjector : NSObject <TTInjectionMapper>

+ (TTInjector *)sharedInjector;

+ (id <TTInjectionMapper>)sharedMappingInjector;

+ (id <TTInjectionMapper>)setSharedInjector:(TTInjector *)injector;

@end

@interface NSObject (TTInjector)

+ (id)allocWithInjector:(TTInjector *)injector;

+ (id)objectFromInjector:(TTInjector *)injector;

- (id)injectWithInjector:(TTInjector *)injector;

@end