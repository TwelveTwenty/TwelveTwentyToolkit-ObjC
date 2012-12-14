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

#import "TTUnifiedCard.h"
#import "TwelveTwentyToolkit.h"

@interface TTUnifiedCard ()

@property(nonatomic) ABAddressBookRef addressBook;
@property(nonatomic) ABRecordRef person;
@property(nonatomic, readwrite) ABRecordID recordID;
@property(nonatomic) CFArrayRef linkedPeople;

@end

@implementation TTUnifiedCard

@synthesize addressBook = _addressBook;
@synthesize person = _person;

- (void)dealloc
{
	self.person = NULL;
	self.addressBook = NULL;

	CFReleaseIfNotNULL(_linkedPeople);
	_linkedPeople = NULL;
}

- (id)initWithRecordID:(ABRecordID)recordID position:(float)position
{
    self = [super init];
    if (self)
    {
        self.recordID = recordID;
		self.position = position;
    }

    return self;
}

- (void)setAddressBook:(ABAddressBookRef)addressBook
{
	CFRetainIfNotNULL(addressBook);
	CFReleaseIfNotNULL(_addressBook);
    _addressBook = addressBook;

	self.person = NULL;
}

- (void)setPerson:(ABRecordRef)person
{
	CFRetainIfNotNULL(person);
	CFReleaseIfNotNULL(_person);
	_person = person;
}

- (ABRecordRef)person
{
    NSAssert(self.addressBook, @"Use `setAddressBook:` to set a valid address book reference before calling this method.");

    if (!_person)
    {
        self.person = ABAddressBookGetPersonWithRecordID(self.addressBook, self.recordID);
    }

    return _person;
}

- (CFArrayRef)linkedPeople
{
    if (!_linkedPeople)
    {
        _linkedPeople = ABPersonCopyArrayOfAllLinkedPeople([self person]);
    }

    return _linkedPeople;
}

- (NSString *)compositeName
{
    NSAssert(self.addressBook, @"Use `setAddressBook:` to set a valid address book reference before calling this method.");

    return (__bridge_transfer NSString *) ABRecordCopyCompositeName(self.person);
}

- (NSString *)stringForProperty:(ABPropertyID)propertyID
{
    NSAssert(ABPersonGetTypeOfProperty(propertyID) == kABStringPropertyType, @"Property `%i` will not result in a NSString value", propertyID);
    return [self valueForProperty:propertyID];
}

- (NSNumber *)numberForProperty:(ABPropertyID)propertyID
{
    BOOL isInteger = ABPersonGetTypeOfProperty(propertyID) == kABIntegerPropertyType;
    BOOL isReal = ABPersonGetTypeOfProperty(propertyID) == kABRealPropertyType;

    NSAssert(isInteger || isReal, @"Property `%i` will not result in a NSNumber value", propertyID);
    return [self valueForProperty:propertyID];
}

- (NSDate *)dateForProperty:(ABPropertyID)propertyID
{
    NSAssert(ABPersonGetTypeOfProperty(propertyID) == kABDateTimePropertyType, @"Property `%i` will not result in a NSDate value", propertyID);
    return [self valueForProperty:propertyID];
}

- (NSArray *)arrayForProperty:(ABPropertyID)propertyID
{
    NSAssert(ABPersonGetTypeOfProperty(propertyID) & kABMultiValueMask, @"Property `%i` will not result in a NSArray value", propertyID);
    return [self valueForProperty:propertyID];
}

- (NSDictionary *)dictionaryForProperty:(ABPropertyID)propertyID
{
    NSAssert(ABPersonGetTypeOfProperty(propertyID) == kABDictionaryPropertyType, @"Property `%i` will not result in a NSDictionary value", propertyID);
    return [self valueForProperty:propertyID];
}

