//
//  BasketModel.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasketItemModel.h"

static NSString * const BasketModelItemsPropoerty = @"items";

/**
 A model representing a basket
 */
@interface BasketModel : NSObject <NSCoding>

/**
 The creation date of the basket
 */
@property(nonatomic, copy, readonly) NSDate * creationDate;

/**
 Returns the number of distinct items contained in the basket
 
 @return The number of items
 */
-(NSUInteger)countOfItems;

/**
 Returns the item model at the provided index
 
 @param index The index of the item model
 @return An item model at the specified index
 */
-(id)objectInItemsAtIndex:(NSUInteger)index;


-(void)insertObject:(BasketItemModel *)object inItemsAtIndex:(NSUInteger)index;
-(void)removeItemsObject:(BasketItemModel *)object;
-(void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)object;

/**
 Adds the specified quantity of an item to the basket
 
 @param item The item to add
 @param quantity The quantity of that item
 */
-(void) addItem: (ItemModel *) item withQuantity: (float) quantity;

/**
 Removes an item from the basket
 
 @param item The item to remove
 */
-(void) removeItem: (ItemModel *) item;

/**
 Returns the number of items regardless of distinction

 @return The number of items regardless of distinction
 */
-(NSUInteger) totalNumberOfItemsWithoutDistinction;

/**
 Returns the total price for all the items in the basket using the base currency as measure

 @return The total price of the basket in the base currency
 */
-(double) totalPriceInBaseCurrency;

@end
