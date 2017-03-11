//
//  UILabel+BasketItems.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "UILabel+BasketItems.h"

@implementation NSString (BasketItemCount)

+(NSString *)stringFromNumberOfItems:(NSUInteger)numberOfItems {
	NSString * text = [NSString localizedStringWithFormat:NSLocalizedString(@"%d items", @"The number of items contained in a basket"), numberOfItems];
	return text;
}

+(NSString *)stringFromSelectedQuantity:(float)selectedQuantity {
	NSString * text = [NSString localizedStringWithFormat:NSLocalizedString(@"%g selected", @"The selected amount of an item in a basket"), selectedQuantity];
	return text;
}

@end

@implementation UILabel (BasketItems)

-(void)setNumberOfItems:(NSUInteger)numberOfItems {
	self.text = [NSString stringFromNumberOfItems:numberOfItems];
}

-(void) setSelectedQuantity: (float) selectedQuantity {
	self.text = [NSString stringFromSelectedQuantity:selectedQuantity];
}

@end
