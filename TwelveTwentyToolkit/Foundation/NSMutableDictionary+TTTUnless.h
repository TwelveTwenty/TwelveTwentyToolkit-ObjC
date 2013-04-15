#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TTTUnless)

- (void)tttUnlessAttributePresent:(id)attribute setValue:(id)value;

@end