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

#define TTT_LOG_LEVEL_DEBUG		10
#define TTT_LOG_LEVEL_INFO		20
#define TTT_LOG_LEVEL_WARN		30
#define TTT_LOG_LEVEL_ERROR		40

#define TTT_LOG_LEVEL			10

extern int kTTTLogLevel;

#define TTT_LOG_DEBUG			(TTT_LOG_LEVEL <= TTT_LOG_LEVEL_DEBUG)
#define TTT_LOG_INFO			(TTT_LOG_LEVEL <= TTT_LOG_LEVEL_INFO)
#define TTT_LOG_WARN			(TTT_LOG_LEVEL <= TTT_LOG_LEVEL_WARN)
#define TTT_LOG_ERROR			(TTT_LOG_LEVEL <= TTT_LOG_LEVEL_ERROR)

void QuietLog (NSString *format, ...);

#if TTT_LOG_DEBUG
#   define DLog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_DEBUG) { QuietLog(@"\n%@ ⇨ %@(%d)", [NSString stringWithFormat:__VA_ARGS__], [NSString stringWithUTF8String:__FUNCTION__], __LINE__); }
//#   define DLog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_DEBUG) { NSLog(@"[DEBUG]%s(%d)\n⇨ %@\n ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); }
#else
#	define DLog(...)
#endif

#if TTT_LOG_INFO
#if TTT_LOG_DEBUG
#   define ILog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_INFO) { QuietLog(@"\n[INFO]\t%@ ⇨ %@(%d)", [NSString stringWithFormat:__VA_ARGS__], [NSString stringWithUTF8String:__FUNCTION__], __LINE__); }
#else
#	define ILog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_INFO) { NSLog(@"[INFO]%s(%d)\n⇨ %@\n ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); }
#endif
#else
#	define ILog(...)
#endif

#if TTT_LOG_WARN
#if TTT_LOG_DEBUG
#   define WLog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_WARN) { QuietLog(@"\n[WARN]\t%@ ⇨ %@(%d)", [NSString stringWithFormat:__VA_ARGS__], [NSString stringWithUTF8String:__FUNCTION__], __LINE__); }
#else
#	define WLog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_WARN) { NSLog(@"[WARN]%s(%d)\n⇨ %@\n ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); }
#endif
#else
#	define WLog(...)
#endif

#if TTT_LOG_ERROR
#if TTT_LOG_DEBUG
#   define ELog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_ERROR) { QuietLog(@"\n[ERROR]\t%@ ⇨ %@(%d)", [NSString stringWithFormat:__VA_ARGS__], [NSString stringWithUTF8String:__FUNCTION__], __LINE__); }
#else
#	define ELog(...) if (kTTTLogLevel <= TTT_LOG_LEVEL_ERROR) { NSLog(@"[ERROR]%s(%d)\n⇨ %@\n ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); }
#endif
#else
#	define ELog(...)
#endif
