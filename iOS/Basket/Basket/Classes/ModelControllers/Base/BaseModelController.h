//
//  BaseModelController.h
//  Basket
//
//  Created by Joseph Mallah on 21.02.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const ModelControllerCleanlinessProperty = @"cleanliness";
static NSString * const ModelControllerBussinessProperty = @"business";

/**
 The cleanliness of the data of a model controller

 - ModelControllerStateClean: The model is clean and up to date
 - ModelControllerStateDirty: The model is dirty and needs update
 */
typedef NS_ENUM(NSInteger, ModelControllerCleanliness) {
	ModelControllerStateClean,
	ModelControllerStateDirty
};

/**
 The business of the model controller

 - ModelControllerStateIdle: The model controller is idle
 - ModelControllerStateBusy: The model controller is working
 */
typedef NS_ENUM(NSInteger, ModelControllerBusiness) {
	ModelControllerStateIdle,
	ModelControllerStateBusy
};

/**
 A base model controller for all the model controllers
 */
@interface BaseModelController : NSObject

/**
 Describes the cleaniness of the data. Data can be dirty, which means that they are not synchronized with the storage.
 */
@property(nonatomic, assign) ModelControllerCleanliness cleanliness;
/**
 The business of the model controller.
 */
@property(nonatomic, assign) ModelControllerBusiness business;

/**
 Cancel all actions
 */
-(void) cancel;

@end
