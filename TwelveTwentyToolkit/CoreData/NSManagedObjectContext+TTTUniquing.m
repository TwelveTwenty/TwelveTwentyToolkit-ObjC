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

#import "NSManagedObjectContext+TTTUniquing.h"

@implementation NSManagedObjectContext (TTTUniquing)

- (id)tttUniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    BOOL existed = NO;
    NSManagedObject* result = [self tttUniqueEntityForName:name withValue:value forKey:key existed:&existed];
    return result;
}

- (id)tttUniqueEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key existed:(BOOL *)existed
{
    NSManagedObject *entity = [self tttExistingEntityForName:name withValue:value forKey:key];
    
    if (entity == nil) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
        [entity setValue:value forKey:key];
        *existed = NO;
    } else {
        *existed = YES;
    }
    
    return entity;
}

- (id)tttExistingEntityForName:(NSString *)name withValue:(id)value forKey:(NSString *)key
{
    if (value == nil || [@"" isEqualToString:[value description]]) 
	{
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    request.predicate = [NSPredicate predicateWithFormat:[key stringByAppendingString:@" == %@"], value];
    request.fetchLimit = 1;
    NSArray *result = [self executeFetchRequest:request error:nil];
    
    return [result lastObject];
}

@end
