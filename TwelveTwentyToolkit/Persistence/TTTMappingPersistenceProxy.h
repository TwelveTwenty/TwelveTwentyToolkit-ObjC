#import <Foundation/Foundation.h>
#import "TTTAbstractPersistenceProxy.h"
#import "TTTAbstractManagedObject.h"

@class TTTJSONMapper;

@interface TTTMappingPersistenceProxy : TTTAbstractPersistenceProxy

- (TTTJSONMapper *)mapperForEntityClass:(Class <TTTMogeneratorEntity>)entityClass;

- (TTTJSONMapper *)mapperForEntityClass:(Class <TTTMogeneratorEntity>)entityClass withIdentifier:(NSString *)mappingIdentifier;

- (id)processJSON:(id)JSON forEntitiesOfClass:(Class <TTTMogeneratorEntity>)entityClass inContext:(NSManagedObjectContext *)context autoSave:(BOOL)autoSave;

- (id)processJSON:(id)JSON forEntitiesOfClass:(Class <TTTMogeneratorEntity>)entityClass withIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context autoSave:(BOOL)autoSave;

@end