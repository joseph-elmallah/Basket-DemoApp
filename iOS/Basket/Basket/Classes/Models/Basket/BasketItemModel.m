//
//  BasketItemModel.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BasketItemModel.h"

@implementation BasketItemModel

-(double)totalPrice {
	return [self.item.price priceForQuantity:self.quantity];
}

-(NSUInteger)displayQuantity {
	NSUInteger itemsNumber = 0;
	if (self.item.price.unitCategory.divisible) {
		itemsNumber = 1;
	} else {
		itemsNumber = (NSUInteger) self.quantity;
	}
	return itemsNumber;
}

@end
