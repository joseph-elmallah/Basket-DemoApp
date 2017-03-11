//
//  UIView+ShadowView.m
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "UIView+ShadowView.h"
#import "UIColor+BasketColors.h"

@implementation UIView (ShadowView)

-(void)castShadow {
	self.layer.shadowColor = [UIColor basketColorForRole:BasketUIElementsRoleShadow].CGColor;
	self.layer.shadowOffset = CGSizeMake(3, 3);
	self.layer.shadowRadius = 4;
	self.layer.shadowOpacity = 0.3;
}

-(void)castTappedShadow {
	self.layer.shadowColor = [UIColor basketColorForRole:BasketUIElementsRoleShadow].CGColor;
	self.layer.shadowOffset = CGSizeMake(2, 2);
	self.layer.shadowRadius = 3;
	self.layer.shadowOpacity = 0.2;
}

-(void)clearShadow {
	self.layer.shadowColor = [UIColor clearColor].CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowRadius = 0;
	self.layer.shadowOpacity = 0.0;
}

@end
