//
//  Endpoint.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "Endpoint.h"

@implementation Endpoint

-(NSMutableURLRequest *)requestWithParameters:(NSDictionary *)parameters {
	NSAssert(self.baseURLComponents != nil, @"No base URL specified");
	NSURLComponents * urlComponents = [self baseURLComponents];
	urlComponents.path = self.relativePath;
	
	NSMutableArray * queryItems = [NSMutableArray new];
	
	for (NSString * key in self.commonParameters) {
		id value = self.commonParameters[key];
		NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:key value:value];
		[queryItems addObject:queryItem];
	}
	
	for (NSString * key in parameters) {
		id value = parameters[key];
		NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:key value:value];
		[queryItems addObject:queryItem];
	}
	
	if (queryItems.count != 0) {
		[urlComponents setQueryItems:queryItems];
	}
	
	NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:10];
	return request;
}

+(Endpoint *) CurrencyLayerAPIEndpoint {
	Endpoint * endpoint = [[Endpoint alloc] init];
	
	NSURLComponents * urlComponents = [[NSURLComponents alloc] init];
	urlComponents.scheme = @"http";
	urlComponents.host = @"apilayer.net";
	[endpoint setBaseURLComponents:urlComponents];
	NSString * accessKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AccessKey"];
	NSAssert(accessKey.length > 0, @"No access key specified in info.plist");
	[endpoint setCommonParameters:@{@"access_key": accessKey}];
	return endpoint;
	
}

+(Endpoint *)RatesEndpoint {
	Endpoint * endpoint = [self CurrencyLayerAPIEndpoint];
	[endpoint setRelativePath:@"/api/live"];
	return endpoint;
}

+(Endpoint *)SupportedCurrenciesEndpoint {
	Endpoint * endpoint = [self CurrencyLayerAPIEndpoint];
	[endpoint setRelativePath:@"/api/list"];
	return endpoint;
}

@end
