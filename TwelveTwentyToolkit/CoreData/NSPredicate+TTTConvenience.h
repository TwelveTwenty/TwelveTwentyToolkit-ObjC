#import <Foundation/Foundation.h>

@interface NSPredicate (TTTConvenience)

+ (NSPredicate *)predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments;

@end