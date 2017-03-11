//
//  EmptyView.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "EmptyView.h"
#import "UIView+ShadowView.h"

@interface EmptyView ()
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) UILabel * titleLabel;
@end

@implementation EmptyView

-(UIImageView *) imageView {
	if (_imageView == nil) {
		UIImageView * imageView = [[UIImageView alloc] init];
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		imageView.tintColor = self.tintColor;
		imageView.image = self.image;
		_imageView = imageView;
	}
	return _imageView;
}

-(UILabel *) titleLabel {
	if (_titleLabel == nil) {
		UILabel * label = [[UILabel alloc] init];
		label.text = self.title;
		label.textColor = self.tintColor;
		label.textAlignment = NSTextAlignmentCenter;
		label.numberOfLines = 0;
		_titleLabel = label;
	}
	return  _titleLabel;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self configure];
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self configure];
	}
	return self;
}

-(void) configure {	
	[self addSubview:self.imageView];
	[self addSubview:self.titleLabel];
	
	[self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	CGFloat margin = 10.0f;
	[[self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant: margin] setActive:YES];
	[[self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: margin] setActive:YES];
	[[self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -margin] setActive:true];
	[[self.imageView.bottomAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:-8] setActive:YES];
	[[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: margin] setActive:YES];
	[[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -margin]setActive:YES];
	[[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant: -margin] setActive:YES];
	
	[self.imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

	[self castShadow];
	self.layer.cornerRadius = 10.0f;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(void) setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	_imageView.tintColor = tintColor;
	_titleLabel.textColor = tintColor;
}

-(void) setTitle:(NSString *)title {
	_title = title;
	self.titleLabel.text = title;
}

-(void) setImage:(UIImage *)image {
	_image = image;
	self.imageView.image = image;
}

-(void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted) {
		[self castTappedShadow];
		self.imageView.alpha = 0.6;
		self.titleLabel.alpha = 0.6;
	} else {
		[self castShadow];
		self.imageView.alpha = 1.0;
		self.titleLabel.alpha = 1.0;
	}
}

-(BOOL)isAccessibilityElement {
	return YES;
}

-(UIAccessibilityTraits)accessibilityTraits {
	return UIAccessibilityTraitButton;
}

-(NSString *)accessibilityLabel {
	return self.titleLabel.text;
}

@end
