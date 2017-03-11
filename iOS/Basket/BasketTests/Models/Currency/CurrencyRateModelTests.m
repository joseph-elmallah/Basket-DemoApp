//
//  CurrencyRateModelTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CurrencyRateModel.h"

@interface CurrencyRateModelTests : XCTestCase

@end

@implementation CurrencyRateModelTests

-(CurrencyRateModel *) createModel {
	CurrencyRateModel * model = [[CurrencyRateModel alloc] init];
	[model setISOCode:@"CHF"];
	[model setDisplayName:@"Swiss Franc"];
	return model;
}

- (void)testAmountAfterExchange {
	CurrencyRateModel * model = [self createModel];
	double rate = 2;
	double baseAmount = 20;
	double expectedAmount = baseAmount * rate;
	
	[model setExchangeRate:rate];
	double result = [model amountAfterExchange:baseAmount];
	XCTAssertEqual(result, expectedAmount);
}

-(void) testEqualitySuccess {
	CurrencyRateModel * model1 = [self createModel];
	CurrencyRateModel * model2 = [self createModel];
	XCTAssertTrue([model1 isEqualToCurrencyRateModel:model2]);
}


-(void) testNotEqual {
	CurrencyRateModel * model1 = [self createModel];
	CurrencyRateModel * model2 = [self createModel];
	[model1 setISOCode:@"XBS"];
	XCTAssertFalse([model1 isEqualToCurrencyRateModel:model2]);
}

@end












