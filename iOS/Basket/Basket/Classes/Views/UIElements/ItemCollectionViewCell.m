//
//  ItemCollectionViewCell.m
//  Basket
//
//  Created by Joseph Mallah on 06.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "ItemCollectionViewCell.h"
#import "ItemModel.h"
#import "CashLabel.h"

@interface ItemCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIStackView *mainStackView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CashLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitTypeLabel;
@end

@implementation ItemCollectionViewCell

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
	[self.priceLabel setAdjustsFontForContentSizeCategory:YES];
	[self.unitTypeLabel setAdjustsFontForContentSizeCategory:YES];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

-(void)prepareForReuse {
	[self setItemModel:nil];
}

-(void) setupUI {
	UIImage * image = [UIImage imageNamed:self.itemModel.imageName];
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
	[self.titleLabel setText:self.itemModel.name];
	
	[self.priceLabel setTextAlignment:self.titleLabel.textAlignment];
	[self.priceLabel setBaseAmount:self.itemModel.price.amount];
	
	[self.unitTypeLabel setTextAlignment:self.titleLabel.textAlignment];
	[self.unitTypeLabel setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"ItemCollectionViewCell.Per", @"The keyword per before the type of the unit"), self.itemModel.price.unitCategory.localizedUnitDisplayTitle]];
}

-(void)setItemModel:(ItemModel *)itemModel {
	_itemModel = itemModel;
	[self setupUI];
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

-(NSString *) accessibilityValue {
	return [NSString stringWithFormat:@"%@ %@", self.priceLabel.text, self.unitTypeLabel.text];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];
	[self invalidateIntrinsicContentSize];
}

@end
