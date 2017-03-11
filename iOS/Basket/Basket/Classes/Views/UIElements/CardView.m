//
//  CardView.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CardView.h"
#import "UIView+ShadowView.h"

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self configure];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self configure];
	}
	return self;
}

-(void) configure {
	[self castShadow];
	self.layer.cornerRadius = 10.0f;
}

@end
