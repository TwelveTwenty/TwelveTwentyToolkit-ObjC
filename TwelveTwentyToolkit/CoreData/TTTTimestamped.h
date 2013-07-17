#import <Foundation/Foundation.h>

extern const struct TTTTimestampedAttributes
{
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *updatedAt;
} TTTTimestampedAttributes;

@protocol TTTTimestamped <NSObject>

@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;

@end

@protocol TTTTimestampedLocally <TTTTimestamped>
@end
