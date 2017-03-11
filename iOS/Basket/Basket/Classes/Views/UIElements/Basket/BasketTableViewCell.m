//
//  BasketTableViewCell.m
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "BasketTableViewCell.h"
#import "UIView+ShadowView.h"
#import "UIColor+BasketColors.h"
#import "CardView.h"
#import "BasketModel.h"
#import "UILabel+BasketItems.h"
#import "CashLabel.h"
#import "BasketModelView.h"

@interface BasketTableViewCell ()
@property (weak, nonatomic) IBOutlet BasketModelView *basketModelView;
@property (weak, nonatomic) IBOutlet CardView *backgroundCard;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfItems;
@property (weak, nonatomic) IBOutlet CashLabel *totalAmount;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@end

@implementation BasketTableViewCell

-(NSDateFormatter *)dateFormatter {
	if (_dateFormatter == nil) {
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDoesRelativeDateFormatting:YES];
		_dateFormatter = dateFormatter;
	}
	return _dateFormatter;
}

-(void)setBasketModel:(BasketModel *)basketModel {
	if (basketModel == _basketModel) {
		return;
	} else {
		@try {
			[_basketModel removeObserver:self forKeyPath:BasketModelItemsPropoerty];
		} @catch (NSException *exception) {}
	}
	_basketModel = basketModel;
	[basketModel addObserver:self forKeyPath:BasketModelItemsPropoerty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.backgroundColor = [UIColor clearColor];
	self.backgroundCard.backgroundColor = [UIColor basketColorForRole:BasketUIElementsRoleCardBackground];
	[self.basketModelView setTintColor:self.tintColor];
	[self.basketModelView setBasketItemsColor:[UIColor blackColor]];
}

-(void)dealloc {
	@try {
		[_basketModel removeObserver:self forKeyPath:BasketModelItemsPropoerty];
	} @catch (NSException *exception) {}
}

-(void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];
	[self.basketModelView setTintColor:tintColor];
}

-(void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted) {
		[self.backgroundCard setBackgroundColor:[UIColor basketHighligtedColorForRole:BasketUIElementsRoleCardBackground]];
	} else {
		[self.backgroundCard setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleCardBackground]];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

	if (selected) {
		[self.backgroundCard setBackgroundColor:[UIColor basketHighligtedColorForRole:BasketUIElementsRoleCardBackground]];
	} else {
		[self.backgroundCard setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleCardBackground]];
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (object == _basketModel) {
		if ([keyPath isEqualToString:BasketModelItemsPropoerty]) {
			self.titleLabel.text = [self.dateFormatter stringFromDate:self.basketModel.creationDate];
			[self.numberOfItems setNumberOfItems:[self.basketModel totalNumberOfItemsWithoutDistinction]];
			[self.totalAmount setBaseAmount:self.basketModel.totalPriceInBaseCurrency];
			[self.basketModelView setBasketModel:self.basketModel];
		}
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

-(NSString *)accessibilityValue {
	return self.numberOfItems.text;
}

@end
