//
//  MasterViewController.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "UIColor+BasketColors.h"
#import "EmptyView.h"
#import "BasketTableViewCell.h"

#import "BasketModelController.h"
#import "CurrencyRateModelController.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BasketModelController * basketModelController;

@property (nonatomic, weak) UIBarButtonItem * currencyBarButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicator;
@property (weak, nonatomic) EmptyView * emptyView;

@end

@implementation MasterViewController

#pragma mark - Initializers

-(BasketModelController *) basketModelController {
	if (_basketModelController == nil) {
		_basketModelController = [[BasketModelController alloc] init];
	}
	return _basketModelController;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		self.title = NSLocalizedString(@"MasterVC.NavigationBar.Title", @"The title of the view controller");
	}
	return self;
}

-(void)dealloc {
	@try {
		[_basketModelController removeObserver:self forKeyPath:ModelControllerBussinessProperty];
		[_basketModelController removeObserver:self forKeyPath:BasketModelControllerBasketsProperty];
		[[CurrencyRateModelController sharedController] removeObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty];
	} @catch (NSException *exception) {}
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.view setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleBackground]];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	UIBarButtonItem *currencyButton = [[UIBarButtonItem alloc] initWithTitle:@"-" style:UIBarButtonItemStylePlain target:self action:@selector(currencyTapped:)];
	self.currencyBarButton = currencyButton;
	self.navigationItem.rightBarButtonItems = @[addButton, currencyButton];
	
	[[CurrencyRateModelController sharedController] addObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
	
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 340;
}


- (void)viewWillAppear:(BOOL)animated {
	if (self.splitViewController.isCollapsed) {
		[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:false];
	}
	
	[self setEmpty:(self.basketModelController.countOfBaskets == 0)];
	
	[self.basketModelController addObserver:self forKeyPath:ModelControllerBussinessProperty options:NSKeyValueObservingOptionNew context:nil];
	[self.basketModelController addObserver:self forKeyPath:BasketModelControllerBasketsProperty options:NSKeyValueObservingOptionNew context:nil];
	[super viewWillAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	@try {
		[self.basketModelController removeObserver:self forKeyPath:ModelControllerBussinessProperty];
		[self.basketModelController removeObserver:self forKeyPath:BasketModelControllerBasketsProperty];
	} @catch (NSException *exception) {}
}

#pragma mark - Editing

-(void) currencyTapped:(id) sender {
	[self performSegueWithIdentifier:@"ShowCurrency" sender:self];
}

- (void)insertNewObject:(id)sender {
	BasketModel * basket = [[BasketModel alloc] init];
	[self.basketModelController addBasketsObject:basket];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	[self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
	for (UIBarButtonItem * item in self.navigationItem.rightBarButtonItems) {
		[item setEnabled:!editing];
	}
}

-(void)setEmpty: (BOOL) empty {
	if (empty && self.emptyView.superview == nil) {
		EmptyView * view = [[EmptyView alloc] initWithFrame:CGRectZero];
		[view setTitle:NSLocalizedString(@"MasterVC.EmptyView.AddTitle", "The title of the empty view in the middle of the screen when no baskets are available")];
		[view setImage:[UIImage imageNamed:@"empty-basket"]];
		[view addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventTouchUpInside];
		[view setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleButton]];
		[view setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleCardBackground]];
		
		[self.view addSubview:view];
		[view setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
		[[view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
		[[view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.readableContentGuide.leadingAnchor] setActive:YES];
		[[view.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.readableContentGuide.trailingAnchor] setActive:YES];
		
		self.emptyView = view;
		[self setEditing:NO animated:YES];
		[self.editButtonItem setEnabled:NO];
	} else if(empty == NO) {
		[self.emptyView removeFromSuperview];
		[self.editButtonItem setEnabled:YES];
	}
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (object == self.basketModelController) {
		if ([keyPath isEqualToString:ModelControllerBussinessProperty]) {
			ModelControllerBusiness business = (ModelControllerBusiness) change[NSKeyValueChangeNewKey];
			switch (business) {
				case ModelControllerStateIdle:
					[self.activityIndicator stopAnimating];
					break;
				case ModelControllerStateBusy:
					[self.activityIndicator startAnimating];
			}
		} else if ([keyPath isEqualToString:BasketModelControllerBasketsProperty]) {
			[self setEmpty:(self.basketModelController.countOfBaskets == 0)];
			NSNumber * kind = [change objectForKey:NSKeyValueChangeKindKey];
			NSIndexSet * changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
			NSIndexPath * path = [NSIndexPath indexPathForRow:changeIndexes.firstIndex inSection:0];
			if ([kind integerValue] == NSKeyValueChangeInsertion) {
				[self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
			} else if ([kind integerValue] == NSKeyValueChangeRemoval) {
				[self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
			} else if ([kind integerValue] == NSKeyValueChangeReplacement) {
				[self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
			}
		}
	} else if (object == [CurrencyRateModelController sharedController]) {
		if ([keyPath isEqualToString:CurrencyRateModelControllerSelectedCurrencyProperty]) {
			CurrencyRateModel * selectedCurrency = [change objectForKey:NSKeyValueChangeNewKey];
			[self.currencyBarButton setTitle:selectedCurrency.ISOCode];
		}
	}
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		BasketModel *basket = [self.basketModelController objectInBasketsAtIndex:indexPath.row];
	    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
	    [controller setBasketModel:basket];
	    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	    controller.navigationItem.leftItemsSupplementBackButton = YES;
		self.detailViewController = controller;
	}
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.basketModelController.countOfBaskets;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BasketTableViewCell *cell = (BasketTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	BasketModel *basket = [self.basketModelController objectInBasketsAtIndex:indexPath.row];
	[cell setTintColor:[UIColor basketTintColorForRole:BasketUIElementsRoleCell]];
	[cell setBasketModel:basket];
	
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.basketModelController removeObjectFromBasketsAtIndex: indexPath.row];
		[self.detailViewController setBasketModel:nil];
	}
}


@end
