#import <Foundation/Foundation.h>
#import "TTTAbstractJSONMapping.h"

typedef enum {
    TTTJSONMappingTypeUnknown,
    TTTJSONMappingTypeBool,
    TTTJSONMappingTypeString,
    TTTJSONMappingTypeInteger16,
    TTTJSONMappingTypeInteger,
    TTTJSONMappingTypeInteger64,
    TTTJSONMappingTypeDouble,
    TTTJSONMappingTypeFloat,
    TTTJSONMappingTypeDate,
    TTTJSONMappingTypeData
} TTTJSONMappingType;

@interface NSDate (TTTJSONAttributeMapping)

+ (NSDate *)dateFromAPIString:(NSString *)dateString;

- (NSString *)APIString;

@end

@interface TTTJSONAttributeMapping : TTTAbstractJSONMapping

@property (nonatomic) TTTJSONMappingType objectType;
@property (nonatomic) BOOL isIdentifier;

+ (id)convertValue:(id)value forObjectType:(TTTJSONMappingType)objectType;

- (id)initWithJSONKey:(NSString *)JSONKey attributeKey:(NSString *)attributeKey type:(TTTJSONMappingType)mappingType isIdentifier:(BOOL)isIdentifier;

- (BOOL)isSimpleUnique;

@end