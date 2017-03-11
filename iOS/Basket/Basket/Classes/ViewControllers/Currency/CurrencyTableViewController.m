//
//  CurrencyTableViewController.m
//  Basket
//
//  Created by Joseph Mallah on 22.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "CurrencyTableViewController.h"
#import "CurrencyRateModelController.h"
#import "CurrencyTableViewCell.h"

@interface CurrencyTableViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSArray * searFilteredModels;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@end

@implementation CurrencyTableViewController

-(NSArray *)searFilteredModels {
	if (_searFilteredModels == nil) {
		_searFilteredModels = [CurrencyRateModelController sharedController].currencies;
	}
	return _searFilteredModels;
}

-(void)setBaseValue:(double)baseValue {
	_baseValue = baseValue;
	NSArray * visibilCells = [self.tableView visibleCells];
	for (CurrencyTableViewCell * cell in visibilCells) {
		[cell setBaseValue:baseValue];
	}
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		_baseValue = 1;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"CurrencyViewController.Title", @"The title of the view controller representing the currency choices");
	
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	[self.searchController setSearchResultsUpdater:self];
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;
	
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.activityIndicatorView.hidesWhenStopped = YES;
	UIBarButtonItem * activity = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
	UIBarButtonItem * close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeView:)];
	if (self.navigationController.viewControllers.firstObject == self) {
		self.navigationItem.rightBarButtonItem = close;
		self.navigationItem.leftBarButtonItem = activity;
	} else {
		self.navigationItem.rightBarButtonItems = @[close, activity];
	}
	
	UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(loadRates:) forControlEvents:UIControlEventValueChanged];
	[self setRefreshControl:refreshControl];
	
}

-(void)dealloc {
	[self.searchController.view removeFromSuperview];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self loadCurrencies];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[CurrencyRateModelController sharedController] cancel];
}

-(void) closeView:(id) sender {
	
	switch (self.mode) {
		case CurrencyTableViewControllerSelectCurrency:
			[self dismissViewControllerAnimated:YES completion:nil];
			break;
		case CurrencyTableViewControllerCheckout:
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
	}
}

-(void) loadCurrencies {
	[self.activityIndicatorView startAnimating];
	__weak CurrencyTableViewController * weakSelf = self;
	[[CurrencyRateModelController sharedController] loadCurrenciesIfDirty:^(NSError * error) {
		[self.activityIndicatorView stopAnimating];
		if (error != nil) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Title", @"The title of the alert when currencies fail to load") message:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Message", @"The message of the alert when currencies fail to load") preferredStyle:UIAlertControllerStyleAlert];
			__weak CurrencyTableViewController * weakSelf = self;
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Retry", @"Retry to load the currencies") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[weakSelf loadCurrencies];
			}]];
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Cancel", @"Cancel the alert") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
				[weakSelf closeView:action];
			}]];
		} else {
			[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
			[weakSelf loadRates:weakSelf];
		}
	}];
}

-(void) loadRates:(id) sender {
	[self.refreshControl beginRefreshing];
	
	[[CurrencyRateModelController sharedController] loadRatesAndIgnoreCleanliness:[sender isKindOfClass:[UIRefreshControl class]] completion:^(NSError * error) {
		[self.refreshControl endRefreshing];
		if (error != nil) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Title", @"The title of the alert when currencies fail to load") message:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Message", @"The message of the alert when currencies fail to load") preferredStyle:UIAlertControllerStyleAlert];
			__weak CurrencyTableViewController * weakSelf = self;
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Retry", @"Retry to load the currencies") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[weakSelf loadRates:weakSelf];
			}]];
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FailedToLoadCurrencies.Alert.Cancel", @"Cancel the alert") style:UIAlertActionStyleCancel handler:nil]];
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.searchController.isActive) {
		return 1;
	} else {
		return 2;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.isActive) {
		return self.searFilteredModels.count;
	} else {
		if (section == 0) {
			return 1;
		} else {
			return [CurrencyRateModelController sharedController].currencies.count - 1;
		}
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Currency" forIndexPath:indexPath];
	
	CurrencyRateModel * model;
	if (self.searchController.isActive) {
		model = self.searFilteredModels[indexPath.row];
		if ([model isEqualToCurrencyRateModel:[CurrencyRateModelController sharedController].selectedCurrency]) {
			[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
		}
	} else {
		if (indexPath.section == 0) {
			[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
			model = [CurrencyRateModelController sharedController].selectedCurrency;
		} else {
			model = [self getCurrencyRateModelFromIndexPath:indexPath];
		}
	}
	
	[cell setCurrencyRate:model];
	[cell setBaseValue:self.baseValue];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section != 0 || self.searchController.isActive) {
		CurrencyRateModel * model;
		if (self.searchController.isActive) {
			model = self.searFilteredModels[indexPath.row];
		} else {
			model = [self getCurrencyRateModelFromIndexPath:indexPath];
		}
		
		if (self.mode == CurrencyTableViewControllerSelectCurrency) {
			[[CurrencyRateModelController sharedController] setSelectedCurrency:model];
			if (self.searchController.isActive) {
				[self dismissViewControllerAnimated:NO completion:nil];
			}
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
		} else {
			if (self.searchController.isActive) {
				[[self.searchController searchBar] setText:nil];
				[self dismissViewControllerAnimated:YES completion:nil];
				[[CurrencyRateModelController sharedController] setSelectedCurrency:model];
				[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
			} else {
				NSUInteger selectedCurrencyIndex = [self selectedCurrencyIndex];
				NSInteger tappedIndex = indexPath.row;
				NSIndexPath * selectedCurrencyIndexPath = [NSIndexPath indexPathForRow:(selectedCurrencyIndex > tappedIndex)?selectedCurrencyIndex-1:selectedCurrencyIndex inSection:1];
				[[CurrencyRateModelController sharedController] setSelectedCurrency:model];
				NSIndexPath * topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
				[self.tableView beginUpdates];
				[self.tableView moveRowAtIndexPath:indexPath toIndexPath:topIndexPath];
				[self.tableView moveRowAtIndexPath:topIndexPath toIndexPath:selectedCurrencyIndexPath];
				[self.tableView endUpdates];
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					[self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
				}];
			}
		}
	}
	
}

-(CurrencyRateModel *) getCurrencyRateModelFromIndexPath: (NSIndexPath *) indexPath {
	CurrencyRateModel * model;
	NSUInteger indexOfSelectedCurrency = [self selectedCurrencyIndex];
	model = [CurrencyRateModelController sharedController].currencies[(indexPath.row < indexOfSelectedCurrency) ? indexPath.row : (indexPath.row + 1)];
	return model;
}

-(NSUInteger) selectedCurrencyIndex {
	return [[CurrencyRateModelController sharedController].currencies indexOfObject:[CurrencyRateModelController sharedController].selectedCurrency];
}

#pragma mark - Search delegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	if (searchController.searchBar.text.length == 0) {
		self.searFilteredModels = [CurrencyRateModelController sharedController].currencies;
	} else {
		self.searFilteredModels = [[CurrencyRateModelController sharedController].currencies filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
			CurrencyRateModel * model = evaluatedObject;
			NSString * textToSearch = [NSString stringWithFormat:@"%@ %@",model.displayName,model.ISOCode];
			return [textToSearch.lowercaseString containsString:searchController.searchBar.text.lowercaseString];
		}]];
	}
	[self.tableView reloadData];
}

@end
