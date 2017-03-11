//
//  ItemsHeaderCollectionReusableView.m
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "ItemsHeaderCollectionReusableView.h"

@interface ItemsHeaderCollectionReusableView ()
/**
 The label of the title in the header
 */
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation ItemsHeaderCollectionReusableView

-(UILabel *)titleLabel {
	if (_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
		[_titleLabel setTextAlignment:NSTextAlignmentNatural];
		[_titleLabel setTextColor:[UIColor blackColor]];
		[_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
	}
	return _titleLabel;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

-(void) setup {
	[self addSubview:self.titleLabel];
	
	[self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:0] setActive:YES];
	[[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20] setActive:YES];
	[[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0] setActive:YES];
	[[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0] setActive:YES];
	
	[self.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
	[self.titleLabel setAdjustsFontForContentSizeCategory:YES];
}

-(void)setTitle:(NSString *)title {
	[self.titleLabel setText:title];
}

-(NSString *)title {
	return self.titleLabel.text;
}

@end




















