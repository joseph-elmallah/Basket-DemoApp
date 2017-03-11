//
//  CurrencyRateModel.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CurrencyRateModel.h"

static NSString * const CurrencyRateModelISOCodeKey = @"CurrencyRateModelISOCodeKey";
static NSString * const CurrencyRateModelDisplayNameKey = @"CurrencyRateModelDisplayNameKey";
static NSString * const CurrencyRateModelExchangeRateKey = @"CurrencyRateModelExchangeRateKey";
static NSString * const CurrencyRateModelRefreshDateKey = @"CurrencyRateModelRefreshDateKey";

@implementation CurrencyRateModel

-(void)setExchangeRate:(double)exchangeRate {
	_exchangeRate = exchangeRate;
	_refreshDate = [NSDate new];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	if (self) {
		self.ISOCode = [coder decodeObjectForKey:CurrencyRateModelISOCodeKey];
		self.displayName = [coder decodeObjectForKey:CurrencyRateModelDisplayNameKey];
		self.exchangeRate = [coder decodeDoubleForKey:CurrencyRateModelExchangeRateKey];
		_refreshDate = [coder decodeObjectForKey:CurrencyRateModelRefreshDateKey];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.ISOCode forKey:CurrencyRateModelISOCodeKey];
	[aCoder encodeObject:self.displayName forKey:CurrencyRateModelDisplayNameKey];
	[aCoder encodeDouble:self.exchangeRate forKey:CurrencyRateModelExchangeRateKey];
	[aCoder encodeObject:self.refreshDate forKey:CurrencyRateModelRefreshDateKey];
}

-(double)amountAfterExchange:(double)baseAmount {
	return self.exchangeRate * baseAmount;
}

-(NSString *)debugDescription {
	return [NSString stringWithFormat:@"Currency %@: %f", self.ISOCode, self.exchangeRate];
}

-(BOOL) isEqualToCurrencyRateModel:(CurrencyRateModel *)object {
	if (object == nil) {
		return NO;
	}
	
	BOOL equalISO = [self.ISOCode isEqualToString:object.ISOCode];
	return equalISO;
}

@end






