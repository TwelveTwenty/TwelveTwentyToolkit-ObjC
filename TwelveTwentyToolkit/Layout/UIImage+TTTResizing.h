#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (TTTResizing)

/**
* If your image name uses a specific format, this method will return a resizable image
* with the cap insets taken from the image's string name.
*
* @param nameWithCapInsets format: "Leading-top-left-bottom-right-Trailing"
*                                            ^   ^    ^      ^
* Example:      "ButtonLight-0-21-4-21-normal@2x.png"
* Results in:   top: 0
*               left: 21
*               bottom: 4
*               right: 21
*
*/
+ (UIImage *)ttt_resizableImageForCapInsetsName:(NSString *)nameWithCapInsets;

@end