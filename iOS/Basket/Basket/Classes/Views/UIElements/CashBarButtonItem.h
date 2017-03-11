//
//  CashBarButtonItem.h
//  Basket
//
//  Created by Joseph Mallah on 09.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A bar button item representing some amount of cash
 */
@interface CashBarButtonItem : UIBarButtonItem

/**
 The base amount of the label
 */
@property(nonatomic, assign) double baseAmount;

@end
