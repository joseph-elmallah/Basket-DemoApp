//
//  ResponseParser.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "ResponseParser.h"
#import "CurrencyRateModel.h"

@implementation ResponseParser

-(void) parseData: (NSData *) data response: (NSURLResponse *) response  completion: (void(^)(id object, NSError * error)) completion {
	if ([response isKindOfClass:[NSHTTPURLResponse class]] == false) {
		completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1000 userInfo:@{NSLocalizedDescriptionKey: @"Unexpeced Response"}]);
		return;
	}
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
	if (httpResponse.statusCode == 200) {
		if (data == nil) {
			completion(nil, nil);
			return;
		}
		//Success, we can parse the data
		NSError * jsonParsingError = nil;
		NSDictionary * parsedResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
		if (jsonParsingError == nil && parsedResponse != nil && [parsedResponse isKindOfClass:[NSDictionary class]]) {
			NSNumber * successStatus = parsedResponse[@"success"];
			if (successStatus != nil && [successStatus boolValue] == false) {
				NSString * code = parsedResponse[@"error"][@"code"];
				NSString * reason = parsedResponse[@"error"][@"info"];
				completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1003 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Request failed: %@ - %@", code, reason]}]);
			} else {
				completion(parsedResponse, nil);
			}
		} else {
			completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Could not parse the JSON"}]);
		}
	} else {
		completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1001 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unexpected status code: %ld", (long)httpResponse.statusCode]}]);
	}
}

@end

@implementation SupportedCurrenciesResponseParser

-(void)parseData:(NSData *)data response:(NSURLResponse *)response completion:(void (^)(id, NSError *))completion {
	[super parseData:data response:response completion:^(id object, NSError * error) {
		if (error != nil) {
			completion(object, error);
		} else {
			NSDictionary * supportedCurrencies = object[@"currencies"];
			if ([supportedCurrencies isKindOfClass:[NSDictionary class]]) {
				NSMutableArray * currencies = [NSMutableArray new];
				for (NSString * ISOKey in supportedCurrencies) {
					NSString * description = supportedCurrencies[ISOKey];
					CurrencyRateModel * model = [[CurrencyRateModel alloc] init];
					[model setISOCode:ISOKey];
					[model setDisplayName:description];
					[currencies addObject:model];
				}
				completion(currencies, nil);
			} else {
				completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Could not parse the JSON. Missing key currencies"}]);
			}
		}
	}];
}

@end


@implementation RatesResponseParser

-(void)parseData:(NSData *)data response:(NSURLResponse *)response completion:(void (^)(id, NSError *))completion {
	[super parseData:data response:response completion:^(id object, NSError * error) {
		if (error != nil) {
			completion(object, error);
		} else {
			NSDictionary * quotes = object[@"quotes"];
			NSString * source = object[@"source"];
			if ([quotes isKindOfClass:[NSDictionary class]]) {
				NSMutableDictionary * rates = [NSMutableDictionary new];
				for (NSString * ISOKey in quotes) {
					NSNumber * rate = quotes[ISOKey];
					NSString * ISOParsedKey = [ISOKey stringByReplacingOccurrencesOfString:source withString:@""];
					if (ISOParsedKey.length == 0) {
						ISOParsedKey = source;
					}
					[rates setObject:rate forKey:ISOParsedKey];
				}
				completion(rates, nil);
			} else {
				completion(nil, [NSError errorWithDomain:@"ResponseParser" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Could not parse the JSON. Missing key currencies"}]);
			}
		}
	}];
}

@end
