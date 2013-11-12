#import <objc/runtime.h>
#import "TTTAbstractManagedObject.h"
#import "TTTJSONMapper.h"
#import "NSManagedObjectContext+TTTUniquing.h"
#import "TTTLog.h"
#import "TTTJSONRelationshipMapping.h"
#import "NSObject+TTTBlocks.h"

@interface TTTJSONMapper ()

@property(nonatomic, strong) NSMutableArray *mappings;

@property(nonatomic, strong) Class <TTTMogeneratorEntity> entityClass;

@end

@implementation TTTJSONMapper

- (id)initWithEntityClass:(Class <TTTMogeneratorEntity>)entityClass
{
    self = [super init];

    if (self)
    {
        self.entityClass = entityClass;
        self.entityName = [entityClass entityName];
        self.mappings = [NSMutableArray array];
    }

    return self;
}

- (id)applyJSON:(id)JSON toEntityInContext:(NSManagedObjectContext *)context
{
    if ([JSON isKindOfClass:[NSArray class]])
    {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[JSON count]];
        [(NSArray *) JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result addObject:[self applyJSON:obj toEntityInContext:context]];
        }];
        return result;
    }
    else if (JSON && JSON != [NSNull null])
    {
        __block id nestedJSON = nil;
        __block TTTJSONMapper *nestedMapper = nil;
        __block NSManagedObject *entity = nil;
        NSAssert([self.mappings count] > 0, @"Trying to apply JSON to a `%@` entity without any mappers. %@", self.entityName, JSON);
        [self.mappings enumerateObjectsUsingBlock:^(TTTAbstractJSONMapping *mapping, NSUInteger idx, BOOL *stop) {
            if ([mapping isKindOfClass:[TTTJSONAttributeMapping class]])
            {
                TTTJSONAttributeMapping *attributeMapping = (TTTJSONAttributeMapping *)mapping;
                if (attributeMapping.isIdentifier)
                {
                    if ([attributeMapping isSimpleUnique])
                    {
                        entity = [context ttt_uniqueEntityForName:self.entityName withValue:JSON forKey:mapping.entityKey];
                        *stop = YES;
                    }
                    else
                    {
                        id identifierValue = [TTTJSONAttributeMapping convertValue:JSON[attributeMapping.JSONKey] forObjectType:attributeMapping.objectType];
                        entity = [context ttt_uniqueEntityForName:self.entityName withValue:identifierValue forKey:attributeMapping.entityKey];
                        *stop = YES;
                    }
                }
            }
            else if ([mapping isKindOfClass:[TTTJSONRelationshipMapping class]])
            {
                TTTJSONRelationshipMapping *relationshipMapping = (TTTJSONRelationshipMapping *)mapping;
                if (relationshipMapping.isNestedMapper)
                {
                    nestedJSON = JSON[relationshipMapping.JSONKey];
                    nestedMapper = relationshipMapping.mapper;
                    *stop = YES;
                }
            }
        }];

        if (nestedJSON && nestedMapper)
        {
            entity = [nestedMapper applyJSON:nestedJSON toEntityInContext:context];
            if (self.postProcessingBlock)
            {
                self.postProcessingBlock(JSON, entity);
            }
        }
        else
        {
            BOOL isDictionary = [JSON isKindOfClass:[NSDictionary class]];
            if (isDictionary)
            {
                if (!entity)
                {
                    // There's no unique property to create the entity for, so let's create a new one.
                    entity = [self.entityClass insertInManagedObjectContext:context];
                }
                
                [self applyJSON:JSON toEntity:entity];
            }
        }

        NSAssert(entity, @"Can't apply JSON to entity in context %@: %@", context, JSON);
        return entity;
    }

    return nil;
}

- (void)applyJSON:(NSDictionary *)JSON toEntity:(NSManagedObject *)entity
{
    [self.mappings enumerateObjectsUsingBlock:^(TTTAbstractJSONMapping *mapping, NSUInteger idx, BOOL *stop) {
        if ([mapping isKindOfClass:[TTTJSONAttributeMapping class]])
        {
            TTTJSONAttributeMapping *attributeMapping = (TTTJSONAttributeMapping *) mapping;
            [JSON ttt_forKey:attributeMapping.JSONKey performBlock:^(id value) {
                value = [TTTJSONAttributeMapping convertValue:value forObjectType:attributeMapping.objectType];
                [entity setValue:value forKey:attributeMapping.entityKey];
            }];
        }
        else if ([mapping isKindOfClass:[TTTJSONRelationshipMapping class]])
        {
            TTTJSONRelationshipMapping *relationshipMapping = (TTTJSONRelationshipMapping *) mapping;
            id subJSON = [JSON valueForKey:relationshipMapping.JSONKey];
            if (subJSON != nil)
            {
                if (relationshipMapping.isNestedMapper)
                {
                    [relationshipMapping.mapper applyJSON:subJSON toEntity:entity];
                }
                else
                {
                    id result = [relationshipMapping.mapper applyJSON:subJSON toEntityInContext:entity.managedObjectContext];
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        // This set can either be NSMutableSet or NSMutableOrderedSet - they unfortunately do not inherit from eachother.
                        id mutableSet = [entity valueForKey:relationshipMapping.entityKey];
                        [mutableSet removeAllObjects];

                        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [mutableSet addObject:obj];
                        }];

                        [entity setValue:mutableSet forKey:relationshipMapping.entityKey];
                    }
                    else if (relationshipMapping.toMany)
                    {
                        NSMutableSet *set = [entity valueForKey:relationshipMapping.entityKey];
                        [set addObject:result];
                    }
                    else
                    {
                        [entity setValue:result forKey:relationshipMapping.entityKey];
                    }
                }
            }
        }
    }];

    if (self.postProcessingBlock)
    {
        self.postProcessingBlock(JSON, entity);
    }

