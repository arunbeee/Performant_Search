//
//  PSCity.h
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PSCity : NSObject
@property (nonatomic, strong)NSNumber *cityID;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)CLLocation *location;

+(PSCity*)fromJson:(NSDictionary*)json;
@end
