//
//  EndpointTests.m
//  Basket
//
//  Created by Joseph Mallah on 11.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Endpoint.h"

@interface EndpointTests : XCTestCase

@end

@implementation EndpointTests

-(NSString *) scheme {
	return @"http";
}

-(NSString *) host {
	return @"test.com";
}

-(NSString *) relaivePath {
	return @"/relative";
}

-(Endpoint *) createEndpoint {
	NSURLComponents * urlComponents = [[NSURLComponents alloc] init];
	urlComponents.scheme = [self scheme];
	urlComponents.host = [self host];
	XCTAssertNotNil(urlComponents);
	
	Endpoint * endpoint = [[Endpoint alloc] init];
	XCTAssertNotNil(endpoint);
	
	[endpoint setBaseURLComponents:urlComponents];
	XCTAssertNotNil(endpoint.baseURLComponents);
	XCTAssertEqualObjects(urlComponents, endpoint.baseURLComponents);
	
	NSString * relativePath = [self relaivePath];
	[endpoint setRelativePath:relativePath];
	XCTAssertNotNil(endpoint.relativePath);
	XCTAssertEqualObjects(relativePath, endpoint.relativePath);
	
	return endpoint;
}

- (void)testRequestWithNoParameters {
	Endpoint * endpoint = [self createEndpoint];
	NSMutableURLRequest * request = [endpoint requestWithParameters:nil];
	XCTAssertNotNil(request);
	
	NSString * resultingString = request.URL.absoluteString;
	XCTAssertNotNil(resultingString);
	NSString * expectedString = [NSString stringWithFormat:@"%@://%@%@",[self scheme],[self host],[self relaivePath]];
	XCTAssertEqualObjects(resultingString, expectedString);
}

- (void)testRequestWithParameter {
	Endpoint * endpoint = [self createEndpoint];
	NSString * key = @"key";
	NSString * value = @"value";
	NSDictionary * parameters = @{key:value};
	NSMutableURLRequest * request = [endpoint requestWithParameters:parameters];
	XCTAssertNotNil(request);
	
	NSString * resultingString = request.URL.absoluteString;
	XCTAssertNotNil(resultingString);
	NSString * expectedString = [NSString stringWithFormat:@"%@://%@%@?%@=%@",[self scheme],[self host],[self relaivePath],key,value];
	XCTAssertEqualObjects(resultingString, expectedString);
}

- (void)testRequestWithParameters {
	Endpoint * endpoint = [self createEndpoint];
	NSString * key1 = @"key1";
	NSString * value1 = @"value1";
	NSString * key2 = @"key2";
	NSString * value2 = @"value2";
	NSDictionary * parameters = @{key1:value1, key2: value2};
	NSMutableURLRequest * request = [endpoint requestWithParameters:parameters];
	XCTAssertNotNil(request);
	
	NSString * resultingString = request.URL.absoluteString;
	XCTAssertNotNil(resultingString);
	NSString * expectedString = [NSString stringWithFormat:@"%@://%@%@?%@=%@&%@=%@",[self scheme],[self host],[self relaivePath],key1,value1,key2,value2];
	XCTAssertEqualObjects(resultingString, expectedString);
}


@end
