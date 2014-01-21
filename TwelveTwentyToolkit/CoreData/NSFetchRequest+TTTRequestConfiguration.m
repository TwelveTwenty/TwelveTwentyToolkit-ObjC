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


#import <CoreData/CoreData.h>
#import "NSFetchRequest+TTTRequestConfiguration.h"

@implementation NSFetchRequest (TTTRequestConfiguration)

- (void)ttt_setPredicateWithMatchingValues:(NSArray *)values forKeys:(NSArray *)keys
{
    if (values && keys)
    {
        NSString *singleFormat = @"%@ == %%@";
        NSMutableArray *combinedFormat = [NSMutableArray arrayWithCapacity:[values count]];
        [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [combinedFormat addObject:[NSString stringWithFormat:singleFormat, obj, nil]];
        }];
        NSString *joinedFormat = [combinedFormat componentsJoinedByString:@" AND "];
        self.predicate = [NSPredicate predicateWithFormat:joinedFormat argumentArray:values];
    }
}

- (void)ttt_sortResultsByKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    if (sortKey != nil)
    {
        [self ttt_sortResultsByKeysAscending:@{sortKey : @(ascending)}];
    }
}

- (void)ttt_sortResultsByKeysAscending:(id)sortingKeysWithAscendingFlag
{
    if (sortingKeysWithAscendingFlag)
    {
        NSArray *arrayOfSortingKeysWithAscendingFlag = sortingKeysWithAscendingFlag;
        if (![arrayOfSortingKeysWithAscendingFlag isKindOfClass:[NSArray class]])
        {
            arrayOfSortingKeysWithAscendingFlag = @[sortingKeysWithAscendingFlag];
        }

        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [arrayOfSortingKeysWithAscendingFlag enumerateObjectsUsingBlock:^(NSDictionary *ascendingFlagBySortingKey, NSUInteger idx, BOOL *stop) {
            NSAssert([ascendingFlagBySortingKey isKindOfClass:[NSDictionary class]], @"Only supports one level of nested dictionaries. Not %@", ascendingFlagBySortingKey);
            [ascendingFlagBySortingKey enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *ascending, BOOL *stop) {
                [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[ascending boolValue]]];
            }];
        }];

        self.sortDescriptors = sortDescriptors;
    }
}

@end