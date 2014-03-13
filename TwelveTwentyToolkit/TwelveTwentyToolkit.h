// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl/)
//
// Permission is hereby granted, free of charge, to any unifiedCard obtaining a copy
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

extern void CFReleaseIfNotNULL (CFTypeRef ref);

extern CFTypeRef CFRetainIfNotNULL (CFTypeRef ref);

// http://stackoverflow.com/a/7848772/432782
// if (TTT_SYSTEM_VERSION_LESS_THAN(@"5.0")) {
//  ...
// }

#ifndef OVERRIDE_ATTRIBUTE
    #define OVERRIDE_ATTRIBUTE
#endif

#define TTTPrepareBlockSelf() __typeof__(self) __weak blockSelf = self

#define TTTStaticScreenScale() static CGFloat scale = 0; \
if (!scale) scale = [UIScreen mainScreen].scale;

#define TTTStaticMainScreenBounds() static CGRect mainScreenBounds = (CGRect){0,0,0,0}; \
if (CGRectEqualToRect(mainScreenBounds, CGRectZero)) mainScreenBounds = [UIScreen mainScreen].bounds;

#if !defined(NS_BLOCK_ASSERTIONS)

#if !defined(TTTBlockAssert)
#define TTTBlockAssert(condition, desc, ...)	\
    do {				\
	__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
	if (!(condition)) {		\
	    [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd \
		object:blockSelf file:[NSString stringWithUTF8String:__FILE__] \
	    	lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \
	}				\
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)
#endif

#else // NS_BLOCK_ASSERTIONS defined

#if !defined(TTTBlockAssert)
#define TTTBlockAssert(condition, desc, ...) do {} while (0)
#endif

#endif