//
//  CashLabel.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceModel;
/**
 A label that displays an amount in a currency and also is aware of change in currency and exchange rates
 */
@interface CashLabel : UILabel

/**
 The base amount of the label
 */
@property(nonatomic, assign) double baseAmount;

/**
 A suffix text appended after the amount
 */
@property (nonatomic, copy) NSString * suffix;

/**
 Setup the cash label from a price model

 @param priceModel The price model to use
 */
-(void) setPriceModel: (PriceModel *) priceModel;

@end
