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
#import <objc/runtime.h>

@interface TTTIntrospectProperty : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *typeEncoding;
@property (nonatomic, copy, readonly) Class typeClass;
@property (nonatomic, copy, readonly) NSArray *typeProtocols;
@property (nonatomic, copy, readonly) NSString *customGetter;
@property (nonatomic, copy, readonly) NSString *customSetter;
@property (nonatomic, copy, readonly) NSString *iVarName;

@property (nonatomic, readonly) BOOL copyFlag;
@property (nonatomic, readonly) BOOL dynamicFlag;
@property (nonatomic, readonly) BOOL nonAtomicFlag;
@property (nonatomic, readonly) BOOL readOnlyFlag;
@property (nonatomic, readonly) BOOL strongFlag;
@property (nonatomic, readonly) BOOL weakFlag;
@property (nonatomic, readonly) BOOL isObject;

+ (NSArray *)propertiesOfClass:(Class)introspectClass;

- (id)initWithProperty:(objc_property_t)prop;

- (id)init NS_UNAVAILABLE;

- (BOOL)implementsProtocol:(Protocol *)proto;

@end