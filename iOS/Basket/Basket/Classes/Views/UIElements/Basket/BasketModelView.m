//
//  BasketModelView.m
//  Basket
//
//  Created by Joseph Mallah on 05.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "BasketModelView.h"
#import "BasketModel.h"
#import "ItemModelView.h"
#import "UIView+ShadowView.h"

static NSUInteger const maximumNumberOfItemDisplayedAtATime = 15;

@interface BasketModelView ()
@property (nonatomic, strong) UIView * itemsContrainerView;
@property (nonatomic, strong) UIImageView * basketImageView;

@property (nonatomic, strong) CMMotionManager * motionManager;
@property (nonatomic, strong) NSOperationQueue * motionQueue;
@property (nonatomic, strong) UIDynamicAnimator * animator;
@property (nonatomic, strong) UIGravityBehavior * gravity;
@property (nonatomic, strong) UICollisionBehavior * collision;
@end

@implementation BasketModelView

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

-(UIView *) itemsContrainerView {
	if (_itemsContrainerView == nil) {
		_itemsContrainerView = [[UIView alloc] init];
		[_itemsContrainerView setBackgroundColor:[UIColor clearColor]];
	}
	return _itemsContrainerView;
}

-(UIImageView *)basketImageView {
	if (_basketImageView == nil) {
		_basketImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"basket"]];
		[_basketImageView setContentMode:UIViewContentModeScaleAspectFit];
		[_basketImageView setTintColor:self.tintColor];
		[_basketImageView castShadow];
		[_basketImageView setAlpha:0.8];
	}
	return _basketImageView;
}

-(UIDynamicAnimator *)animator {
	if (_animator == nil) {
		_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
	}
	return _animator;
}

-(void)setBasketModel:(BasketModel *)basketModel {
	for (UIView * itemView in self.itemsContrainerView.subviews) {
		[self.gravity removeItem:itemView];
		[self.collision removeItem:itemView];
		[itemView removeFromSuperview];
	}
	NSUInteger totalNumberOfIndistictItemsAdded = 0;
	for (NSUInteger index = 0; index < [basketModel countOfItems]; ++index) {
		if (totalNumberOfIndistictItemsAdded >= maximumNumberOfItemDisplayedAtATime) {
			break;
		}
		BasketItemModel * model = [basketModel objectInItemsAtIndex:index];
		NSUInteger itemsNumber = [model displayQuantity];
		for (NSUInteger index = 0; index < itemsNumber; ++index) {
			if (totalNumberOfIndistictItemsAdded >= maximumNumberOfItemDisplayedAtATime) {
				break;
			}
			ItemModelView * modelView = [[ItemModelView alloc] initWithFrame:CGRectZero];
			[modelView setItemModel:model.item];
			[modelView setTintColor:self.basketItemsColor];
			[self.itemsContrainerView addSubview:modelView];
			[modelView sizeToFit];
			[modelView setCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
			[modelView setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self.gravity addItem:modelView];
			[self.collision addItem:modelView];
			++totalNumberOfIndistictItemsAdded;
		}
	}
}

-(void) setupUI {
	[self setBackgroundColor:[UIColor clearColor]];
	self.basketItemsColor = [UIColor blackColor];
	
	[self addSubview:self.itemsContrainerView];
	[self.itemsContrainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.itemsContrainerView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
	[[self.itemsContrainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
	[[self.itemsContrainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
	[[self.itemsContrainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
	
	[self addSubview:self.basketImageView];
	[self.basketImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.basketImageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
	[[self.basketImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
	[[self.basketImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
	[[self.basketImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
	
	self.gravity = [[UIGravityBehavior alloc] initWithItems:self.itemsContrainerView.subviews];
	self.collision = [[UICollisionBehavior alloc] initWithItems:self.itemsContrainerView.subviews];
	[self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
	[self.animator addBehavior:self.gravity];
	[self.animator addBehavior:self.collision];
	
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionQueue = [[NSOperationQueue alloc] init];
	[self.motionManager startDeviceMotionUpdatesToQueue:self.motionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
		CMAcceleration gravity = motion.gravity;
		dispatch_async(dispatch_get_main_queue(), ^{
			switch ([UIApplication sharedApplication].statusBarOrientation) {
				case UIInterfaceOrientationPortrait:
					self.gravity.gravityDirection = CGVectorMake(gravity.x, -gravity.y);
					break;
				case UIInterfaceOrientationLandscapeLeft:
					self.gravity.gravityDirection = CGVectorMake(gravity.y, gravity.x);
					break;
				case UIInterfaceOrientationLandscapeRight:
					self.gravity.gravityDirection = CGVectorMake(-gravity.y, -gravity.x);
					break;
				default:
					break;
			}
		});
	}];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	[self.collision removeBoundaryWithIdentifier:@"basketLeft"];
	[self.collision addBoundaryWithIdentifier:@"basketLeft" fromPoint:CGPointMake(self.bounds.size.width * 0.18125, self.bounds.size.height) toPoint:CGPointMake(0, self.bounds.size.height * (1 - 0.5714))];
	[self.collision addBoundaryWithIdentifier:@"basketLeft" fromPoint:CGPointMake(self.bounds.size.width * (1- 0.18125), self.bounds.size.height) toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height * (1 - 0.5714))];
}

-(void)setBasketItemsColor:(UIColor *)basketItemsColor {
	_basketItemsColor = basketItemsColor;
	for (UIView * itemView in self.itemsContrainerView.subviews) {
		[itemView setTintColor:basketItemsColor];
	}
}

-(void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	[self.basketImageView setTintColor:tintColor];
}

@end






















