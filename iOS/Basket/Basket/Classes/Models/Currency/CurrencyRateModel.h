//
//  CurrencyRateModel.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CurrencyRateModelExchangeRateProperty = @"exchangeRate";

/**
 A curency object with it's rate
 */
@interface CurrencyRateModel : NSObject <NSCoding>

/**
 The ISO representation of the currency
 */
@property(nonatomic, copy) NSString * ISOCode;
/**
 The display name of the currency
 */
@property(nonatomic, copy) NSString * displayName;
/**
 The exchange rate
 */
@property(nonatomic, assign) double exchangeRate;
/**
 The last refresh date 
 */
@property(nonatomic, copy, readonly) NSDate * refreshDate;

/**
 Returns the amount after doing the exchange rate

 @param baseAmount The amount in the base currency
 @return The amount after doing the exchange rate. -1 if no exchange rate is set
 */
-(double) amountAfterExchange: (double) baseAmount;

/**
 Checks if two objects are equal

 @param object The object to check against
 @return @b YES is equal, @b NO if not equal
 */
-(BOOL) isEqualToCurrencyRateModel:(CurrencyRateModel *)object;

@end
