//
//  CurrencyTableViewCell.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrencyRateModel;

/**
 A cell that displays the currency rate
 */
@interface CurrencyTableViewCell : UITableViewCell

/**
 A value to display times the currency rate. Default is 1
 */
@property (nonatomic, assign) double baseValue;


/**
 Sets the cell to display the currency rate

 @param currencyRate The currency rate to display
 */
-(void)setCurrencyRate:(CurrencyRateModel *)currencyRate;

@end
