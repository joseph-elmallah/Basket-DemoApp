//
//  UnitCategoryView.m
//  Basket
//
//  Created by Joseph Mallah on 03.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "ItemModelView.h"
#import "ItemModel.h"

@interface ItemModelView ()
@property(nonatomic, strong) UIImageView * imageView;
@end

@implementation ItemModelView

-(UIImageView *) imageView {
	if (_imageView == nil) {
		_imageView = [[UIImageView alloc] init];
		[_imageView setContentMode:UIViewContentModeScaleAspectFit];
		[_imageView setTintColor:self.tintColor];
	}
	return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupUI];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupUI];
	}
	return self;
}

-(void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	[self.imageView setTintColor:tintColor];
}

-(void)setItemModel:(ItemModel *)itemModel {
	[self clearView];
	[self.imageView setImage:[UIImage imageNamed:itemModel.imageName]];
}

-(void) setupUI {
	[self addSubview:self.imageView];
	[self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
	[[self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
	[[self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
	[[self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
}

-(void) clearView {
	self.imageView.image = nil;
}

-(CGSize)sizeThatFits:(CGSize)size {
	return self.imageView.image.size;
}

@end









