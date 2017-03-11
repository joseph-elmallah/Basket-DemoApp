//
//  ItemModel.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceModel.h"
#import "ParsableFromJSON.h"
#import "PredefinedModel.h"

/**
 An item is a purchasable object
 */
@interface ItemModel : NSObject <NSCoding, ParsableFromJSON, PredefinedModel>

/**
 The name of the item
 */
@property(nonatomic, copy) NSString * name;
/**
 The image name representing the item
 */
@property(nonatomic, copy) NSString * imageName;
/**
 The price of the item
 */
@property(nonatomic, copy) PriceModel * price;

/**
 Returns if the current object is equal to the passed object

 @param itemModel The item to compare against
 @return @b YES if they are equal, @b NO otherwise
 */
-(BOOL) isEqualToItemModel: (ItemModel *) itemModel;

@end
