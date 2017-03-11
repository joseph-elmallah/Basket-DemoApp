//
//  ItemsHeaderCollectionReusableView.h
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A reusable header for a collection view
 */
@interface ItemsHeaderCollectionReusableView : UICollectionReusableView

/**
 The title to display in the header
 */
-(NSString *)title;

/**
 Sets the title to display

 @param title The title to display
 */
-(void)setTitle:(NSString *)title;

@end
