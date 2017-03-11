//
//  UIView+ShadowView.h
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShadowView)

/**
 Cast a shadow
 */
-(void) castShadow;

/**
 Cast a shadow that simulates an element is tapped
 */
-(void) castTappedShadow;

/**
 Clears a shadow
 */
-(void) clearShadow;

@end
