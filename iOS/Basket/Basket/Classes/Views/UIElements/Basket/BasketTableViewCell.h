//
//  BasketTableViewCell.h
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasketModel;

/**
 A cell that represents a basket
 */
@interface BasketTableViewCell : UITableViewCell

/**
 The basket represented by the cell
 */
@property(nonatomic, strong) BasketModel * basketModel;

@end
