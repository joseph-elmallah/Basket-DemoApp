//
//  BasketItemCollectionViewCell.h
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasketItemModel;
/**
 A cell representing a basket item in a collection view
 */
@interface BasketItemCollectionViewCell : UICollectionViewCell

/**
 The basket item model represented
 */
@property (nonatomic, strong) BasketItemModel * basketItemModel;

@end
