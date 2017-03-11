//
//  ResponseParserTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ResponseParser.h"

@interface ResponseParserTests : XCTestCase {
	ResponseParser * parser;
}
@end

@implementation ResponseParserTests

-(void)setUp {
	[super setUp];
	parser = [[ResponseParser alloc] init];
	XCTAssertNotNil(parser);
}

-(void)tearDown {
	parser = nil;
	[super tearDown];
}

-(void) testSuccessResponseNoData {
	NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://somestuff.com/yes"] statusCode:200 HTTPVersion:@"1.1" headerFields:nil];
	
	XCTestExpectation * expectation = [self expectationWithDescription:@"Parsing Data"];
	[parser parseData:nil response:httpResponse completion:^(id object, NSError *error) {
		XCTAssertNil(object);
		XCTAssertNil(error);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:1 handler:nil];
}

-(void) testSuccessResponseData {
	NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://somestuff.com/yes"] statusCode:200 HTTPVersion:@"1.1" headerFields:nil];
	
	NSData * randomData = [@"{\"key\":\"value\"}" dataUsingEncoding:NSUTF8StringEncoding];
	
	XCTestExpectation * expectation = [self expectationWithDescription:@"Parsing Data"];
	[parser parseData:randomData response:httpResponse completion:^(id object, NSError *error) {
		XCTAssertNotNil(object);
		XCTAssertNil(error);
		XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
		NSDictionary * parsedData = (NSDictionary *) object;
		XCTAssertEqualObjects(parsedData[@"key"], @"value");
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:1 handler:nil];
}

-(void) testFailedResponseNotHTTP {
	NSURLResponse * notHTTPResponse = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"ftp://somestuff.com/yes"] MIMEType:@"picture/png" expectedContentLength:2056 textEncodingName:@"utf8"];
	
	XCTestExpectation * expectation = [self expectationWithDescription:@"Parsing Data"];
	[parser parseData:nil response:notHTTPResponse completion:^(id object, NSError *error) {
		XCTAssertNil(object);
		XCTAssertNotNil(error);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:1 handler:nil];
}

-(void) testFailedResponseNot200 {
	NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://somestuff.com/yes"] statusCode:404 HTTPVersion:@"1.1" headerFields:nil];
	
	XCTestExpectation * expectation = [self expectationWithDescription:@"Parsing Data"];
	[parser parseData:nil response:httpResponse completion:^(id object, NSError *error) {
		XCTAssertNil(object);
		XCTAssertNotNil(error);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:1 handler:nil];
	
}

-(void) testFailedResponseMalformatedJSON {
	
	NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://somestuff.com/yes"] statusCode:200 HTTPVersion:@"1.1" headerFields:nil];
	
	NSData * randomData = [@"Hello test" dataUsingEncoding:NSUTF8StringEncoding];
	
	XCTestExpectation * expectation = [self expectationWithDescription:@"Parsing Data"];
	[parser parseData:randomData response:httpResponse completion:^(id object, NSError *error) {
		XCTAssertNil(object);
		XCTAssertNotNil(error);
		[expectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:1 handler:nil];
	
}

@end



















