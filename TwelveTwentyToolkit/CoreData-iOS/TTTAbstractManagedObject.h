#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol TTTMogeneratorEntity

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName;

/**
* Defaults section name key path to nil and cache name to a randomized string.
*/
+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(id)sortingKeysWithAscendingFlag;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSString *)entityName;

@end

extern const struct TTTIdentifiableAttributes
{
    __unsafe_unretained NSString *identifier;
} TTTIdentifiableAttributes;

@protocol TTTIdentifiable <TTTMogeneratorEntity>

@property(nonatomic, strong) NSNumber *identifier;

@end

@interface TTTAbstractManagedObject : NSManagedObject <TTTMogeneratorEntity>

+ (id)uniqueEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath;
@end