//
//  BaseModelController.m
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BaseModelController.h"

@implementation BaseModelController

-(instancetype)init {
	self = [super init];
	if (self) {
		self.cleanliness = ModelControllerStateDirty;
		self.business = ModelControllerStateIdle;
	}
	return self;
}

-(void)cancel {}

@end
