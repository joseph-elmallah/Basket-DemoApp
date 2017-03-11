//
//  DetailViewController.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasketModel;
@class BasketModelController;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) BasketModel *basketModel;

@end

