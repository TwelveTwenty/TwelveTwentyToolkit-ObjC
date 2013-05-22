#import "TTTLog.h"
#import "TTTAbstractManagedObject.h"
#import "TTTMappingPersistenceProxy.h"
#import "TTTTimestamped.h"
#import "TTTJSONMapper.h"

#define TTT_DEFAULT_MAPPING @"DefaultMapping"

@interface TTTMappingPersistenceProxy ()

@property(nonatomic, strong) NSMutableDictionary *mappersByEntityClass;

@end

@implementation TTTMappingPersistenceProxy

- (id)initWithStoreName:(NSString *)storeName nestContexts:(BOOL)nestContexts resetThreshold:(int)resetThreshold
{
    self = [super initWithStoreName:storeName nestContexts:nestContexts resetThreshold:resetThreshold];

    if (self)
    {
        self.mappersByEntityClass = [NSMutableDictionary dictionary];
    }

    return self;
}

- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [super newPrivateContext];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillSaveContextNotification:) name:NSManagedObjectContextWillSaveNotification object:context];

    return context;
}

- (NSManagedObjectContext *)mainContext
{
    BOOL addHandlers = (self->_mainContext == nil);
    if (!addHandlers) return [super mainContext];

    NSManagedObjectContext *mainContext = [super mainContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillSaveContextNotification:) name:NSManagedObjectContextWillSaveNotification object:mainContext];
    return mainContext;
}

- (void)handleWillSaveContextNotification:(NSNotification *)notification
{
    NSManagedObjectContext *context = notification.object;
    NSDate *now = [NSDate date];
    for (NSManagedObject <TTTTimestamped> *updatedObject in [context updatedObjects])
    {
        if ([updatedObject conformsToProtocol:@protocol(TTTTimestamped)])
        {
            updatedObject.updatedAt = now;
        }
    }
}

- (TTTJSONMapper *)mapperForEntityClass:(Class <TTTMogeneratorEntity>)entityClass
{
    return [self mapperForEntityClass:entityClass withIdentifier:TTT_DEFAULT_MAPPING];
}

- (TTTJSONMapper *)mapperForEntityClass:(Class <TTTMogeneratorEntity>)entityClass withIdentifier:(NSString *)mappingIdentifier
{
    return [self mapperForEntityClass:entityClass withIdentifier:mappingIdentifier autoCreate:YES];
}

- (TTTJSONMapper *)mapperForEntityClass:(Class <TTTMogeneratorEntity>)entityClass withIdentifier:(NSString *)mappingIdentifier autoCreate:(BOOL)autoCreate
{
    NSMutableDictionary *mappersByIdentifier = self.mappersByEntityClass[NSStringFromClass(entityClass)];
    if (!mappersByIdentifier)
    {
        if (!autoCreate) return nil;
        mappersByIdentifier = [NSMutableDictionary dictionary];
        self.mappersByEntityClass[NSStringFromClass(entityClass)] = mappersByIdentifier;
    }

    TTTJSONMapper *mapper = mappersByIdentifier[mappingIdentifier];
    if (mapper == nil)
    {
        if (!autoCreate) return nil;
        mapper = [[TTTJSONMapper alloc] initWithEntityClass:entityClass];
        mappersByIdentifier[mappingIdentifier] = mapper;
    }

    return mapper;
}

- (id)processJSON:(id)JSON forEntitiesOfClass:(Class <TTTMogeneratorEntity>)entityClass inContext:(NSManagedObjectContext *)context autoSave:(BOOL)autoSave
{
    return [self processJSON:JSON forEntitiesOfClass:entityClass withIdentifier:TTT_DEFAULT_MAPPING inContext:context autoSave:autoSave];
}

- (id)processJSON:(id)JSON forEntitiesOfClass:(Class <TTTMogeneratorEntity>)entityClass withIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context autoSave:(BOOL)autoSave
{
    if (!context)
    {
        context = [self newPrivateContext];
    }

    TTTJSONMapper *mapper = [self mapperForEntityClass:entityClass withIdentifier:identifier autoCreate:NO];

    if (!mapper)
    {
        NSAssert(mapper, @"No mapper found for entity class `%@` from proxy %@", entityClass, self);
    }

    id entityOrEntities = [mapper applyJSON:JSON toEntityInContext:context];

    if (autoSave)
    {
        [self savePrivateContext:context];
    }

    return entityOrEntities;
}

@end