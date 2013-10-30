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

#import "NSManagedObjectContext+TTTConvenience.h"
#import "TTTLog.h"


@implementation NSManagedObjectContext (TTTConvenience)

- (NSError *)ttt_simpleSave
{
    NSError *error = nil;

    if ([self save:&error]) {
		DLog(@"Context saved.");
        return nil;
    }

	ELog(@"Error saving context due to %li: \"%@\" with user info: %@", (long)error.code, [error.userInfo objectForKey:NSLocalizedDescriptionKey], error.userInfo);
    return error;
}

- (void)ttt_printChanges
{
    if (![self hasChanges])
    {
		DLog(@"No changes on context %@", self);
        return;
    }

	DLog(@"Changes on context %@", self);
    NSArray *keys = [NSArray arrayWithObjects:@"updatedObjects", @"insertedObjects", @"deletedObjects", @"registeredObjects", nil];
    for (NSString *key in keys) {
        NSSet *objects = [self valueForKey:key];
        if (![objects count]) continue;

		DLog(@"%@:", [key uppercaseString]);
        for (NSManagedObject *object in [self updatedObjects]) {
            NSLog(@"\t%@: %@", [object class], [object changedValues]);
        }
    }
}

@end