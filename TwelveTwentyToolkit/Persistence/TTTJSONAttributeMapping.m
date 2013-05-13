#import "TTTJSONAttributeMapping.h"

//NSString *const TTTDateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
NSString *const TTTDateFormat = @"MM/dd/yyyy HH:mm:ss";

@implementation NSDate (TTTJSONAttributeMapping)

+ (NSDate *)dateFromAPIString:(NSString *)dateString
{
    // Expects date in this format "/Date(1268123281843)/"
    NSUInteger startPos = [dateString rangeOfString:@"("].location+1;
    NSUInteger endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    long long int milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];

    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = TTTDateFormat;
    //    return [formatter dateFromString:dateString];
}

- (NSString *)APIString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = TTTDateFormat;
    return [formatter stringFromDate:self];
}

@end

@implementation TTTJSONAttributeMapping

+ (id)convertValue:(id)value forObjectType:(TTTJSONMappingType)objectType
{
    if ([NSNull null] == value)
    {
        return nil;
    }

	switch (objectType)
	{
		default:
			NSAssert(NO, @"Object mapping type unknown %i", objectType);

		case TTTJSONMappingTypeString:
			return value;

        case TTTJSONMappingTypeBool:
            return @([value boolValue]);
            
        case TTTJSONMappingTypeInteger16:
            return @([value intValue]);

        case TTTJSONMappingTypeInteger:
            return @([value integerValue]);
            
        case TTTJSONMappingTypeInteger64:
            return @(strtoll([[value description] UTF8String], NULL, 0));

        case TTTJSONMappingTypeDouble:
            return @([value doubleValue]);

        case TTTJSONMappingTypeFloat:
            return @([value floatValue]);

        case TTTJSONMappingTypeData:
            return [NSKeyedArchiver archivedDataWithRootObject:value];
            
		case TTTJSONMappingTypeDate:
		{
            return [NSDate dateFromAPIString:value];
		}
	}
}

- (id)initWithJSONKey:(NSString *)JSONKey attributeKey:(NSString *)attributeKey type:(TTTJSONMappingType)mappingType isIdentifier:(BOOL)isIdentifier
{
	self = [super init];

	if (self)
	{
		self.JSONKey = JSONKey;
		self.entityKey = attributeKey;
		self.objectType = mappingType;
		self.isIdentifier = isIdentifier;
	}

	return self;
}

- (BOOL)isSimpleUnique
{
    return self.JSONKey == nil;
}

@end