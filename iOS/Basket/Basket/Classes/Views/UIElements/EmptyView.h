//
//  EmptyView.h
//  Basket
//
//  Created by Joseph Mallah on 20.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIControl

/**
 The title of the empty view
 */
@property(nonatomic, copy) NSString * title;
/**
 The image to display in the empty view
 */
@property(nonatomic, copy) UIImage * image;

@end
