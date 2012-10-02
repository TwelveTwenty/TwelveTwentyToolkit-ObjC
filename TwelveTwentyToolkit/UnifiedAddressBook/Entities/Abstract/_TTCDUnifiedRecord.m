// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TTCDUnifiedRecord.m instead.

#import "_TTCDUnifiedRecord.h"

const struct TTCDUnifiedRecordAttributes TTCDUnifiedRecordAttributes = {
	.recordID = @"recordID",
	.sortFieldFirstName = @"sortFieldFirstName",
	.sortFieldLastName = @"sortFieldLastName",
};

const struct TTCDUnifiedRecordRelationships TTCDUnifiedRecordRelationships = {
	.linkedRecord = @"linkedRecord",
};

const struct TTCDUnifiedRecordFetchedProperties TTCDUnifiedRecordFetchedProperties = {
};

@implementation TTCDUnifiedRecordID
@end

@implementation _TTCDUnifiedRecord

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UnifiedRecord" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UnifiedRecord";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UnifiedRecord" inManagedObjectContext:moc_];
}

- (TTCDUnifiedRecordID*)objectID {
	return (TTCDUnifiedRecordID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"recordIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recordID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic recordID;



- (int32_t)recordIDValue {
	NSNumber *result = [self recordID];
	return [result intValue];
}

- (void)setRecordIDValue:(int32_t)value_ {
	[self setRecordID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRecordIDValue {
	NSNumber *result = [self primitiveRecordID];
	return [result intValue];
}

- (void)setPrimitiveRecordIDValue:(int32_t)value_ {
	[self setPrimitiveRecordID:[NSNumber numberWithInt:value_]];
}





@dynamic sortFieldFirstName;






@dynamic sortFieldLastName;






@dynamic linkedRecord;

	
- (NSMutableSet*)linkedRecordSet {
	[self willAccessValueForKey:@"linkedRecord"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"linkedRecord"];
  
	[self didAccessValueForKey:@"linkedRecord"];
	return result;
}
	






@end
