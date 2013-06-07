#import "TTTTimestamped.h"
#import "TTTAbstractManagedObject.h"
#import "TTTTimestamped.h"
#import "NSManagedObject+TTTUniquing.h"
#import "NSManagedObjectContext+TTTBatchManipulation.h"

const struct TTTIdentifiableAttributes TTTIdentifiableAttributes = {
        .identifier = @"identifier",
};

const struct TTTSyncStatusAttributes TTTSyncStatusAttributes = {
        .syncStatus = @"syncStatus",
};

const struct TTTSyncStatusValues TTTSyncStatusValues = {
        .synchronized = @"synchronized",
        .inserted = @"inserted",
        .updated = @"updated",
        .deleted = @"deleted",
};

@implementation TTTAbstractManagedObject

+ (id)uniqueEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSAssert([self conformsToProtocol:@protocol(TTTIdentifiable)], @"Class %@ must conform to protocol TTTIdentifiable to use this method.", self);
    return [self tttUniqueEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
}

+ (id)existingEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSAssert([self conformsToProtocol:@protocol(TTTIdentifiable)], @"Class %@ must conform to protocol TTTIdentifiable to use this method.", self);
    return [self tttExistingEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
}

+ (id)existingEntityWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    return [self tttExistingEntityWithValue:value forKey:key inContext:context];
}

+ (NSArray *)allEntitiesSortedByKey:(NSString *)sortKey ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    return [context tttAllEntitiesNamed:[self entityName] sortedByKey:sortKey ascending:ascending];
}

+ (NSArray *)allEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    return [context tttAllEntitiesNamed:[self entityName] withValues:@[value] forKeys:@[key]];
}

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context
{
    return [context tttAllEntitiesNamed:[self entityName] withValues:values forKeys:keys];
}

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    return [context tttAllEntitiesNamed:[self entityName] withValues:values forKeys:keys sortedByKey:sortKey ascending:ascending];
}

+ (TTTDeleteCount)deleteEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context tttDeleteEntitiesNamed:[self entityName] withValue:value forKey:key error:error];
}

+ (TTTDeleteCount)deleteEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context tttDeleteEntitiesNamed:[self entityName] withValues:values forKeys:keys error:error];
}

+ (TTTDeleteCount)deleteEntitiesWithNoRelationshipForKey:(NSString *)key inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context tttDeleteEntitiesNamed:[self entityName] withNoRelationshipForKey:key error:error];
}

+ (TTTDeleteCount)deleteAllEntitiesInContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context tttDeleteAllEntitiesNamed:[self entityName] error:error];
}

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(id)sortingKeysWithAscendingFlag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[(id) self entityName]];
    request.fetchBatchSize = 100;

    if (sortingKeysWithAscendingFlag)
    {
        NSArray *arrayOfSortingKeysWithAscendingFlag = sortingKeysWithAscendingFlag;
        if (![arrayOfSortingKeysWithAscendingFlag isKindOfClass:[NSArray class]])
        {
            arrayOfSortingKeysWithAscendingFlag = @[sortingKeysWithAscendingFlag];
        }

        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [arrayOfSortingKeysWithAscendingFlag enumerateObjectsUsingBlock:^(NSDictionary *sortingKeysWithAscendingFlag, NSUInteger idx, BOOL *stop) {
            NSAssert([sortingKeysWithAscendingFlag isKindOfClass:[NSDictionary class]], @"Only supports one level of nested dictionaries. Not %@", sortingKeysWithAscendingFlag);
            [sortingKeysWithAscendingFlag enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *ascending, BOOL *stop) {
                [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[ascending boolValue]]];
            }];
        }];

        request.sortDescriptors = sortDescriptors;
    }

    request.returnsObjectsAsFaults = NO;
    request.includesPendingChanges = YES;

    return request;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
{
    return [self fetchedResultsControllerWithSortingKeys:sortingKeysWithAscendingFlag
                                    managedObjectContext:context
                                      sectionNameKeyPath:nil];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    return [self fetchedResultsControllerWithSortingKeys:sortingKeysWithAscendingFlag
                                    managedObjectContext:context
                                      sectionNameKeyPath:sectionNameKeyPath
                                               cacheName:[@(rand()) stringValue]];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName
{
    NSFetchRequest *request = [self fetchRequestWithSortingKeys:sortingKeysWithAscendingFlag];

    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:cacheName];

    return controller;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSAssert(NO, @"This method should be overridden by a mogenerator generated entity class.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString *)entityName
{
    NSAssert(NO, @"This method should be overridden by a mogenerator generated entity class.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];

    if ([self conformsToProtocol:@protocol(TTTTimestamped)])
    {
        NSDate *now = [NSDate date];
        [self setValue:now forKey:TTTTimestampedAttributes.createdAt];
        [self setValue:now forKey:TTTTimestampedAttributes.updatedAt];
    }
}

@end