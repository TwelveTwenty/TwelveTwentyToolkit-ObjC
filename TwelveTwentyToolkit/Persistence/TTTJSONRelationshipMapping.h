#import <Foundation/Foundation.h>
#import "TTTAbstractJSONMapping.h"

@class TTTJSONMapper;

@interface TTTJSONRelationshipMapping : TTTAbstractJSONMapping

@property (nonatomic) BOOL toMany;
@property (nonatomic, strong) TTTJSONMapper *mapper;

- (id)initWithJSONKey:(NSString *)JSONKey relationshipKey:(NSString *)relationshipKey toMany:(BOOL)toMany mapper:(TTTJSONMapper *)mapper;

- (id)initWithJSONKey:(NSString *)JSONKey toNestedMapper:(TTTJSONMapper *)mapper;

- (BOOL)isNestedMapper;

@end