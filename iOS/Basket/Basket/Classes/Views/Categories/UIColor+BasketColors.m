//
//  UIColor+BasketColors.m
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import "UIColor+BasketColors.h"

@implementation UIColor (BasketColors)

//Grey
+(UIColor *) basketIsabelline {
	return [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0];
}

//Orange
+(UIColor *) basketSinopia {
	return [UIColor colorWithRed:215.0f/255.0f green:78.0f/255.0f blue:9.0f/255.0f alpha:1.0];
}

//Black
+(UIColor *) basketRichBlack {
	return [UIColor colorWithRed:2.0f/255.0f green:17.0f/255.0f blue:27.0f/255.0f alpha:1.0];
}

//Yellow
+(UIColor *) basketSelectiveYellow {
	return [UIColor colorWithRed:242.0f/255.0f green:187.0f/255.0f blue:5.0f/255.0f alpha:1.0];
}

//Dark Grey
+(UIColor *) basketCharlestonGreen {
	return [UIColor colorWithRed:42.0f/255.0f green:43.0f/255.0f blue:46.0f/255.0f alpha:1.0];
}

+(UIColor *)basketColorForRole:(BasketUIElementsRole)role {
	switch (role) {
		case BasketUIElementsRoleBackground:
			return [UIColor basketIsabelline];
			break;
		case BasketUIElementsRoleCardBackground:
		case BasketUIElementsRoleCellSelectedBackground:
			return [UIColor whiteColor];
			break;
		case BasketUIElementsRoleButton:
		case BasketUIElementsRoleNavigationBarElement:
		case BasketUIElementsRoleCellDetail:
			return [UIColor basketSinopia];
			break;
		default:
			return nil;
			break;
	}
}

+(UIColor *)basketHighligtedColorForRole:(BasketUIElementsRole)role {
	switch (role) {
		case BasketUIElementsRoleCardBackground:
		case BasketUIElementsRoleCellSelectedBackground:
			return [UIColor basketSelectiveYellow];
			break;
		default:
			return nil;
			break;
	}
}

+(UIColor *)basketTintColorForRole:(BasketUIElementsRole)role {
	switch (role) {
		case BasketUIElementsRoleCell:
			return [UIColor basketSinopia];
			break;
		default:
			return nil;
			break;
	}
}

@end
