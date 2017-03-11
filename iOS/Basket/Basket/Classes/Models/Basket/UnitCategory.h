//
//  UnitCategory.h
//  Basket
//
//  Created by Joseph Mallah on 02.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParsableFromJSON.h"
#import "PredefinedModel.h"

/**
 A model representing a unit category
 */
@interface UnitCategory : NSObject <NSCopying, NSCoding, ParsableFromJSON, PredefinedModel>

/**
 The localized display title of the unit
 */
@property(nonatomic, copy) NSString * localizedUnitDisplayTitle;

/**
 A property indicating if a unit can be a fraction (YES) or is a whole number (NO)
 */
@property(nonatomic, assign) BOOL divisible;

/**
 Returns if the current object is equal to the passed object

 @param object The item to compare against
 @return @b YES if they are equal, @b NO otherwise
 */
-(BOOL) isEqualToUnitCategory:(UnitCategory *)object;

@end
