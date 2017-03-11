//
//  CurrencyRateModelController.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CurrencyRateModelController.h"
#import "Endpoint.h"
#import "ResponseParser.h"

@interface CurrencyRateModelController ()
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSURLSessionDataTask * currentDataTask;
@end


@implementation CurrencyRateModelController
@synthesize currencies = _currencies;

+ (CurrencyRateModelController *) sharedController {
	static CurrencyRateModelController * _sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] init];
		_sharedInstance.currencies = @[[_sharedInstance defaultCurrency]];
		_sharedInstance.selectedCurrency = _sharedInstance.currencies.firstObject;
	});
	return _sharedInstance;
}

-(CurrencyRateModel *) defaultCurrency {
	CurrencyRateModel * model = [[CurrencyRateModel alloc] init];
	model.ISOCode = @"USD";
	model.displayName = @"United States Dollars";
	model.exchangeRate = 1;
	return model;
}

-(NSURLSession *) session {
	if (_session == nil) {
		_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
		[_session setSessionDescription:@"Currency Rates Session"];
	}
	return _session;
}

-(NSArray *) currencies {
	if (_currencies == nil) {
		_currencies = @[];
	}
	return _currencies;
}

-(void)setCurrencies:(NSArray *)currencies {
	_currencies = currencies;
	for (CurrencyRateModel * currency in currencies) {
		if ([currency isEqualToCurrencyRateModel:self.selectedCurrency]) {
			self.selectedCurrency = currency;
			break;
		}
	}
}

-(void)dealloc {
	[self.session invalidateAndCancel];
}

-(void)loadCurrenciesIfDirty:(void (^)(NSError *))completion {
	if (self.cleanliness == ModelControllerStateClean) {
		completion(nil);
	} else {
		[self loadCurrencies:completion];
	}
}

-(void)loadCurrencies:(void (^)(NSError *))completion {
	
	[self setBusiness:ModelControllerStateBusy];
	
	Endpoint * supportedCurrenciesEndpoint = [Endpoint SupportedCurrenciesEndpoint];
	NSMutableURLRequest * request = [supportedCurrenciesEndpoint requestWithParameters:nil];
	__weak CurrencyRateModelController *weakSelf = self;
	self.currentDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		SupportedCurrenciesResponseParser * parser = [[SupportedCurrenciesResponseParser alloc] init];
		[parser parseData:data response:response completion:^(id object, NSError *error) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[weakSelf setBusiness:ModelControllerStateIdle];
				if (error != nil) {
					completion(error);
				} else {
					weakSelf.currencies = object;
					completion(nil);
				}
			}];
		}];
	}];
	[self.currentDataTask resume];
	
}

-(void)loadRatesAndIgnoreCleanliness:(BOOL)ignoreCleanliness completion:(void (^)(NSError *))completion {
	
	if (self.cleanliness == ModelControllerStateClean && !ignoreCleanliness) {
		completion(nil);
		return;
	}
	
	[self setBusiness:ModelControllerStateBusy];
	
	Endpoint * supportedCurrenciesEndpoint = [Endpoint RatesEndpoint];
	NSMutableURLRequest * request = [supportedCurrenciesEndpoint requestWithParameters:nil];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	__weak CurrencyRateModelController *weakSelf = self;
	
	self.currentDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		RatesResponseParser * parser = [[RatesResponseParser alloc] init];
		[parser parseData:data response:response completion:^(id object, NSError *error) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[weakSelf setBusiness:ModelControllerStateIdle];
				if (error != nil) {
					completion(error);
				} else {
					NSDictionary * ratesRaw = object;
					for (CurrencyRateModel * model in weakSelf.currencies) {
						NSNumber * rate = ratesRaw[model.ISOCode];
						[model setExchangeRate:[rate doubleValue]];
					}
					weakSelf.cleanliness = ModelControllerStateClean;
					completion(nil);
				}
			}];
		}];
	}];
	[self.currentDataTask resume];
}

-(void)cancel {
	[self.currentDataTask cancel];
	self.currentDataTask = nil;
}

@end
















