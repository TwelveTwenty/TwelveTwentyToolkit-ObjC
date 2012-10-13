// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TTCDLinkedRecord.h instead.

#import <CoreData/CoreData.h>


extern const struct TTCDLinkedRecordAttributes {
	__unsafe_unretained NSString *recordID;
} TTCDLinkedRecordAttributes;

extern const struct TTCDLinkedRecordRelationships {
	__unsafe_unretained NSString *unifiedRecord;
} TTCDLinkedRecordRelationships;

extern const struct TTCDLinkedRecordFetchedProperties {
} TTCDLinkedRecordFetchedProperties;

@class TTCDUnifiedRecord;



@interface TTCDLinkedRecordID : NSManagedObjectID {}
@end

@interface _TTCDLinkedRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TTCDLinkedRecordID*)objectID;




@property (nonatomic, strong) NSNumber* recordID;


@property int32_t recordIDValue;
- (int32_t)recordIDValue;
- (void)setRecordIDValue:(int32_t)value_;

//- (BOOL)validateRecordID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TTCDUnifiedRecord* unifiedRecord;

//- (BOOL)validateUnifiedRecord:(id*)value_ error:(NSError**)error_;





@end

@interface _TTCDLinkedRecord (CoreDataGeneratedAccessors)

@end

@interface _TTCDLinkedRecord (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveRecordID;
- (void)setPrimitiveRecordID:(NSNumber*)value;

- (int32_t)primitiveRecordIDValue;
- (void)setPrimitiveRecordIDValue:(int32_t)value_;





- (TTCDUnifiedRecord*)primitiveUnifiedRecord;
- (void)setPrimitiveUnifiedRecord:(TTCDUnifiedRecord*)value;


@end
