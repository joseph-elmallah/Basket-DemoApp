//
//  BasketItemCollectionViewCell.m
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BasketItemCollectionViewCell.h"
#import "BasketItemModel.h"
#import "CashLabel.h"
#import "UILabel+BasketItems.h"

@interface BasketItemCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIStackView *mainStackView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet CashLabel *cashLabel;

@end

@implementation BasketItemCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		self.contentView.backgroundColor = [UIColor whiteColor];
		self.contentView.layer.cornerRadius = 10.0f;
		self.contentView.layer.borderWidth = 1.0f;
		self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
		self.contentView.layer.masksToBounds = YES;
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
		self.layer.shadowRadius = 4.0f;
		self.layer.shadowOpacity = 0.3f;
		self.layer.masksToBounds = NO;
	}
	return self;
}

-(void)awakeFromNib {
	[super awakeFromNib];
	[self.titleLabel setAdjustsFontForContentSizeCategory:YES];
	[self.quantityLabel setAdjustsFontForContentSizeCategory:YES];
	[self.cashLabel setAdjustsFontForContentSizeCategory:YES];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

-(void)setBasketItemModel:(BasketItemModel *)basketItemModel {
	_basketItemModel = basketItemModel;
	[self setupUI];
}

-(void)prepareForReuse {
	[self setBasketItemModel:nil];
}

-(void) setupUI {
	UIImage * image = [UIImage imageNamed:self.basketItemModel.item.imageName];
	if (image.size.height > image.size.width) {
		[self.mainStackView setAxis:UILayoutConstraintAxisHorizontal];
		[self.mainStackView setAlignment:UIStackViewAlignmentTop];
		[self.titleLabel setTextAlignment:NSTextAlignmentNatural];
	} else {
		[self.mainStackView setAxis:UILayoutConstraintAxisVertical];
		[self.mainStackView setAlignment:UIStackViewAlignmentCenter];
		[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
	}
	[self.imageView setImage:image];
	[self.titleLabel setText:self.basketItemModel.item.name];
	
	[self.quantityLabel setTextAlignment:self.titleLabel.textAlignment];
	[self.quantityLabel setSelectedQuantity:self.basketItemModel.quantity];
	
	[self.cashLabel setTextAlignment:self.titleLabel.textAlignment];
	[self.cashLabel setBaseAmount:[self.basketItemModel totalPrice]];
}

-(void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	[self.imageView setTintColor:tintColor];
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

-(NSString *)accessibilityValue {
	return [NSString stringWithFormat:@"%@, %@", self.quantityLabel.text, self.cashLabel.text];
}


-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];
	[self invalidateIntrinsicContentSize];
}

@end
