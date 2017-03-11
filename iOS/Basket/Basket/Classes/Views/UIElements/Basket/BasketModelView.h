//
//  BasketModelView.h
//  Basket
//
//  Created by Joseph Mallah on 05.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasketModel;

/**
 Represents a basket with it's contents
 */
@interface BasketModelView : UIView

/**
 Displays the passed basket item

 @param basketModel The basket item to display
 */
-(void) setBasketModel: (BasketModel *) basketModel;

/**
 The color of the items in the basket
 */
@property(nonatomic, copy) UIColor * basketItemsColor;

@end
