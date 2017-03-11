//
//  ParsableFromJSON.h
//  Basket
//
//  Created by Joseph Mallah on 05.03.17.
//  Copyright © 2017 joseph.elmallah. All rights reserved.
//

#ifndef ParsableFromJSON_h
#define ParsableFromJSON_h

/**
 An object that conforms to this protocol must be able to build itself from a JSON dictionary object
 */
@protocol ParsableFromJSON <NSObject>

/**
 Initializes an object from a JSON object

 @param jsonObject The json object containing the information
 @return An object initialized with the JSON object
 */
-(instancetype) initWithJSONObject: (NSDictionary *) jsonObject;

@end


#endif /* ParsableFromJSON_h */
