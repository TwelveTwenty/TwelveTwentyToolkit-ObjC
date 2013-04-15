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
#import <AddressBook/AddressBook.h>


@interface TTTUnifiedCard : NSObject

@property(nonatomic, readonly) ABRecordID recordID;
@property(nonatomic) float position;
- (id)initWithRecordID:(ABRecordID)recordID position:(float)position;

/**
* Call this method to set a suitable ABAddressBookRef for the current thread before calling any of the other methds.
*/
- (void)setAddressBook:(ABAddressBookRef)addressBook;

- (NSString *)compositeName;

/**
NSLog(@"kABPersonFirstNameProperty: %@", [self stringForProperty:kABPersonFirstNameProperty]);
NSLog(@"kABPersonLastNameProperty: %@", [self stringForProperty:kABPersonLastNameProperty]);
NSLog(@"kABPersonMiddleNameProperty: %@", [self stringForProperty:kABPersonMiddleNameProperty]);
NSLog(@"kABPersonPrefixProperty: %@", [self stringForProperty:kABPersonPrefixProperty]);
NSLog(@"kABPersonSuffixProperty: %@", [self stringForProperty:kABPersonSuffixProperty]);
NSLog(@"kABPersonNicknameProperty: %@", [self stringForProperty:kABPersonNicknameProperty]);
NSLog(@"kABPersonFirstNamePhoneticProperty: %@", [self stringForProperty:kABPersonFirstNamePhoneticProperty]);
NSLog(@"kABPersonLastNamePhoneticProperty: %@", [self stringForProperty:kABPersonLastNamePhoneticProperty]);
NSLog(@"kABPersonMiddleNamePhoneticProperty: %@", [self stringForProperty:kABPersonMiddleNamePhoneticProperty]);
NSLog(@"kABPersonOrganizationProperty: %@", [self stringForProperty:kABPersonOrganizationProperty]);
NSLog(@"kABPersonJobTitleProperty: %@", [self stringForProperty:kABPersonJobTitleProperty]);
NSLog(@"kABPersonDepartmentProperty: %@", [self stringForProperty:kABPersonDepartmentProperty]);
NSLog(@"kABPersonNoteProperty: %@", [self stringForProperty:kABPersonNoteProperty]);
*/
- (NSString *)stringForProperty:(ABPropertyID)propertyID;

/**
NSLog(@"kABPersonKindProperty: %@", [self numberForProperty:kABPersonKindProperty]);
*/
- (NSNumber *)numberForProperty:(ABPropertyID)propertyID;

/**
NSLog(@"kABPersonBirthdayProperty: %@", [self dateForProperty:kABPersonBirthdayProperty]);
NSLog(@"kABPersonCreationDateProperty: %@", [self dateForProperty:kABPersonCreationDateProperty]);
NSLog(@"kABPersonModificationDateProperty: %@", [self dateForProperty:kABPersonModificationDateProperty]);
*/
- (NSDate *)dateForProperty:(ABPropertyID)propertyID;

/**
NSLog(@"kABPersonEmailProperty: %@", [self arrayForProperty:kABPersonEmailProperty]);
NSLog(@"kABPersonAddressProperty: %@", [self arrayForProperty:kABPersonAddressProperty]);
NSLog(@"kABPersonDateProperty: %@", [self arrayForProperty:kABPersonDateProperty]);
NSLog(@"kABPersonPhoneProperty: %@", [self arrayForProperty:kABPersonPhoneProperty]);
NSLog(@"kABPersonInstantMessageProperty: %@", [self arrayForProperty:kABPersonInstantMessageProperty]);
NSLog(@"kABPersonURLProperty: %@", [self arrayForProperty:kABPersonURLProperty]);
NSLog(@"kABPersonRelatedNamesProperty: %@", [self arrayForProperty:kABPersonRelatedNamesProperty]);
NSLog(@"kABPersonSocialProfileProperty: %@", [self arrayForProperty:kABPersonSocialProfileProperty]);
*/
- (NSArray *)arrayForProperty:(ABPropertyID)propertyID;

- (NSDictionary *)dictionaryForProperty:(ABPropertyID)propertyID;

- (id)valueForProperty:(ABPropertyID)propertyID;

- (void)print;

@end