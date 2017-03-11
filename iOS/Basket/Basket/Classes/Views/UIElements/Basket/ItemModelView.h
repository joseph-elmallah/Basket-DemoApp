//
//  UnitCategoryView.h
//  Basket
//
//  Created by Joseph Mallah on 03.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

/**
 Represents an item in a basket
 */
@interface ItemModelView : UIView

/**
 Displays the passed item model

 @param itemModel The item model to display
 */
-(void) setItemModel: (ItemModel *) itemModel;

@end
