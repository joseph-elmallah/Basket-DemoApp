//
//  CurrencyTableViewController.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The possible modes of a currency selector

 - CurrencyTableViewControllerSelectCurrency: Will select a currency and dismiss
 - CurrencyTableViewControllerCheckout: will proceed and create a basket
 */
typedef NS_ENUM(NSInteger, CurrencyTableViewControllerMode) {
	CurrencyTableViewControllerSelectCurrency,
	CurrencyTableViewControllerCheckout
};

@class BasketModel;
@interface CurrencyTableViewController : UITableViewController

/**
 A value to display times the currency rate. Default is 1
 */
@property (nonatomic, assign) double baseValue;

/**
 The mode of the currency selector
 */
@property (nonatomic, assign) CurrencyTableViewControllerMode mode;

@end
