//
//  PredefinedModel.h
//  Basket
//
//  Created by Joseph Mallah on 05.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#ifndef PredefinedModel_h
#define PredefinedModel_h

/**
 An object implementing this protocol will have a predefined model
 */
@protocol PredefinedModel <NSObject>

/**
 The predefined model

 @return A predefined model
 */
+(id) predefinedModel;

@end

#endif /* PredefinedModel_h */
