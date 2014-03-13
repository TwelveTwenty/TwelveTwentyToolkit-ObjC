#import "NSError+EEEOperationCenter.h"

@implementation NSError (EEEOperationCenter)

+ (NSError *)eee_operationCenterErrorWithCode:(EEEOperationCenterErrorCode)code description:(NSString *)description
{
    return [self errorWithDomain:EEE_OPERATION_CENTER_ERROR_DOMAIN code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

- (BOOL)eee_errorIsOperationCancelled
{
    return self.code == EEEOperationCenterErrorCodeCancelled && [self.domain isEqualToString:EEE_OPERATION_CENTER_ERROR_DOMAIN];
}

@end
