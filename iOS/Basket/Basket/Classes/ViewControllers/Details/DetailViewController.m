//
//  DetailViewController.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "DetailViewController.h"
#import "UICollectionViewRightAlignedLayout.h"
#import "BasketModel.h"
#import "ItemModel.h"
#import "UIColor+BasketColors.h"
#import "ItemCollectionViewCell.h"
#import "CurrencyRateModelController.h"
#import "UILabel+BasketItems.h"
#import "BasketItemCollectionViewCell.h"
#import "ItemsHeaderCollectionReusableView.h"
#import "QuantityPickerView.h"
#import "CashBarButtonItem.h"
#import "CurrencyTableViewController.h"

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) UIBarButtonItem * currencyBarButton;
@property (nonatomic, strong) NSMutableArray * notSelectedItems;
@property (weak, nonatomic) IBOutlet UIToolbar *checkoutToolbar;
@property (weak, nonatomic) IBOutlet CashBarButtonItem *checkoutTotalAmount;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkoutButton;

@end

@implementation DetailViewController

- (void)configureView {
	[self updateTitle];
	[self validateCheckoutButton];
	[self updateTotalBalance];
	[self filterSelectedItems];
	[self.collectionView.collectionViewLayout invalidateLayout]; //Patch needed for collection views on iOS 10 so it doesn't crash
	[self.collectionView reloadData];
	[self.collectionView.collectionViewLayout invalidateLayout]; //Patch needed for collection views on iOS 10 so it doesn't crash
}


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor basketColorForRole:BasketUIElementsRoleBackground]];
	
	UIBarButtonItem *currencyButton = [[UIBarButtonItem alloc] initWithTitle:@"-" style:UIBarButtonItemStylePlain target:self action:@selector(currencyTapped:)];
	self.currencyBarButton = currencyButton;
	self.navigationItem.rightBarButtonItem = currencyButton;
	
	if ([[self traitCollection] layoutDirection] == UITraitEnvironmentLayoutDirectionRightToLeft) {
		[self.collectionView setCollectionViewLayout:[[UICollectionViewRightAlignedLayout alloc] init]];
	}
	
	[[CurrencyRateModelController sharedController] addObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
	
	((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).estimatedItemSize = CGSizeMake(100, 100);
	((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).headerReferenceSize = CGSizeMake(40, 40);
	[self.collectionView registerClass:[ItemsHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
	
	self.checkoutButton.title = NSLocalizedString(@"DetailsViewController.Checkout.Button.Title", @"The title of the checkout button");
	
	[self configureView];
}

-(void)dealloc {
	@try {
		[[CurrencyRateModelController sharedController] removeObserver:self forKeyPath:CurrencyRateModelControllerSelectedCurrencyProperty];
		[_basketModel removeObserver:self forKeyPath:BasketModelItemsPropoerty];
	} @catch (NSException *exception) {}
}

-(void) filterSelectedItems {
	self.notSelectedItems = [NSMutableArray arrayWithArray:[ItemModel predefinedModel]];
	NSMutableArray * basketItems = [[NSMutableArray alloc] init];
	for (NSUInteger basketItemIndex = 0; basketItemIndex < self.basketModel.countOfItems; ++basketItemIndex) {
		BasketItemModel * basketItem = [self.basketModel objectInItemsAtIndex:basketItemIndex];
		[basketItems addObject:basketItem.item];
	}
	[self.notSelectedItems removeObjectsInArray:basketItems];
}

-(void) currencyTapped:(id) sender {
	[self performSegueWithIdentifier:@"ShowCurrency" sender:self];
}

-(void) updateTitle {
	NSString * text = [NSString stringFromNumberOfItems:self.basketModel.totalNumberOfItemsWithoutDistinction];
	self.title = text;
}

-(void) validateCheckoutButton {
	if ([self.basketModel countOfItems] == 0) {
		[self.checkoutButton setEnabled:NO];
	} else {
		[self.checkoutButton setEnabled:YES];
	}
}

-(void) updateTotalBalance {
	[self.checkoutTotalAmount setBaseAmount:[self.basketModel totalPriceInBaseCurrency]];
}

- (IBAction)checkoutTapped:(id)sender {
	[self performSegueWithIdentifier:@"checkout" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
	if ([segue.identifier isEqualToString:@"checkout"]) {
		CurrencyTableViewController * destination = (CurrencyTableViewController *) segue.destinationViewController;
		[destination setBaseValue:[self.basketModel totalPriceInBaseCurrency]];
		[destination setMode:CurrencyTableViewControllerCheckout];
	}
}


#pragma mark - Managing the detail item

- (void)setBasketModel:(BasketModel *) newBasketModel {
	if (_basketModel != newBasketModel) {
		@try {
			[_basketModel removeObserver:self forKeyPath:BasketModelItemsPropoerty];
		} @catch (NSException *exception) {}
	    _basketModel = newBasketModel;
		[_basketModel addObserver:self forKeyPath:BasketModelItemsPropoerty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
		[self configureView];
		
	}
}

#pragma mark - Collection View Data Source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	[collectionView layoutIfNeeded];  //Patch needed for collection views on iOS 10 so it doesn't crash
	if (self.basketModel == nil) {
		return 0;
	} else {
		return 2;
	}
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == 0) {
		return self.basketModel.countOfItems;
	} else {
		return self.notSelectedItems.count;
	}
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		BasketItemCollectionViewCell * cell = (BasketItemCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"basketItemCell" forIndexPath:indexPath];
		[cell setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleCellDetail]];
		BasketItemModel * model = [self.basketModel objectInItemsAtIndex:indexPath.row];
		[cell setBasketItemModel:model];
		return cell;
	} else if (indexPath.section == 1) {
		ItemCollectionViewCell * cell = (ItemCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
		[cell setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleCellDetail]];
		ItemModel * model = self.notSelectedItems[indexPath.row];
		[cell setItemModel:model];
		return cell;
	}
	return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	__weak DetailViewController * weakSelf = self;
	[collectionView.collectionViewLayout invalidateLayout]; //Patch needed for collection views on iOS 10 so it doesn't crash
	if (indexPath.section == 0) {
		[self.collectionView performBatchUpdates:^{
			BasketItemModel * basketItemModel = [weakSelf.basketModel objectInItemsAtIndex:indexPath.item];
			ItemModel * itemModel = basketItemModel.item;
			[weakSelf.basketModel removeItem:itemModel];
			[weakSelf.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section]]];
			[weakSelf.notSelectedItems insertObject:itemModel atIndex:0];
			[weakSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
		} completion:nil];
	} else if (indexPath.section == 1) {
		[collectionView setUserInteractionEnabled:NO];
		ItemModel * itemModel = self.notSelectedItems[indexPath.row];
		QuantityPickerView * picker = [[QuantityPickerView alloc] init];
		[picker setFractionAllowed:itemModel.price.unitCategory.divisible];
		[picker presentInView:self.view animated:YES completion:^(BOOL success, float quantity) {
			[collectionView setUserInteractionEnabled:YES];
			if (success == false) {
				return;
			}
			[weakSelf.collectionView performBatchUpdates:^{
				[weakSelf.notSelectedItems removeObjectAtIndex:indexPath.row];
				[weakSelf.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section]]];
				BasketItemModel * basketItemModel = [[BasketItemModel alloc] init];
				basketItemModel.item = itemModel;
				basketItemModel.quantity = quantity;
				[weakSelf.basketModel insertObject:basketItemModel inItemsAtIndex:0];
				[weakSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
			} completion:nil];
		}];
	}
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		ItemsHeaderCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
		if (indexPath.section == 0) {
			[header setTitle:NSLocalizedString(@"DetailsViewController.InBasketItem.Section.Header", @"The header for the items in the basket")];
		} else if (indexPath.section == 1) {
			[header setTitle:NSLocalizedString(@"DetailsViewController.NotInBasketItem.Section.Header", @"The header for the items not in the basket")];
		}
		return header;
	}
	return nil;
}

#pragma mark Flow Delegate
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(10, 20, 20, 20);
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (object == [CurrencyRateModelController sharedController]) {
		if ([keyPath isEqualToString:CurrencyRateModelControllerSelectedCurrencyProperty]) {
			CurrencyRateModel * selectedCurrency = [change objectForKey:NSKeyValueChangeNewKey];
			[self.currencyBarButton setTitle: selectedCurrency.ISOCode];
			[((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout) invalidateLayout];
		}
	} else if (object == _basketModel) {
		if ([keyPath isEqualToString:BasketModelItemsPropoerty]) {
			[self updateTitle];
			[self validateCheckoutButton];
			[self updateTotalBalance];
		}
	}
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.collectionView.collectionViewLayout invalidateLayout];
		[self.collectionView layoutIfNeeded];
	}];
}

@end


















