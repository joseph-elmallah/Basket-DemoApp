//
//  Endpoint.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class that represents an endpoint
 */
@interface Endpoint : NSObject

/**
 The base URL components to use
 */
@property(nonatomic, copy) NSURLComponents * baseURLComponents;

/**
 The relative path to reach the endpoint
 */
@property(nonatomic, copy) NSString * relativePath;

/**
 The common prarmeters that needs to be added for every request
 */
@property(nonatomic, copy) NSDictionary * commonParameters;

/**
 Returns a request with the specified parameters

 @param parameters Parameter dictionary
 @return The request
 */
-(NSMutableURLRequest *) requestWithParameters: (NSDictionary *) parameters;


/**
 Returns the endpoint returning the rates

 @return The endpoint of the rates
 */
+(Endpoint *) RatesEndpoint;

/**
 Returns the supported currencies endpoint
 
 @return The endpoint of the supported currencies
 */
+(Endpoint *) SupportedCurrenciesEndpoint;

@end
