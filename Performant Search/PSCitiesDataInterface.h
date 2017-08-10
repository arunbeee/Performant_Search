//
//  PSCitiesDataInterface.h
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSCity.h"
@interface PSCitiesDataInterface : NSObject
- (NSArray<PSCity*>*)fetchCitiesFromJson;
@end
