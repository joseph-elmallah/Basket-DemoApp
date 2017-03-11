//
//  BasketModel.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BasketModel.h"

static NSString * const BasketModelCreationDateCodingKey = @"BasketModelCreationDateCodingKey";
static NSString * const BasketModelItemsCodingKey = @"BasketModelItemsCodingKey";

@interface BasketModel ()
/**
 The items in the basket
 */
@property(nonatomic, strong) NSMutableArray * items;
@end

@implementation BasketModel

- (instancetype)init
{
	self = [super init];
	if (self) {
		_creationDate = [NSDate new];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super init];
	if (self) {
		_creationDate = [coder decodeObjectForKey:BasketModelCreationDateCodingKey];
		_items = [coder decodeObjectForKey:BasketModelItemsCodingKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.creationDate forKey:BasketModelCreationDateCodingKey];
	[coder encodeObject:self.items forKey:BasketModelItemsCodingKey];
}

-(NSMutableArray *) items {
	if (_items == nil) {
		_items = [NSMutableArray new];
	}
	return _items;
}

-(NSUInteger) countOfItems {
	return self.items.count;
}

-(id)objectInItemsAtIndex:(NSUInteger)index {
	return self.items[index];
}

-(void)insertObject:(BasketItemModel *)object inItemsAtIndex:(NSUInteger)index {
	[self willChangeValueForKey:BasketModelItemsPropoerty];
	[self.items insertObject:object atIndex:index];
	[self didChangeValueForKey:BasketModelItemsPropoerty];
}

-(void)removeItemsObject:(BasketItemModel *)object {
	[self willChangeValueForKey:BasketModelItemsPropoerty];
	[self.items removeObject:object];
	[self didChangeValueForKey:BasketModelItemsPropoerty];
}

-(void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)object {
	[self.items replaceObjectAtIndex:index withObject:object];
}

-(void)addItem:(ItemModel *)item withQuantity:(float)quantity {
	BasketItemModel * basketItemModel = [BasketItemModel new];
	[basketItemModel setItem:item];
	[basketItemModel setQuantity:quantity];
	[self insertObject:basketItemModel inItemsAtIndex:0];
}

-(void)removeItem:(ItemModel *)item {
	BasketItemModel * basketItemModelToRemove = nil;
	for (BasketItemModel * basketItemModel in self.items) {
		if ([basketItemModel.item isEqualToItemModel:item]) {
			basketItemModelToRemove = basketItemModel;
			break;
		}
	}
	if (basketItemModelToRemove) {
		[self removeItemsObject:basketItemModelToRemove];
	}
}

-(NSUInteger)totalNumberOfItemsWithoutDistinction {
	NSUInteger total = 0;
	for (BasketItemModel * model in self.items) {
		total += [model displayQuantity];
	}
	return total;
}

-(double)totalPriceInBaseCurrency {
	double grandTotal = 0;
	for (BasketItemModel * item in self.items) {
		grandTotal += item.totalPrice;
	}
	return  grandTotal;
}

@end
