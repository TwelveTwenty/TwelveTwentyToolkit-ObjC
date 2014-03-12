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

@interface NSManagedObjectContext (TTTUniquing)

/**
 finds or creates a unique NSManagedObject for the given key/value pair.
 */
- (id)ttt_uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key;

/**
 finds or creates a unique NSManagedObject for the given key/value pair and gives feedback on whether it existed or not
 */
- (id)ttt_uniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key existed:(BOOL *)existed;

- (id)ttt_uniqueEntityForName:(NSString *)name withValues:(NSArray *)values forKeys:(NSArray *)keys existed:(BOOL *)existed;

/**
 find one existing entity for the given key/value pair
 */
- (id)ttt_existingEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key;

- (id)ttt_existingEntityForName:(NSString *)entityName withValues:(NSArray *)values forKeys:(NSArray *)keys;

@end