//
//  ItemCollectionViewCell.h
//  Basket
//
//  Created by Joseph Mallah on 06.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

/**
 A cell representing a item in a collection view
 */
@interface ItemCollectionViewCell : UICollectionViewCell

/**
 The item model represented by the cell
 */
@property(nonatomic, strong) ItemModel * itemModel;

@end
