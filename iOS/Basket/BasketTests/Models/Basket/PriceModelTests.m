//
//  PriceModelTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PriceModel.h"
#import "UnitCategory.h"

@interface PriceModelTests : XCTestCase {
	PriceModel * model;
}

@end

@implementation PriceModelTests

-(double) amount {
	return 20;
}

-(UnitCategory *) unitCategory {
	UnitCategory * category = [[UnitCategory alloc] init];
	[category setDivisible:NO];
	[category setLocalizedUnitDisplayTitle:@"Bottle"];
	return category;
}

- (void)setUp {
    [super setUp];
	model = [[PriceModel alloc] init];
	[model setAmount:[self amount]];
	[model setUnitCategory:[self unitCategory]];
	XCTAssertNotNil(model);
}

- (void)tearDown {
	model = nil;
    [super tearDown];
}

-(void) testPriceComputation {
	float quantity = 4;
	double expectedAmount = quantity * [self amount];
	double result = [model priceForQuantity:quantity];
	XCTAssertEqual(expectedAmount, result);
}

- (void)testCopying {
	PriceModel * copyModel = [model copy];
	XCTAssertNotNil(copyModel);
	XCTAssertTrue([copyModel isEqualToPriceModel:model]);
}

- (void) testEncoding {
	NSData * encodedModel = [NSKeyedArchiver archivedDataWithRootObject:model];
	XCTAssertNotNil(encodedModel);
	XCTAssertTrue(encodedModel.length > 0);
	
	id decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedModel];
	XCTAssertNotNil(decodedObject);
	XCTAssertTrue([decodedObject isKindOfClass:[PriceModel class]]);
	PriceModel * decodedModel = (PriceModel *) decodedObject;
	XCTAssertTrue([decodedModel isEqualToPriceModel:model]);
}

@end














