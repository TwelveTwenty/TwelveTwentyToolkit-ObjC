#import <Foundation/Foundation.h>

@interface NSObject (TTTUnless)

- (void)ttt_unlessAttributePresent:(id)attribute setValue:(id)value;
- (void)ttt_unlessAttributePresent:(id)attribute performBlock:(void (^)())block;

@end