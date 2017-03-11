//
//  CashLabel.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CashLabel.h"
#import "CurrencyRateModelController.h"
#import "PriceModel.h"

@implementation CashLabel
static NSNumberFormatter * _numberFormatter;

-(NSNumberFormatter *) currencyFormatter {
	if (_numberFormatter == nil) {
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	}
	return _numberFormatter;
}

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

-(void)dealloc {
	@try {
		[[CurrencyRateModelController sharedController] removeObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty];
	} @catch (NSException *exception) {}
}

-(void)setBaseAmount:(double)baseAmount {
	_baseAmount = baseAmount;
	[self updateConvertedAmount];
}

-(void)setSuffix:(NSString *)suffix {
	_suffix = suffix;
	[self updateConvertedAmount];
}

-(void)setPriceModel:(PriceModel *)priceModel {
	[self setBaseAmount:priceModel.amount];
	[self setSuffix:priceModel.unitCategory.localizedUnitDisplayTitle];
}

-(void) updateConvertedAmount {
	double displayAmount = self.baseAmount * [[CurrencyRateModelController sharedController].selectedCurrency exchangeRate];
	NSString * amountText = [[self currencyFormatter] stringFromNumber:[NSNumber numberWithDouble:displayAmount]];
	if (self.suffix != nil) {
		self.text = [NSString stringWithFormat:@"%@ / %@", amountText, self.suffix];
	} else {
		self.text = amountText;
	}
}

-(void) setup {
	[[CurrencyRateModelController sharedController] addObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (object == [CurrencyRateModelController sharedController]) {
		if ([keyPath isEqualToString:CurrencyRateModelControllerSelectedCurrencyProperty]) {
			[[self currencyFormatter] setCurrencyCode:[[CurrencyRateModelController sharedController].selectedCurrency ISOCode]];
			[self updateConvertedAmount];
		}
	}
}

@end







