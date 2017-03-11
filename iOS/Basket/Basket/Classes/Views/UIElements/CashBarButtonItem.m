//
//  CashBarButtonItem.m
//  Basket
//
//  Created by Joseph Mallah on 09.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CashBarButtonItem.h"
#import "CurrencyRateModelController.h"

@implementation CashBarButtonItem
static NSNumberFormatter * _numberFormatter;

-(NSNumberFormatter *) currencyFormatter {
	if (_numberFormatter == nil) {
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	}
	return _numberFormatter;
}

-(void)awakeFromNib {
	[super awakeFromNib];
	[self setup];
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

-(void) updateConvertedAmount {
	double displayAmount = self.baseAmount * [[CurrencyRateModelController sharedController].selectedCurrency exchangeRate];
	NSString * amountText = [[self currencyFormatter] stringFromNumber:[NSNumber numberWithDouble:displayAmount]];
	self.title = amountText;
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













