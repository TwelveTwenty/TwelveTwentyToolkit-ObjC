#import <Foundation/Foundation.h>

#define TTT_OPERATION_CENTER_ERROR_DOMAIN @"TTT_OPERATION_CENTER_ERROR_DOMAIN"

typedef enum
{
    TTTOperationCenterErrorCodeUnknown = 0,
    TTTOperationCenterErrorCodeCancelled = 20,
} TTTOperationCenterErrorCode;

@interface NSError (TTTOperationCenter)

+ (NSError *)ttt_operationCenterErrorWithCode:(TTTOperationCenterErrorCode)code description:(NSString *)description;

- (BOOL)ttt_errorIsOperationCancelled;

@end