//
//  BasketModelController.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BasketModelController.h"

@interface BasketModelController ()
/**
 The baskets
 */
@property(nonatomic, strong) NSMutableArray * baskets;
@end

@implementation BasketModelController

-(NSMutableArray *) baskets {
	if (_baskets == nil) {
		_baskets = [NSMutableArray new];
	}
	return _baskets;
}

-(NSUInteger)countOfBaskets {
	return self.baskets.count;
}

-(id)objectInBasketsAtIndex:(NSUInteger)index {
	return [self.baskets objectAtIndex:index];
}

-(void)insertObject:(BasketModel *)object inBasketsAtIndex:(NSUInteger)index {
	[self.baskets insertObject:object atIndex:index];
}

-(void)addBasketsObject:(BasketModel *)object {
	[self insertObject:object inBasketsAtIndex:0];
}

-(void)removeObjectFromBasketsAtIndex:(NSUInteger)index {
	[self.baskets removeObjectAtIndex:index];
}

-(void)replaceObjectInBasketsAtIndex:(NSUInteger)index withObject:(id)object {
	[self.baskets replaceObjectAtIndex:index withObject:object];
}

@end
