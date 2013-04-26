#import "TTTAbstractManagedObject.h"
#import "TTTTimestamped.h"

@implementation TTTAbstractManagedObject

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[(id) self entityName]];
    request.fetchBatchSize = 100;

    if (sortingKeysWithAscendingFlag)
    {
        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [sortingKeysWithAscendingFlag enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *ascending, BOOL *stop) {
            [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[ascending boolValue]]];
        }];

        request.sortDescriptors = sortDescriptors;
    }

    request.returnsObjectsAsFaults = NO;
    request.includesPendingChanges = YES;

    return request;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
{
    return [self fetchedResultsControllerWithSortingKeys:sortingKeysWithAscendingFlag
                                    managedObjectContext:context
                                      sectionNameKeyPath:nil
                                               cacheName:[@(rand()) stringValue]];
}
+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
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