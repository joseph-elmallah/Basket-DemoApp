//
//  UIColor+BasketColors.h
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIElementsRole.h"

@interface UIColor (BasketColors)

/**
 Returns the color associated with the role

 @param role The role
 @return The color for the role
 */
+(UIColor *) basketColorForRole:(BasketUIElementsRole) role;

/**
 Returns the highlighted color associated with the role
 
 @param role The role
 @return The highlighted color for the role
 */
+(UIColor *) basketHighligtedColorForRole:(BasketUIElementsRole)role;

/**
 Returns the tint color fot the role

 @return The tint color for a role
 */
+(UIColor *) basketTintColorForRole:(BasketUIElementsRole) role;

@end
