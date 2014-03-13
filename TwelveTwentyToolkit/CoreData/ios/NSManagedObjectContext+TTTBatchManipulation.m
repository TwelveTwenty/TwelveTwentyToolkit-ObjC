// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSManagedObjectContext+TTTBatchManipulation.h"
#import "NSFetchRequest+TTTRequestConfiguration.h"

@implementation NSManagedObjectContext (TTTBatchManipulation)

- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    return [self ttt_allEntitiesNamed:entityName withValues:nil forKeys:nil sortedByKey:sortKey ascending:ascending];
}

- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
{
    return [self ttt_allEntitiesNamed:entityName withValues:values forKeys:keys sortedByKey:nil ascending:YES];
}

- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
                      sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

    [request ttt_setPredicateWithMatchingValues:values forKeys:keys];
    [request ttt_sortResultsByKey:sortKey ascending:ascending];

    NSError *error = nil;
    NSArray *result = [self executeFetchRequest:request error:&error];

    if (result == nil)
    {
        NSLog(@"Failed to fetch entities named '%@' due to: %@", entityName, error);
    }

    return result;
}

- (BOOL)ttt_setValue:(id)value forKey:(NSString *)key onEntitiesWithName:(NSString *)entityName error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results) return NO;

    for (NSManagedObject *object in results)
    {
        [object setValue:value forKey:key];
    }

    return YES;
}

- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withValue:(id)value forKey:(NSString *)key error:(NSError **)error
{
    return [self ttt_deleteEntitiesNamed:entityName withValues:@[value] forKeys:@[key] error:error];
}

- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
                                    error:(NSError **)error
{
    NSString *joinedFormat;
    {
        NSString *singleFormat = @"%@ == %%@";
        NSMutableArray *combinedFormat = [NSMutableArray arrayWithCapacity:[values count]];
        [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [combinedFormat addObject:[NSString stringWithFormat:singleFormat, obj]];
        }];
        joinedFormat = [combinedFormat componentsJoinedByString:@" AND "];
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:joinedFormat argumentArray:values];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTTDeleteFailed;
    }

    NSUInteger count = [results count];
    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return count;
}

- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withNoRelationshipForKey:(NSString *)key error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSRelationshipDescription *relationshipDescription = entityDescription.relationshipsByName[key];
    if (relationshipDescription.isToMany)
    {
        request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == nil || %@.@count == 0", key, key]];
    }
    else
    {
        request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == nil", key]];
    }

    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTTDeleteFailed;
    }

    NSUInteger count = [results count];
    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return count;
}

- (TTTDeleteCount)ttt_deleteAllEntitiesNamed:(NSString *)entityName error:(NSError **)error
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [self executeFetchRequest:request error:error];
    if (!results)
    {
        return TTTDeleteFailed;
    }

    for (NSManagedObject *object in results)
    {
        [self deleteObject:object];
    }

    return [results count];
}

@end