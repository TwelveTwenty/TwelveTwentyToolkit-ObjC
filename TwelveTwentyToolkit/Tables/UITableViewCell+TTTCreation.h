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
// THE SOFTWARE.#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 To take care of the everlasting dequeue or create problem when retrieving cells in a UITableView,
 this category provides some convenience methods on any UITableViewCell+TTTCreation.
 */
@interface UITableViewCell (TTTCreation)

/**
 This is the mother of the other category methods.

 @param tableView provide the table view to dequeue a cell from
 @param style provide the style to use when creating new cells
 @param feedback pointer for later reference. This value will receive YES when the cell was newly created, and NO when it was dequeued.
 @param reuseIdentifier used for dequeueing the cells.
 */
+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created reuseIdentifier:(NSString *)reuseIdentifier;

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created;

+ (id)createOrDequeueFromTable:(UITableView *)tableView withReuseIdentifier:(NSString *)reuseIdentifier;

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style;

+ (id)createOrDequeueFromTable:(UITableView *)tableView withFeedback:(BOOL *)created;

+ (id)createOrDequeueFromTable:(UITableView *)tableView;

@end
