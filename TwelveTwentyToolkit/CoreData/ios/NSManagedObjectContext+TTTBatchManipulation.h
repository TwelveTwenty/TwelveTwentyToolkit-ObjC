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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NSInteger TTTDeleteCount;
enum TTTDeleteCount {TTTDeleteFailed = -1};

@interface NSManagedObjectContext (TTTBatchManipulation)

/**
 * Fetches all entities of a certain name with a simple sort option.
 */
- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending;

- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys;

- (NSArray *)ttt_allEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
                      sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending;

/**
 * Set one value on all entities of a certain entity.
 * returns YES if successful, NO if not, provides the Core Data error.
 */
- (BOOL)ttt_setValue:(id)value forKey:(NSString *)key onEntitiesWithName:(NSString *)entityName error:(NSError **)error;

/**
 * Delete all entities matching the value for key provided.
 * returns a count of 0 or higher records deleted, or
 */
- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withValue:(id)value forKey:(NSString *)key error:(NSError **)error;

- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
                                    error:(NSError **)error;

- (TTTDeleteCount)ttt_deleteEntitiesNamed:(NSString *)entityName withNoRelationshipForKey:(NSString *)key error:(NSError **)error;

- (TTTDeleteCount)ttt_deleteAllEntitiesNamed:(NSString *)entityName error:(NSError **)error;

@end