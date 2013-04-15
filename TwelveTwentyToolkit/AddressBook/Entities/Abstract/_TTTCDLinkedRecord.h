// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TTTCDLinkedRecord.h instead.

#import <CoreData/CoreData.h>


extern const struct TTCDLinkedRecordAttributes {
	__unsafe_unretained NSString *recordID;
} TTCDLinkedRecordAttributes;

extern const struct TTCDLinkedRecordRelationships {
	__unsafe_unretained NSString *unifiedRecord;
} TTCDLinkedRecordRelationships;

extern const struct TTCDLinkedRecordFetchedProperties {
} TTCDLinkedRecordFetchedProperties;

@class TTTCDUnifiedRecord;



@interface TTCDLinkedRecordID : NSManagedObjectID {}
@end

@interface _TTTCDLinkedRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TTCDLinkedRecordID*)objectID;




@property (nonatomic, strong) NSNumber* recordID;


@property int32_t recordIDValue;
- (int32_t)recordIDValue;
- (void)setRecordIDValue:(int32_t)value_;

//- (BOOL)validateRecordID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TTTCDUnifiedRecord * unifiedRecord;

//- (BOOL)validateUnifiedRecord:(id*)value_ error:(NSError**)error_;





@end

@interface _TTTCDLinkedRecord (CoreDataGeneratedAccessors)

@end

@interface _TTTCDLinkedRecord (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveRecordID;
- (void)setPrimitiveRecordID:(NSNumber*)value;

- (int32_t)primitiveRecordIDValue;
- (void)setPrimitiveRecordIDValue:(int32_t)value_;





- (TTTCDUnifiedRecord *)primitiveUnifiedRecord;
- (void)setPrimitiveUnifiedRecord:(TTTCDUnifiedRecord *)value;


@end
