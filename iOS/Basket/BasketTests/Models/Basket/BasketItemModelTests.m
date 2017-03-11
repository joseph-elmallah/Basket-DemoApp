//
//  BasketItemModelTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BasketItemModel.h"

@interface BasketItemModelTests : XCTestCase {
	BasketItemModel * model;
}

@end

@implementation BasketItemModelTests

- (void)setUp {
    [super setUp];
	model = [[BasketItemModel alloc] init];
	XCTAssertNotNil(model);
	
	ItemModel * itemModel = [[ItemModel alloc] init];
	[itemModel setName:@"Some"];
	[itemModel setImageName:@"turtle"];
	PriceModel * priceModel = [[PriceModel alloc] init];
	[priceModel setAmount:10];
	UnitCategory * unitCategory = [[UnitCategory alloc] init];
	[unitCategory setLocalizedUnitDisplayTitle:@"A thing"];
	[unitCategory setDivisible:YES];
	[priceModel setUnitCategory:unitCategory];
	[itemModel setPrice:priceModel];
	[model setItem:itemModel];
}

- (void)tearDown {
	model = nil;
    [super tearDown];
}

- (void)testTotalPrice {
	[model setQuantity:1];
	XCTAssertEqual([model totalPrice], 10);
	
	[model setQuantity:1.5];
	XCTAssertEqual([model totalPrice], 15);
	
	[model setQuantity:10];
	XCTAssertEqual([model totalPrice], 100);
}

- (void)testDisplayQuantity {
	[model setQuantity:5];
	XCTAssertEqual([model displayQuantity], 1);
	
	model.item.price.unitCategory.divisible = NO;
	XCTAssertEqual([model displayQuantity], 5);
}



@end
