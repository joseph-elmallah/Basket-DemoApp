//
//  BasketItemModel.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

/**
 An item that made his way to a basket, the item has a quantity associated with it
 */
@interface BasketItemModel : NSObject

/**
 The item model
 */
@property(nonatomic, strong) ItemModel * item;
/**
 The quantity of this item present in the basket
 */
@property(nonatomic, assign) float quantity;

/**
 The total price of the item according to their quantity

 @return The total price of the item according to their quantity
 */
-(double) totalPrice;

/**
 Returns the quantity that should be displayed. For divisible items this is always one

 @return The quantity that should be displayed
 */
-(NSUInteger) displayQuantity;

@end
