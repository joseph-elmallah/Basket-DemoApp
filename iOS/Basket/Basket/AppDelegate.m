//
//  AppDelegate.m
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "AppDelegate.h"
#import "UIAppearenceHelper.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	[UIAppearenceHelper setupUIAppearence];
	
	UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
	UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
	navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
	splitViewController.delegate = self;
	return YES;
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] basketModel] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
