//
//  QuantityPickerView.m
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "QuantityPickerView.h"
#import "UIColor+BasketColors.h"

@interface QuantityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) UIPickerView * picker;
@property(nonatomic, strong) UIToolbar * toolbar;
@property(nonatomic, strong) NSNumberFormatter * numberFormatter;
@property(nonatomic, weak) NSLayoutConstraint * holdingContraint;
@property(nonatomic, weak) UIBarButtonItem * doneButton;

@property(nonatomic, copy) void (^completion)(BOOL, float);
@end

@implementation QuantityPickerView

-(UIPickerView *)picker {
	if (_picker == nil) {
		_picker = [[UIPickerView alloc] init];
		[_picker setShowsSelectionIndicator:YES];
		[_picker setDelegate:self];
		[_picker setDataSource:self];
	}
	return _picker;
}

-(UIToolbar *)toolbar {
	if (_toolbar == nil) {
		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		[_toolbar setBarTintColor:[UIColor whiteColor]];
		[_toolbar setTranslucent:NO];
		
		UIBarButtonItem * cancelBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(canceled)];
		UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem * doneBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
		self.doneButton = doneBarItem;
		
		NSArray * items = @[cancelBarItem, spaceItem, doneBarItem];
		[_toolbar setItems:items];
	}
	return _toolbar;
}

-(NSNumberFormatter *)numberFormatter {
	if (_numberFormatter == nil) {
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
		[_numberFormatter setZeroSymbol:@"-"];
	}
	return _numberFormatter;
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
	[self setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleBackground]];
	[self addSubview:self.toolbar];
	[self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.toolbar.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
	[[self.toolbar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
	[[self.toolbar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
	[self.toolbar setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisVertical];
	[self.toolbar setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisVertical];
	
	[self addSubview:self.picker];
	[self.picker setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self.picker.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
	[[self.picker.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
	[[self.picker.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
	[[self.picker.topAnchor constraintEqualToAnchor:self.toolbar.bottomAnchor] setActive:YES];
	[self.picker setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	[self.picker setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, -2);
	self.layer.shadowRadius = 4;
	self.layer.shadowOpacity = 0.3;
}

-(void)presentInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL, float))completion {
	self.completion = completion;
	
	[view addSubview:self];
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self validateDoneButton];
	
	[[self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor] setActive:YES];
	[[self.widthAnchor constraintEqualToAnchor:view.widthAnchor] setActive:YES];
	[[self.heightAnchor constraintEqualToConstant:200] setActive:YES];
	NSLayoutConstraint * topContraint = [self.topAnchor constraintEqualToAnchor:view.bottomAnchor];
	[topContraint setPriority:UILayoutPriorityDefaultHigh];
	[topContraint setActive:YES];
	[view setNeedsLayout];
	[view layoutIfNeeded];
	self.holdingContraint = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor];
	[self.holdingContraint setActive: YES];
	[UIView animateWithDuration:0.2 animations:^{
		[view setNeedsLayout];
		[view layoutIfNeeded];
	}];
}

-(void) canceled {
	if (self.completion) {
		self.completion(NO, 0);
	}
	[self dismiss];
}

-(void) done {
	if (self.completion) {
		self.completion(YES, [self pickerValue]);
	}
	[self dismiss];
}

-(void) dismiss {
	__weak QuantityPickerView * weakSelf = self;
	[self.superview setNeedsLayout];
	[self.superview layoutIfNeeded];
	[NSLayoutConstraint deactivateConstraints:@[self.holdingContraint]];
	[UIView animateWithDuration:0.2 animations:^{
		[weakSelf.superview setNeedsLayout];
		[weakSelf.superview layoutIfNeeded];
	} completion:^(BOOL finished) {
		[weakSelf removeFromSuperview];
		[weakSelf setCompletion:nil];
	}];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (self.isFractionAllowed) {
		return 2;
	} else {
		return 1;
	}
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return 100;
	} else if (component == 1) {
		return 10;
	}
	return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		return [self.numberFormatter stringFromNumber:[self numberForRow:row forComponent:component]];
	} else if (component == 1) {
		if (row == 0) {
			return [self.numberFormatter stringFromNumber:[self numberForRow:row forComponent:component]];
		}
		return [NSString stringWithFormat:@"%@%@",
				[self.numberFormatter decimalSeparator],
				[self.numberFormatter stringFromNumber:[self numberForRow:row forComponent:component]]
				];
	}
	return nil;
}

-(NSNumber *) numberForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		return [NSNumber numberWithInteger:row + (self.isFractionAllowed?0:1)];
	} else if (component == 1) {
		if (row == 0) {
			return [NSNumber numberWithInteger:0];
		}
		return [NSNumber numberWithInteger:(row/10.0f) * 100.0f];
	}
	return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self validateDoneButton];
}

-(float) constructFloatFromUnits: (NSInteger) units decimals: (NSInteger) decimal {
	return units + (decimal / 100.0f);
}

-(float) pickerValue {
	NSInteger units = [[self numberForRow:[self.picker selectedRowInComponent:0] forComponent:0] integerValue];
	NSInteger decimals = 0;
	if (self.isFractionAllowed) {
		decimals = [[self numberForRow:[self.picker selectedRowInComponent:1] forComponent:1] integerValue];
	}
	return [self constructFloatFromUnits:units decimals:decimals];
}

-(void) validateDoneButton {
	[self.doneButton setEnabled:[self pickerValue] > 0];
}

@end











