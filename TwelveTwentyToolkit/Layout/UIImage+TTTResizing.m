#import "UIImage+TTTResizing.h"


@implementation UIImage (TTTResizing)

+ (UIImage *)ttt_resizableImageForCapInsetsName:(NSString *)nameWithCapInsets
{
	UIImage *original = [UIImage imageNamed:nameWithCapInsets];
	NSArray *chunks = [nameWithCapInsets componentsSeparatedByString:@"-"];
	NSAssert([chunks count] >= 5, @"Incorrect name format, should contain at least 4 dashes: '%@'", nameWithCapInsets);
	UIEdgeInsets capInsets = UIEdgeInsetsMake([chunks[1] integerValue], [chunks[2] integerValue], [chunks[3] integerValue], [chunks[4] integerValue]);
	return [original resizableImageWithCapInsets:capInsets];
}

@end