- (id)valueForProperty:(ABPropertyID)propertyID
{
    NSAssert(self.addressBook, @"Use `setAddressBook:` to set a valid address book reference before calling this method.");

    ABPropertyType propertyType = ABPersonGetTypeOfProperty(propertyID);

    if (propertyType & kABMultiValueMask)
    {
        NSMutableArray *valueList = [NSMutableArray array];
        CFArrayRef linkedPeople = self.linkedPeople;
        CFIndex linkedCount = CFArrayGetCount(linkedPeople);
        for (CFIndex l = 0; l < linkedCount; l++)
        {
            ABRecordRef linkedPerson = CFArrayGetValueAtIndex(linkedPeople, l);
            ABMultiValueRef multiValue = ABRecordCopyValue(linkedPerson, propertyID);
            if (multiValue)
            {
                CFIndex count = ABMultiValueGetCount(multiValue);
                if (count > 0)
                {
                    for (CFIndex i = 0; i < count; i++)
                    {
                        id bridgedValue = (__bridge_transfer id) ABMultiValueCopyValueAtIndex(multiValue, i);
                        [valueList addObject:[self preprocessABValue:bridgedValue ofPropertyType:propertyType]];
                    }
                }
                CFRelease(multiValue);
            }
        }

        return valueList;
    }
    else
    {
        CFArrayRef linkedPeople = self.linkedPeople;
        CFIndex linkedCount = CFArrayGetCount(linkedPeople);
        for (CFIndex l = 0; l < linkedCount; l++)
        {
            ABRecordRef linkedPerson = CFArrayGetValueAtIndex(linkedPeople, l);
            id bridgedValue = (__bridge_transfer id) ABRecordCopyValue(linkedPerson, propertyID);
            if (bridgedValue)
            {
                // As soon as a non-nil value is found in a linked card, the value is returned as *the* value of this property.
                return [self preprocessABValue:bridgedValue ofPropertyType:propertyType];
            }
        }

        return nil;
    }
}

- (id)preprocessABValue:(id)value ofPropertyType:(ABPropertyType)propertyType
{
    ABPropertyType singularPropertyType = propertyType - (propertyType & kABMultiValueMask);

    switch (singularPropertyType)
    {
        case kABStringPropertyType:
        case kABIntegerPropertyType:
        case kABRealPropertyType:
        case kABDateTimePropertyType:
            return value;
        case kABDictionaryPropertyType:
        {
            NSMutableDictionary *processedDict = [NSMutableDictionary dictionary];
            NSDictionary *bridgedDict = value;

            for (NSString *key in bridgedDict)
            {
                [processedDict setObject:[self preprocessABValue:[bridgedDict valueForKey:key]
                                                  ofPropertyType:kABStringPropertyType]
                                  forKey:key];
            }

            return processedDict;
        }
    }

    NSDictionary *userInfo = @{
    @"value":value
    };

    [[NSException exceptionWithName:@"TT_UNIFIED_ADDRESS_BOOK_EXCEPTION" reason:[NSString stringWithFormat:@"Could not preprocess value of property type `%i`", propertyType] userInfo:userInfo] raise];
    return nil;
}

- (void)print
{
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
    NSLog(@"kABPersonKindProperty: %@", [self numberForProperty:kABPersonKindProperty]);
    NSLog(@"kABPersonBirthdayProperty: %@", [self dateForProperty:kABPersonBirthdayProperty]);
    NSLog(@"kABPersonCreationDateProperty: %@", [self dateForProperty:kABPersonCreationDateProperty]);
    NSLog(@"kABPersonModificationDateProperty: %@", [self dateForProperty:kABPersonModificationDateProperty]);
    NSLog(@"kABPersonEmailProperty: %@", [self arrayForProperty:kABPersonEmailProperty]);
    NSLog(@"kABPersonAddressProperty: %@", [self arrayForProperty:kABPersonAddressProperty]);
    NSLog(@"kABPersonDateProperty: %@", [self arrayForProperty:kABPersonDateProperty]);
    NSLog(@"kABPersonPhoneProperty: %@", [self arrayForProperty:kABPersonPhoneProperty]);
    NSLog(@"kABPersonInstantMessageProperty: %@", [self arrayForProperty:kABPersonInstantMessageProperty]);
    NSLog(@"kABPersonURLProperty: %@", [self arrayForProperty:kABPersonURLProperty]);
    NSLog(@"kABPersonRelatedNamesProperty: %@", [self arrayForProperty:kABPersonRelatedNamesProperty]);
    NSLog(@"kABPersonSocialProfileProperty: %@", [self arrayForProperty:kABPersonSocialProfileProperty]);
}

@end