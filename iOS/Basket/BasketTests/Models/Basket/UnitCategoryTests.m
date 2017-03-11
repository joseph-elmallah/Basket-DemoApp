//
//  UnitCategoryTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UnitCategory.h"

@interface UnitCategoryTests : XCTestCase {
	UnitCategory * model;
}

@end

@implementation UnitCategoryTests

- (void)setUp {
    [super setUp];
	model = [[UnitCategory alloc] init];
	[model setLocalizedUnitDisplayTitle:@"Bottle"];
	XCTAssertEqualObjects(model.localizedUnitDisplayTitle, @"Bottle");
}

- (void)tearDown {
	model = nil;
    [super tearDown];
}

- (void)testCopying {
	UnitCategory * copyModel = [model copy];
	XCTAssertNotNil(copyModel);
	XCTAssertTrue([copyModel isEqualToUnitCategory:model]);
}

- (void) testEncoding {
	NSData * encodedModel = [NSKeyedArchiver archivedDataWithRootObject:model];
	XCTAssertNotNil(encodedModel);
	XCTAssertTrue(encodedModel.length > 0);
	
	id decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedModel];
	XCTAssertNotNil(decodedObject);
	XCTAssertTrue([decodedObject isKindOfClass:[UnitCategory class]]);
	UnitCategory * decodedModel = (UnitCategory *) decodedObject;
	XCTAssertTrue([decodedModel isEqualToUnitCategory:model]);
}

-(void) testParsableFromJSON {
	NSDictionary * jsonObject = @{@"title":@"Bottle",@"divisible":[NSNumber numberWithBool:NO]};
	UnitCategory * parsedModel = [[UnitCategory alloc] initWithJSONObject:jsonObject];
	XCTAssertNotNil(parsedModel);
	XCTAssertTrue([parsedModel isEqualToUnitCategory:model]);
}

@end
