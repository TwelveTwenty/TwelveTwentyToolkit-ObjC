#import "TTTAbstractManagedObject.h"
#import "NSManagedObject+TTTUniquing.h"
#import "NSManagedObjectContext+TTTUniquing.h"
#import "NSFetchRequest+TTTRequestConfiguration.h"

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

#if TARGET_OS_IPHONE
+ (NSFetchRequest *)fetchRequestWithSortingKeys:(id)sortingKeysWithAscendingFlag
{
    NSFetchRequest *request = [self fetchRequest];

    [request ttt_sortResultsByKeysAscending:sortingKeysWithAscendingFlag];

    request.fetchBatchSize = 100;
    request.returnsObjectsAsFaults = NO;
    request.includesPendingChanges = YES;

    return request;
}

+ (NSFetchRequest *)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
}

+ (instancetype)uniqueEntityWithIdentifier:(id)identifier inContext:(NSManagedObjectContext *)context
{
    NSParameterAssert([self conformsToProtocol:@protocol(TTTIdentifiable)]);
    return [self ttt_uniqueEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
}

+ (instancetype)uniqueEntityWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    return [self ttt_uniqueEntityWithValue:value forKey:key inContext:context];
}

+ (instancetype)existingEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSParameterAssert([self conformsToProtocol:@protocol(TTTIdentifiable)]);
    return [self ttt_existingEntityWithValue:identifier forKey:TTTIdentifiableAttributes.identifier inContext:context];
}

+ (instancetype)existingEntityWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    return [self ttt_existingEntityWithValue:value forKey:key inContext:context];
}

+ (instancetype)existingEntityWithValues:(NSArray *)values forKeys:(NSArray *)keys
                               inContext:(NSManagedObjectContext *)context
{
    return [context ttt_existingEntityForName:[self entityName] withValues:values forKeys:keys];
}

+ (NSArray *)allEntitiesSortedByKey:(NSString *)sortKey ascending:(BOOL)ascending
                          inContext:(NSManagedObjectContext *)context
{
    return [context ttt_allEntitiesNamed:[self entityName] sortedByKey:sortKey ascending:ascending];
}

+ (NSArray *)allEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    return [context ttt_allEntitiesNamed:[self entityName] withValues:@[value] forKeys:@[key]];
}

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context
{
    return [context ttt_allEntitiesNamed:[self entityName] withValues:values forKeys:keys];
}

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys sortedByKey:(NSString *)sortKey
                         ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    return [context ttt_allEntitiesNamed:[self entityName] withValues:values forKeys:keys sortedByKey:sortKey ascending:ascending];
}

+ (TTTDeleteCount)deleteEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context
                                    error:(NSError **)error
{
    return [context ttt_deleteEntitiesNamed:[self entityName] withValue:value forKey:key error:error];
}

+ (TTTDeleteCount)deleteEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys
                                 inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context ttt_deleteEntitiesNamed:[self entityName] withValues:values forKeys:keys error:error];
}

+ (TTTDeleteCount)deleteEntitiesWithNoRelationshipForKey:(NSString *)key inContext:(NSManagedObjectContext *)context
                                                   error:(NSError **)error
{
    return [context ttt_deleteEntitiesNamed:[self entityName] withNoRelationshipForKey:key error:error];
}

+ (TTTDeleteCount)deleteAllEntitiesInContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [context ttt_deleteAllEntitiesNamed:[self entityName] error:error];
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

#endif

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

    if ([self conformsToProtocol:@protocol(TTTTimestampedLocally)])
    {
        NSDate *now = [NSDate date];
        [self setValue:now forKey:TTTTimestampedAttributes.createdAt];
        [self setValue:now forKey:TTTTimestampedAttributes.updatedAt];
    }
}

@end