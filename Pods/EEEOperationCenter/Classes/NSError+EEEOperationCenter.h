#import <Foundation/Foundation.h>

#define EEE_OPERATION_CENTER_ERROR_DOMAIN @"EEE_OPERATION_CENTER_ERROR_DOMAIN"

typedef enum
{
    EEEOperationCenterErrorCodeUnknown = 0,
    EEEOperationCenterErrorCodeCancelled = 20,
} EEEOperationCenterErrorCode;

@interface NSError (EEEOperationCenter)

+ (NSError *)eee_operationCenterErrorWithCode:(EEEOperationCenterErrorCode)code description:(NSString *)description;

- (BOOL)eee_errorIsOperationCancelled;

@end