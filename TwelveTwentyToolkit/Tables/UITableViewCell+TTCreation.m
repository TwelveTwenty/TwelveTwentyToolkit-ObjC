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

#import "UITableViewCell+TTCreation.h"


@implementation UITableViewCell (TTCreation)

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created reuseIdentifier:(NSString *)reuseIdentifier;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil)
    {
        if (created != NULL) *created = YES;
        cell = [[self alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
    } else {
        if (created != NULL) *created = NO;
    }

    return cell;
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style feedback:(BOOL *)created
{
    return [self createOrDequeueFromTable:tableView withStyle:style feedback:created reuseIdentifier:[self description]];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self createOrDequeueFromTable:tableView withStyle:UITableViewCellStyleDefault feedback:NULL reuseIdentifier:reuseIdentifier];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withStyle:(UITableViewCellStyle)style
{
    return [self createOrDequeueFromTable:tableView withStyle:style feedback:NULL];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView withFeedback:(BOOL *)created
{
    return [self createOrDequeueFromTable:tableView withStyle:UITableViewCellStyleDefault feedback:created];
}

+ (id)createOrDequeueFromTable:(UITableView *)tableView
{
    return [self createOrDequeueFromTable:tableView withStyle:UITableViewCellStyleDefault];
}

@end