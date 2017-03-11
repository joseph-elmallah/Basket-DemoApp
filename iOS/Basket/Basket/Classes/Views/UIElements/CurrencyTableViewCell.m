//
//  CurrencyTableViewCell.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CurrencyTableViewCell.h"
#import "CashLabel.h"
#import "CurrencyRateModel.h"
#import "CurrencyRateModelController.h"
#import "UIColor+BasketColors.h"

@interface CurrencyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellCashLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndiator;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;
@property (nonatomic, strong) CurrencyRateModel * currencyRateModel;
@end

@implementation CurrencyTableViewCell

-(NSNumberFormatter *) numberFormatter {
	if (_numberFormatter == nil) {
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[_numberFormatter setMinimumFractionDigits:1];
		[_numberFormatter setMaximumFractionDigits:3];
	}
	return _numberFormatter;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_baseValue = 1;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		_baseValue = 1;
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[[CurrencyRateModelController sharedController] addObserver:self forKeyPath:ModelControllerBussinessProperty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
	[self.cellCashLabel setTextColor:[UIColor basketColorForRole:BasketUIElementsRoleCellDetail]];
	[self setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleCellSelectedBackground]];
	
	[self.cellTitleLabel setAdjustsFontForContentSizeCategory:YES];
	[self.cellCashLabel setAdjustsFontForContentSizeCategory:YES];
}

-(void)dealloc {
	@try {
		[self.currencyRateModel removeObserver:self forKeyPath:CurrencyRateModelExchangeRateProperty];
		[[CurrencyRateModelController sharedController] removeObserver:self forKeyPath:ModelControllerBussinessProperty];
	} @catch (NSException *exception) {}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
	if (selected) {
		[self setBackgroundColor:[UIColor basketHighligtedColorForRole:BasketUIElementsRoleCellSelectedBackground]];
	} else {
		[self setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleCellSelectedBackground]];
	}
}

-(void)prepareForReuse {
	@try {
		[self.currencyRateModel removeObserver:self forKeyPath:CurrencyRateModelExchangeRateProperty];
	} @catch (NSException *exception) {}
}

-(void)setCurrencyRate:(CurrencyRateModel *)currencyRate {
	if (self.currencyRateModel != nil) {
		@try {
			[self.currencyRateModel removeObserver:self forKeyPath:CurrencyRateModelExchangeRateProperty];
		} @catch (NSException *exception) {}
	}
	self.currencyRateModel = currencyRate;
	self.cellTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", currencyRate.ISOCode, currencyRate.displayName];
	[currencyRate addObserver:self forKeyPath:CurrencyRateModelExchangeRateProperty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([object isKindOfClass:[CurrencyRateModel class]]) {
		if ([keyPath isEqualToString:CurrencyRateModelExchangeRateProperty]) {
			double newValue = [(NSNumber *)[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
			[self updateRateLabel:newValue];
		}
	} else if ([object isEqual:[CurrencyRateModelController sharedController]]) {
		if ([keyPath isEqualToString:ModelControllerBussinessProperty]) {
			if ([CurrencyRateModelController sharedController].business == ModelControllerStateBusy) {
				[self.cellCashLabel setHidden:YES];
				[self.activityIndiator startAnimating];
			} else {
				[self.cellCashLabel setHidden:NO];
				[self.activityIndiator stopAnimating];
			}
		}
	}
}

-(void) updateRateLabel: (double) rate {
	if (rate > 0.00001) {
		self.cellCashLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:rate * self.baseValue]];
	} else {
		self.cellCashLabel.text = nil;
	}
}

-(UILabel *)textLabel {
	return self.cellTitleLabel;
}

-(UILabel *)detailTextLabel {
	return self.cellCashLabel;
}

-(NSString *)accessibilityLabel {
	return self.textLabel.text;
}

-(NSString *)accessibilityValue {
	return self.detailTextLabel.text;
}

@end
