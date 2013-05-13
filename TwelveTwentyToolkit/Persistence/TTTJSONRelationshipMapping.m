#import "TTTJSONRelationshipMapping.h"
#import "TTTJSONMapper.h"

@interface TTTJSONRelationshipMapping ()
@end

@implementation TTTJSONRelationshipMapping

- (id)initWithJSONKey:(NSString *)JSONKey relationshipKey:(NSString *)relationshipKey toMany:(BOOL)toMany mapper:(TTTJSONMapper *)mapper
{
	self = [super init];

	if (self)
	{
		self.JSONKey = JSONKey;
		self.entityKey = relationshipKey;
		self.toMany = toMany;
		self.mapper = mapper;
	}

	return self;

}

- (id)initWithJSONKey:(NSString *)JSONKey toNestedMapper:(TTTJSONMapper *)mapper
{
    self = [self initWithJSONKey:JSONKey relationshipKey:nil toMany:NO mapper:mapper];
    return self;
}

- (BOOL)isNestedMapper
{
    return self.entityKey == nil;
}

@end