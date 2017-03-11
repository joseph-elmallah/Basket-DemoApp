//
//  UIAppearenceHelper.m
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "UIAppearenceHelper.h"
#import "UIColor+BasketColors.h"

@implementation UIAppearenceHelper

+(void) setupUIAppearence {
	[self setupNavigationBar];
}

+(void) setupNavigationBar {
	[[UINavigationBar appearance] setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleNavigationBarElement]];
	[[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor basketColorForRole:BasketUIElementsRoleNavigationBarTitle], NSForegroundColorAttributeName, nil]];
	
	[[UISearchBar appearance] setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleNavigationBarElement]];
	
	[[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setColor:[UIColor basketColorForRole:BasketUIElementsRoleNavigationBarElement]];
	
	[[UIToolbar appearance] setTintColor:[UIColor basketColorForRole:BasketUIElementsRoleNavigationBarElement]];
}

@end
