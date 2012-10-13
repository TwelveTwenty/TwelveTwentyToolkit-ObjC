// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TTCDUnifiedRecord.h instead.

#import <CoreData/CoreData.h>


extern const struct TTCDUnifiedRecordAttributes {
	__unsafe_unretained NSString *recordID;
	__unsafe_unretained NSString *sortFieldFirstName;
	__unsafe_unretained NSString *sortFieldLastName;
} TTCDUnifiedRecordAttributes;

extern const struct TTCDUnifiedRecordRelationships {
	__unsafe_unretained NSString *linkedRecord;
} TTCDUnifiedRecordRelationships;

extern const struct TTCDUnifiedRecordFetchedProperties {
} TTCDUnifiedRecordFetchedProperties;

@class TTCDLinkedRecord;





@interface TTCDUnifiedRecordID : NSManagedObjectID {}
@end

@interface _TTCDUnifiedRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TTCDUnifiedRecordID*)objectID;




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

@interface _TTCDUnifiedRecord (CoreDataGeneratedAccessors)

- (void)addLinkedRecord:(NSSet*)value_;
- (void)removeLinkedRecord:(NSSet*)value_;
- (void)addLinkedRecordObject:(TTCDLinkedRecord*)value_;
- (void)removeLinkedRecordObject:(TTCDLinkedRecord*)value_;

@end

@interface _TTCDUnifiedRecord (CoreDataGeneratedPrimitiveAccessors)


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
