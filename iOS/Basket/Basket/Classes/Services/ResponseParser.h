//
//  ResponseParser.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A response parser can parse URL responses and create object out of them
 */
@interface ResponseParser : NSObject

/**
 Parses the data and returns an object or an error

 @param data The data to be parsed
 @param response The response recived
 @param completion A completion block
 */
-(void) parseData: (NSData *) data response: (NSURLResponse *) response  completion: (void(^)(id object, NSError * error)) completion;

@end


/**
 Response parser for supported currencies. Returns a list of currency rate model without the rate
 */
@interface SupportedCurrenciesResponseParser : ResponseParser

@end

/**
 Response parser for rates of currencies. Returns a dictionary containing the ISO code with the rate
 */
@interface RatesResponseParser : ResponseParser

@end
