#import <Foundation/Foundation.h>

@interface NSPredicate (TTTConvenience)

+ (NSPredicate *)tttPredicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments;

@end