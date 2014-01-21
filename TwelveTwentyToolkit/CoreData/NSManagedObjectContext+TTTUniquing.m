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

#import "NSString+TTTEmptiness.h"
#import "NSManagedObjectContext+TTTUniquing.h"

@implementation NSManagedObjectContext (TTTUniquing)

- (id)ttt_uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    BOOL existed = NO;
    NSManagedObject *result = [self ttt_uniqueEntityForName:name withValue:value forKey:key existed:&existed];
    return result;
}

- (id)ttt_uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key existed:(BOOL *)existed
{
    return [self ttt_uniqueEntityForName:name withValues:@[value] forKeys:@[key] existed:existed];
}

- (id)ttt_uniqueEntityForName:(NSString *)name withValues:(NSArray *)values forKeys:(NSArray *)keys
                      existed:(BOOL *)existed
{
    NSManagedObject *entity = [self ttt_existingEntityForName:name withValues:values forKeys:keys];

    if (entity == nil)
    {
        entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
        [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            [entity setValue:values[idx] forKey:key];
        }];

        if (existed) *existed = NO;
    }
    else if (existed) *existed = YES;

    return entity;
}

- (id)ttt_existingEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    if ([NSString ttt_isEmpty:name] || !value || !key) return nil;
    return [self ttt_existingEntityForName:name withValues:@[value] forKeys:@[key]];
}

- (id)ttt_existingEntityForName:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys
{
    NSAssert([values count] == [keys count], @"Values and keys count don't match.");
    if (![values count]) return nil;

    NSString *joinedFormat;
    {
        NSString *singleFormat = @"%@ == %%@";
        NSMutableArray *combinedFormat = [NSMutableArray arrayWithCapacity:[values count]];
        [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [combinedFormat addObject:[NSString stringWithFormat:singleFormat, obj, nil]];
        }];
        joinedFormat = [combinedFormat componentsJoinedByString:@" AND "];
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.fetchLimit = 1;

    request.predicate = [NSPredicate predicateWithFormat:joinedFormat argumentArray:values];
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];

    return [results lastObject];
}

@end
