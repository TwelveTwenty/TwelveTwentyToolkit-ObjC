#import "NSError+TTTOperationCenter.h"

@implementation NSError (TTTOperationCenter)

+ (NSError *)ttt_operationCenterErrorWithCode:(TTTOperationCenterErrorCode)code description:(NSString *)description
{
    return [self errorWithDomain:TTT_OPERATION_CENTER_ERROR_DOMAIN code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

- (BOOL)ttt_errorIsOperationCancelled
{
    return self.code == TTTOperationCenterErrorCodeCancelled && [self.domain isEqualToString:TTT_OPERATION_CENTER_ERROR_DOMAIN];
}

@end
