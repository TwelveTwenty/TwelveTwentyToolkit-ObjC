// Copyright (c) 2012 Twelve Twenty (http://twelvetwenty.nl)
//
// Permission is hereby granted, free of charge, to any unifiedRecord obtaining a copy
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
#import <AddressBook/AddressBook.h>

#define TT_UNIFIED_ADDRESS_BOOK_REQUEST_UPDATE_NOTIFICATION @"TT_UNIFIED_ADDRESS_BOOK_REQUEST_UPDATE_NOTIFICATION"

@interface TTUnifiedAddressBook : NSObject

@property(nonatomic, readonly) ABAddressBookRef addressBook;

+ (void)accessAddressBookWithGranted:(void (^)(ABAddressBookRef))accessGrantedBlock denied:(void (^)(BOOL))accessDeniedBlock;
- (id)initWithAddressBook:(ABAddressBookRef)addressBook;
- (void)updateAddressBookWithCompletion:(void (^)())completion;

/**
Get an array of all cards in the address book.
@return an array of `TTUnifiedCard` instances.
*/
- (NSArray *)allCards;

/**
Synchronous search for cards matching a query.
@param query to search for, will be used by the `ABAddressBookCopyPeopleWithName` method.
@return an array of `TTUnifiedCard` instances.
*/
- (NSArray *)cardsMatchingQuery:(NSString *)query;

/**
Asynchronous search for cards matching a query.
@param query to search for, will be used by the `ABAddressBookCopyPeopleWithName` method.
@param resultsBlock is passed an array of `TTUnifiedCard` instances.
*/
- (void)cardsMatchingQuery:(NSString *)query withAsyncResults:(void (^)(NSArray *))resultsBlock;

@end