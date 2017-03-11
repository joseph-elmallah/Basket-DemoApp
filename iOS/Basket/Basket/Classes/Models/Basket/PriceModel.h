//
//  PriceModel.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitCategory.h"
#import "ParsableFromJSON.h"

/**
 The price representation
 */
@interface PriceModel : NSObject <NSCopying, NSCoding, ParsableFromJSON>

/**
 The amount in the base currency
 */
@property(nonatomic, assign) double amount;

/**
 The localized display title of the unit
 */
@property(nonatomic, copy) UnitCategory * unitCategory;

/**
 Computes and returns the total price for the passed units

 @param quantity The quantity to comput the price accordingly. If the price supports divisibility then it can be a fraction
 @return The total price for the passed quantity
 */
-(double) priceForQuantity: (float) quantity;

/**
 Returns if the current object is equal to the passed object
 
 @param priceModel The item to compare against
 @return @b YES if they are equal, @b NO otherwise
 */
-(BOOL) isEqualToPriceModel: (PriceModel *) priceModel;

@end
