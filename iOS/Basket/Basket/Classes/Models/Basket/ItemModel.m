//
//  ItemModel.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "ItemModel.h"

static NSString * const ItemModelNameCodingKey = @"ItemModelNameCodingKey";
static NSString * const ItemModelImageNameCodingKey = @"ItemModelImageNameCodingKey";
static NSString * const ItemModelPriceCodingKey = @"ItemModelPriceCodingKey";

@implementation ItemModel

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.name = @"No name";
		self.price = [PriceModel new];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	if (self) {
		self.name = [coder decodeObjectForKey:ItemModelNameCodingKey];
		self.imageName = [coder decodeObjectForKey:ItemModelImageNameCodingKey];
		self.price = [coder decodeObjectForKey:ItemModelPriceCodingKey];
	}
	return self;
}

-(instancetype) initWithJSONObject:(NSDictionary *)jsonObject {
	self = [super init];
	if (self) {
		self.name = [jsonObject objectForKey:@"name"];
		NSAssert(self.name != nil, @"JSON contains missing keys");
		self.imageName = [jsonObject objectForKey:@"imageName"];
		NSAssert(self.imageName != nil, @"JSON contains missing keys");
		NSDictionary * priceJSON = [jsonObject objectForKey:@"price"];
		NSAssert(priceJSON != nil, @"JSON contains missing keys");
		NSAssert([priceJSON isKindOfClass:[NSDictionary class]], @"JSON contains malformed objects");
		PriceModel * price = [[PriceModel alloc] initWithJSONObject:priceJSON];
		NSAssert(price != nil, @"Could not parse JSON into an object");
		self.price = price;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.name forKey:ItemModelNameCodingKey];
	[coder encodeObject:self.imageName forKey:ItemModelImageNameCodingKey];
	[coder encodeObject:self.price forKey:ItemModelPriceCodingKey];
}

-(BOOL) isEqualToItemModel: (ItemModel *) itemModel {
	if (itemModel == nil) {
		return  NO;
	}
	
	BOOL haveEqualNames = (!self.name && !itemModel.name) || [self.name isEqualToString:itemModel.name];
	BOOL haveEqualImageNames = (!self.imageName && !itemModel.imageName) || [self.imageName isEqualToString:itemModel.imageName];
	BOOL haveEqualPrice = (!self.price && !itemModel.price) || [self.price isEqualToPriceModel:itemModel.price];
	
	return haveEqualNames && haveEqualImageNames && haveEqualPrice;
}

+(id) predefinedModel {
	static NSArray * _predefinedModel = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL * resourceURL = [[NSBundle mainBundle] URLForResource:@"itemsDefaults" withExtension:@"json"];
		NSAssert(resourceURL != nil, @"Could not find the predefined json file");
		NSData * fileData = [NSData dataWithContentsOfURL:resourceURL];
		NSAssert(fileData != nil, @"Could not read predefined json file");
		NSAssert(fileData.length > 0, @"JSON File is empty");
		NSError * jsonParsingError = nil;
		NSDictionary * jsonRoot = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:&jsonParsingError];
		NSAssert(jsonParsingError == nil, @"Error parsing the file: %@", jsonParsingError.localizedDescription);
		NSAssert([jsonRoot isKindOfClass:[NSArray class]], @"Root JSON object is not an array");
		
		NSMutableArray * predefinedModel = [NSMutableArray new];
		for (NSDictionary * JSONObject in jsonRoot) {
			ItemModel * newObject = [[ItemModel alloc] initWithJSONObject:JSONObject];
			NSAssert(newObject != nil, @"Could not create objects out of the JSON file");
			[predefinedModel addObject:newObject];
		}
		_predefinedModel = [NSArray arrayWithArray:predefinedModel];
	});
	return _predefinedModel;
}

@end










