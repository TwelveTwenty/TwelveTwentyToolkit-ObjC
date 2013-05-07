#import <Foundation/Foundation.h>

@interface NSObject (TTTUnless)

- (void)tttUnlessAttributePresent:(id)attribute setValue:(id)value;
- (void)tttUnlessAttributePresent:(id)attribute performBlock:(void (^)())block;

@end