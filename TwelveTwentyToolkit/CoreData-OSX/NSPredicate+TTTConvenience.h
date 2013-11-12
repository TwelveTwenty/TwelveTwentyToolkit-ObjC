#import <Foundation/Foundation.h>

@interface NSPredicate (TTTConvenience)

+ (NSPredicate *)ttt_predicateWithComplexFormat:(NSString *)complexFormat innerArguments:(NSArray *)innerArguments outerArguments:(NSArray *)outerArguments;

@end