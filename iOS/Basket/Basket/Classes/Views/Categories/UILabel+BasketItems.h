//
//  UILabel+BasketItems.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (BasketItemCount)
/**
 Sets the number of items in the uilabel
 
 @param numberOfItems The number of items to set
 */
+(NSString *) stringFromNumberOfItems: (NSUInteger) numberOfItems;

/**
 Sets the number of selected quantities in the uilabel
 
 @param selectedQuantity The number of selected quantities to set
 */
+(NSString *)stringFromSelectedQuantity:(float)selectedQuantity;
@end

@interface UILabel (BasketItems)

/**
 Sets the number of items in the uilabel

 @param numberOfItems The number of items to set
 */
-(void) setNumberOfItems: (NSUInteger) numberOfItems;

/**
 Sets the number of selected quantities in the uilabel
 
 @param selectedQuantity The number of selected quantities to set
 */
-(void) setSelectedQuantity: (float) selectedQuantity;

@end
