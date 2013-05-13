#import <Foundation/Foundation.h>
#import "TTTAbstractJSONMapping.h"
#import "TTTJSONAttributeMapping.h"

typedef void (^TTTJSONProcessingBlock)(id JSON, id entity);

@class NSManagedObject;
@protocol TTTMogeneratorEntity;

@interface TTTJSONMapper : NSObject

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) TTTJSONProcessingBlock postProcessingBlock;

- (id)initWithEntityClass:(Class <TTTMogeneratorEntity>)entityClass;

- (id)applyJSON:(id)JSON toEntityInContext:(NSManagedObjectContext *)context;

- (void)applyJSON:(NSDictionary *)JSON toEntity:(NSManagedObject *)entity;

- (void)mapJSONKey:(NSString *)JSONKey toAttributeKey:(NSString *)attributeKey;

- (void)mapJSONKey:(NSString *)JSONKey toAttributeKey:(NSString *)attributeKey isIdentifier:(BOOL)isIdentifier;

- (void)mapJSONKey:(NSString *)JSONKey toRelationshipKey:(NSString *)relationshipKey toMany:(BOOL)toMany withMapper:(TTTJSONMapper *)mapper;

- (void)mapJSONKey:(NSString *)JSONKey toNestedMapper:(TTTJSONMapper *)mapper;

- (void)mapJSONValueToSingleAttributeKey:(NSString *)attributeKey isIdentifier:(BOOL)isIdentifier;

@end