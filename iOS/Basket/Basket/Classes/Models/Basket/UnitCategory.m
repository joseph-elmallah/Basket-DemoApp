//
//  UnitCategory.m
//  Basket
//
//  Created by Joseph Mallah on 02.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "UnitCategory.h"

static NSString * const UnitCategoryLocalizedUnitDisplayTitleCodingKey = @"UnitCategoryLocalizedUnitDisplayTitleCodingKey";
static NSString * const UnitCategoryDivisibleCodingKey = @"UnitCategoryDivisibleCodingKey";

@implementation UnitCategory

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.divisible = false;
		self.localizedUnitDisplayTitle = @"Unlocalized String";
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	if (self) {
		self.divisible = [coder decodeBoolForKey:UnitCategoryDivisibleCodingKey];
		self.localizedUnitDisplayTitle = [coder decodeObjectForKey:UnitCategoryLocalizedUnitDisplayTitleCodingKey];
	}
	return self;
}

-(instancetype) initWithJSONObject:(NSDictionary *)jsonObject {
	self = [super init];
	if (self) {
		NSNumber * divisibleRaw = [jsonObject objectForKey:@"divisible"];
		NSAssert(divisibleRaw != nil, @"The divisible key is missing from the JSON Object");
		self.divisible = [divisibleRaw boolValue];
		
		self.localizedUnitDisplayTitle = [jsonObject objectForKey:@"title"];
		NSAssert(self.localizedUnitDisplayTitle != nil, @"The title key is missing from the JSON Object");
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:self.divisible forKey:UnitCategoryDivisibleCodingKey];
	[aCoder encodeObject:self.localizedUnitDisplayTitle forKey:UnitCategoryLocalizedUnitDisplayTitleCodingKey];
}

-(id)copyWithZone:(NSZone *)zone {
	UnitCategory * copy = [[UnitCategory alloc] init];
	
	if (copy) {
		copy.divisible = self.divisible;
		copy.localizedUnitDisplayTitle = [self.localizedUnitDisplayTitle copyWithZone:zone];
	}
	
	return copy;
}

-(BOOL)isEqualToUnitCategory:(UnitCategory *)object {
	if (object == nil) {
		return NO;
	}
	
	BOOL haveEqualDivisibility = self.divisible == object.divisible;
	BOOL haveEqualName = [self.localizedUnitDisplayTitle isEqualToString:object.localizedUnitDisplayTitle];
	return haveEqualName && haveEqualDivisibility;
}

+(id) predefinedModel {
	static NSMutableDictionary * _predefinedModel = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL * resourceURL = [[NSBundle mainBundle] URLForResource:@"unitCategoryDefaults" withExtension:@"json"];
		NSAssert(resourceURL != nil, @"Could not find the predefined json file");
		NSData * fileData = [NSData dataWithContentsOfURL:resourceURL];
		NSAssert(fileData != nil, @"Could not read predefined json file");
		NSAssert(fileData.length > 0, @"JSON File is empty");
		NSError * jsonParsingError = nil;
		NSDictionary * jsonRoot = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:&jsonParsingError];
		NSAssert(jsonParsingError == nil, @"Error parsing the file: %@", jsonParsingError.localizedDescription);
		NSAssert([jsonRoot isKindOfClass:[NSDictionary class]], @"Root JSON object is not an object");
		
		NSMutableDictionary * predefinedModel = [NSMutableDictionary new];
		for (NSString * key in jsonRoot) {
			NSDictionary * unitCategoryJSONObject = [jsonRoot objectForKey:key];
			UnitCategory * newObject = [[UnitCategory alloc] initWithJSONObject:unitCategoryJSONObject];
			NSAssert(newObject != nil, @"Could not create objects out of the JSON file");
			[predefinedModel setObject:newObject forKey:key];
		}
		_predefinedModel = predefinedModel;
	});
	return _predefinedModel;
}

@end





















