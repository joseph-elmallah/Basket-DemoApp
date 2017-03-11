//
//  BasketModelTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BasketModel.h"

@interface BasketModelTests : XCTestCase {
	BasketModel * model;
}

@end

@implementation BasketModelTests

-(ItemModel *) createItem1 {
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
	return itemModel;
}

-(ItemModel *) createItem2 {
	ItemModel * itemModel = [[ItemModel alloc] init];
	[itemModel setName:@"Somali"];
	[itemModel setImageName:@"rabbit"];
	PriceModel * priceModel = [[PriceModel alloc] init];
	[priceModel setAmount:5];
	UnitCategory * unitCategory = [[UnitCategory alloc] init];
	[unitCategory setLocalizedUnitDisplayTitle:@"Another thing"];
	[unitCategory setDivisible:NO];
	[priceModel setUnitCategory:unitCategory];
	[itemModel setPrice:priceModel];
	return itemModel;
}


- (void)setUp {
    [super setUp];
	model = [[BasketModel alloc] init];
}

- (void)tearDown {
	model = nil;
    [super tearDown];
}

-(void) testItemManipulation {
	XCTAssertEqual([model countOfItems], 0);
	[model addItem:[self createItem1] withQuantity:5.5];
	XCTAssertEqual([model countOfItems], 1);
	[model addItem:[self createItem2] withQuantity:3];
	XCTAssertEqual([model countOfItems], 2);
	[model removeItem:[self createItem1]];
	XCTAssertEqual([model countOfItems], 1);
	[model removeItem:[self createItem2]];
	XCTAssertEqual([model countOfItems], 0);
}

-(void) testTotalNumberWithoutDistinction {
	[model addItem:[self createItem1] withQuantity:5.5];
	[model addItem:[self createItem2] withQuantity:3];
	XCTAssertEqual([model totalNumberOfItemsWithoutDistinction], 4);
}

-(void) testTotalPrice {
	[model addItem:[self createItem1] withQuantity:5.5];
	[model addItem:[self createItem2] withQuantity:3];
	XCTAssertEqual([model totalPriceInBaseCurrency], 55 + 3 * 5);
}

@end
