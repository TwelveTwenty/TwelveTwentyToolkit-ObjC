#import "NSString+TTTURLEncoding.h"

@implementation NSString (TTTURLEncoding)

// http://madebymany.com/blog/url-encoding-an-nsstring-on-ios
- (NSString *)ttt_URLEncode
{
    CFStringRef escapedRef = CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (__bridge CFStringRef) self,
            NULL,
            (__bridge CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ~",
            kCFStringEncodingUTF8);

    return (NSString *) CFBridgingRelease(escapedRef);
}
@end