//    if ([entity conformsToProtocol:@protocol(TTTSynchronizable)])
//    {
//        [(id <TTTSynchronizable>) entity setSynchronizationStatus:@(TTTSynchronizationStatusSynchronized)];
//        [(id <TTTSynchronizable>) entity setSynchronizedAt:[NSDate date]];
//    }
}

#pragma mark - Mappings

- (void)mapJSONKey:(NSString *)JSONKey toAttributeKey:(NSString *)attributeKey
{
    [self mapJSONKey:JSONKey toAttributeKey:attributeKey isIdentifier:NO];
}

- (void)mapJSONKey:(NSString *)JSONKey toAttributeKey:(NSString *)attributeKey isIdentifier:(BOOL)isIdentifier
{
    TTTJSONMappingType objectType = [self introspectMappingTypeForAttributeKey:attributeKey];
    [self.mappings addObject:[[TTTJSONAttributeMapping alloc] initWithJSONKey:JSONKey attributeKey:attributeKey type:objectType isIdentifier:isIdentifier]];
}

- (void)mapJSONValueToSingleAttributeKey:(NSString *)attributeKey isIdentifier:(BOOL)isIdentifier
{
    TTTJSONMappingType objectType = [self introspectMappingTypeForAttributeKey:attributeKey];
    [self.mappings addObject:[[TTTJSONAttributeMapping alloc] initWithJSONKey:nil attributeKey:attributeKey type:objectType isIdentifier:isIdentifier]];
}

- (void)mapJSONKey:(NSString *)JSONKey toRelationshipKey:(NSString *)relationshipKey toMany:(BOOL)toMany withMapper:(TTTJSONMapper *)mapper
{
    [self.mappings addObject:[[TTTJSONRelationshipMapping alloc] initWithJSONKey:JSONKey relationshipKey:relationshipKey toMany:toMany mapper:mapper]];
}

- (void)mapJSONKey:(NSString *)JSONKey toNestedMapper:(TTTJSONMapper *)mapper
{
    [self.mappings addObject:[[TTTJSONRelationshipMapping alloc] initWithJSONKey:JSONKey toNestedMapper:mapper]];
}

#pragma mark - Introspection

- (TTTJSONMappingType)introspectMappingTypeForAttributeKey:(NSString *)attributeKey
{
    NSString *primitiveGetter = [NSString stringWithFormat:@"primitive%@Value", [attributeKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[attributeKey substringToIndex:1] uppercaseString]]];
    Method targetMethod = class_getInstanceMethod(self.entityClass, NSSelectorFromString(primitiveGetter));
    if (targetMethod)
    {
        char *charType = method_copyReturnType(targetMethod);
        NSString *stringType = [NSString stringWithFormat:@"%s", charType];

        if ([stringType isEqualToString:@"s"])
        {
            return TTTJSONMappingTypeInteger16;
        }
        else if ([stringType isEqualToString:@"i"])
        {
            return TTTJSONMappingTypeInteger;
        }
        else if ([stringType isEqualToString:@"d"])
        {
            return TTTJSONMappingTypeDouble;
        }
        else if ([stringType isEqualToString:@"f"])
        {
            return TTTJSONMappingTypeFloat;
        }
        else if ([stringType isEqualToString:@"q"])
        {
            return TTTJSONMappingTypeInteger64;
        }
        else if ([stringType isEqualToString:@"c"])
        {
            return TTTJSONMappingTypeBool;
        }
        else
        {
            NSAssert(NO, @"Unknown type: %@", stringType);
            return TTTJSONMappingTypeUnknown;
        }
    }
    else
    {
        objc_property_t prop = class_getProperty(self.entityClass, [attributeKey UTF8String]);
        if (prop == NULL)
        {
            DLog(@"Property %@ does not exist on %@", attributeKey, self.entityClass);
            assert(prop != NULL);
        }
        char const *stringAttributes = property_getAttributes(prop);
        NSString *attributes = [NSString stringWithUTF8String:stringAttributes];

        Class objectType = [NSObject class];
        NSArray *pairs = [attributes componentsSeparatedByString:@","];
        for (NSString *pair in pairs)
        {
            NSString *attribute = [pair substringToIndex:1];
            NSString *value = [pair substringFromIndex:1];

            if ([@"T" isEqualToString:attribute])
            {
                if ([@"@" isEqualToString:[value substringToIndex:1]])
                {
                    if ([value length] > 3)
                    {
                        NSString *objectDesignation = [value substringFromIndex:2];
                        objectDesignation = [objectDesignation substringToIndex:[objectDesignation length] - 1];

                        NSMutableArray *chunks = [[objectDesignation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] mutableCopy];
                        NSString *classDesignation = [chunks objectAtIndex:0];
                        [chunks removeObjectAtIndex:0];

                        objectType = [classDesignation length] ? NSClassFromString(classDesignation) : [NSObject class];
                    }
                }
            }
        }

        if ([objectType isEqual:[NSDate class]])
        {
            return TTTJSONMappingTypeDate;
        }
        else if ([objectType isEqual:[NSString class]])
        {
            return TTTJSONMappingTypeString;
        }
        else if ([objectType isEqual:[NSData class]])
        {
            return TTTJSONMappingTypeData;
        }
        else
        {
            NSAssert(NO, @"Unknown object type: %@", objectType);
            return TTTJSONMappingTypeUnknown;
        }
    }
}

@end