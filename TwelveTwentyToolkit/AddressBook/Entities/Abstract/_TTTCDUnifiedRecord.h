// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TTTCDUnifiedRecord.h instead.

#import <CoreData/CoreData.h>


extern const struct TTCDUnifiedRecordAttributes {
	__unsafe_unretained NSString *position;
	__unsafe_unretained NSString *recordID;
	__unsafe_unretained NSString *sortFieldFirstName;
	__unsafe_unretained NSString *sortFieldLastName;
} TTCDUnifiedRecordAttributes;

extern const struct TTCDUnifiedRecordRelationships {
	__unsafe_unretained NSString *linkedRecord;
} TTCDUnifiedRecordRelationships;

extern const struct TTCDUnifiedRecordFetchedProperties {
} TTCDUnifiedRecordFetchedProperties;

@class TTTCDLinkedRecord;






@interface TTCDUnifiedRecordID : NSManagedObjectID {}
@end

@interface _TTTCDUnifiedRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TTCDUnifiedRecordID*)objectID;




@property (nonatomic, strong) NSNumber* position;


@property float positionValue;
- (float)positionValue;
- (void)setPositionValue:(float)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* recordID;


@property int32_t recordIDValue;
- (int32_t)recordIDValue;
- (void)setRecordIDValue:(int32_t)value_;

//- (BOOL)validateRecordID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* sortFieldFirstName;


//- (BOOL)validateSortFieldFirstName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* sortFieldLastName;


//- (BOOL)validateSortFieldLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* linkedRecord;

- (NSMutableSet*)linkedRecordSet;





@end

@interface _TTTCDUnifiedRecord (CoreDataGeneratedAccessors)

- (void)addLinkedRecord:(NSSet*)value_;
- (void)removeLinkedRecord:(NSSet*)value_;
- (void)addLinkedRecordObject:(TTTCDLinkedRecord *)value_;
- (void)removeLinkedRecordObject:(TTTCDLinkedRecord *)value_;

@end

@interface _TTTCDUnifiedRecord (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (float)primitivePositionValue;
- (void)setPrimitivePositionValue:(float)value_;




- (NSNumber*)primitiveRecordID;
- (void)setPrimitiveRecordID:(NSNumber*)value;

- (int32_t)primitiveRecordIDValue;
- (void)setPrimitiveRecordIDValue:(int32_t)value_;




- (NSString*)primitiveSortFieldFirstName;
- (void)setPrimitiveSortFieldFirstName:(NSString*)value;




- (NSString*)primitiveSortFieldLastName;
- (void)setPrimitiveSortFieldLastName:(NSString*)value;





- (NSMutableSet*)primitiveLinkedRecord;
- (void)setPrimitiveLinkedRecord:(NSMutableSet*)value;


@end
