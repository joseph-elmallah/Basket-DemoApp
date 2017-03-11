//
//  BasketModelController.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModelController.h"
#import "BasketModel.h"

static NSString * const BasketModelControllerBasketsProperty = @"baskets";

/**
 A model controller that takes care of the baskets
 */
@interface BasketModelController : BaseModelController

/**
 Returns the number of baskets

 @return The number of baskets
 */
-(NSUInteger) countOfBaskets;

/**
 Returns the basket at an index

 @param index The index of the basket
 @return The basket at the specified index
 */
-(id)objectInBasketsAtIndex:(NSUInteger)index;

/**
 Inserts a basket at an index

 @param object The basket to insert
 @param index The index to insert the basket at
 */
-(void)insertObject:(BasketModel *)object inBasketsAtIndex:(NSUInteger)index;

/**
 Add a basket to the beginning of the array

 @param object A basket
 */
-(void) addBasketsObject:(BasketModel *)object;

/**
 Removes a basket at an index

 @param index The index of the basket to remove
 */
-(void) removeObjectFromBasketsAtIndex:(NSUInteger)index;

/**
 Replaces a basket at an index with another one

 @param index The index of the basket to replace
 @param object The basket to replace with
 */
-(void)replaceObjectInBasketsAtIndex:(NSUInteger)index withObject:(id)object;

@end















