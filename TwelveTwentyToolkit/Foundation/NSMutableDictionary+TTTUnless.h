#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TTTUnless)

- (void)unlessAttributePresent:(id)attribute setValue:(id)value;

@end