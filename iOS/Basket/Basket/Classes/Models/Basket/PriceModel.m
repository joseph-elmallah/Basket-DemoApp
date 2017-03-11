//
//  PriceModel.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "PriceModel.h"

static NSString * const PriceModelAmountCodingKey = @"PriceModelAmountCodingKey";
static NSString * const PriceModelUnitCategoryCodingKey = @"PriceModelUnitCategoryCodingKey";


@implementation PriceModel

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.unitCategory = [[UnitCategory alloc] init];
		self.amount = 0;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	if (self) {
		self.amount = [coder decodeDoubleForKey:PriceModelAmountCodingKey];
		self.unitCategory = [coder decodeObjectForKey:PriceModelUnitCategoryCodingKey];
	}
	return self;
}

-(instancetype) initWithJSONObject:(NSDictionary *)jsonObject {
	self = [super init];
	if (self) {
		NSNumber * amountRaw = [jsonObject objectForKey:@"amount"];
		NSAssert(amountRaw != nil, @"JSON Object missing key");
		self.amount = [amountRaw doubleValue];
		
		NSString * unitKey = [jsonObject objectForKey:@"unitKey"];
		NSAssert(unitKey != nil, @"JSON Object missing key");
		UnitCategory * unitCategory = [(NSDictionary *) [UnitCategory predefinedModel] objectForKey:unitKey];
		NSAssert(unitCategory != nil, @"Cannot find predefined unit category key");
		self.unitCategory = unitCategory;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeDouble:self.amount forKey:PriceModelAmountCodingKey];
	[aCoder encodeObject:self.unitCategory forKey:PriceModelUnitCategoryCodingKey];
}

-(double)priceForQuantity:(float)quantity {
	NSAssert(quantity >= 0, @"The units passed is negative");
	
	if (self.unitCategory.divisible) {
		return self.amount * quantity;
	} else {
		NSInteger wholeUnits = (NSInteger) quantity;
		return self.amount * wholeUnits;
	}
}

-(id)copyWithZone:(NSZone *)zone {
	PriceModel * copy = [[PriceModel alloc] init];
	
	if (copy) {
		copy.amount = self.amount;
		copy.unitCategory = [self.unitCategory copyWithZone:zone];
	}
	
	return copy;
}


-(BOOL) isEqualToPriceModel: (PriceModel *) priceModel {
	if (priceModel == nil) {
		return  NO;
	}
	
	BOOL haveEqualUnitsCategory = [self.unitCategory isEqualToUnitCategory:priceModel.unitCategory];
	BOOL haveEqualAmount = self.amount == priceModel.amount;
	
	return haveEqualUnitsCategory && haveEqualAmount;
}

@end
