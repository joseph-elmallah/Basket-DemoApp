//
//  QuantityPickerView.h
//  Basket
//
//  Created by Joseph Mallah on 07.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A quantity picker view to select quantities of items
 */
@interface QuantityPickerView : UIView

/**
 If the picker can have a fraction
 */
@property (nonatomic, assign, getter=isFractionAllowed) BOOL fractionAllowed;

/**
 Presents the picker on the specified view and call the completion block once finished

 @param view A view controller to present ontop
 @param animated If the presentation is animated
 @param completion A completion block called once the user has canceled (1st paramter false) or has placed a value (1st param true)
 */
-(void) presentInView: (UIView *) view animated: (BOOL) animated completion: (void (^)(BOOL, float)) completion;

@end
