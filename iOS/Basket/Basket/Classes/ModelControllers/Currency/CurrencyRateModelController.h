//
//  CurrencyRateModelController.h
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelController.h"
#import "CurrencyRateModel.h"

static NSString * const CurrencyRateModelControllerCurrenciesProperty = @"currencies";
static NSString * const CurrencyRateModelControllerSelectedCurrencyProperty = @"selectedCurrency";

/**
 A model controller that manages the currencies
 */
@interface CurrencyRateModelController : BaseModelController

/**
 Returns a shared instance of the controller

 @return The shared instance
 */
+(CurrencyRateModelController *) sharedController;

/**
 The selected currency rate
 */
@property(nonatomic, weak) CurrencyRateModel * selectedCurrency;

/**
 The supported currencies
 */
@property(nonatomic, strong) NSArray * currencies;

/**
 Loads the currency asynchronously

 @param completion The completion block
 */
-(void) loadCurrencies: (void (^)(NSError *)) completion;

/**
 Loads the currency asynchronously if dirty
 
 @param completion The completion block
 */
-(void) loadCurrenciesIfDirty: (void (^)(NSError *)) completion;

/**
 Loads the rates asynchronously

 @param ignoreCleanliness Ignores the cleanliness and forces a load
 @param completion The completion block
 */
-(void) loadRatesAndIgnoreCleanliness:(BOOL) ignoreCleanliness completion: (void (^)(NSError *)) completion;

@end
