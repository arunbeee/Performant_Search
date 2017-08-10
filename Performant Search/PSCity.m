//
//  PSCity.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "PSCity.h"

static const NSString *kCountryKey = @"country";
static const NSString *kNameKey = @"name";
static const NSString *kIDKey = @"_id";
static const NSString *kCoordinateKey = @"coord";
static const NSString *kLonKey = @"lon";
static const NSString *kLatKey = @"lat";
@implementation PSCity

+(PSCity*)fromJson:(NSDictionary *)json{
    PSCity *theCity = [PSCity new];
    theCity.name = json[kNameKey];
    theCity.country = json[kCountryKey];
    theCity.cityID = json[kIDKey];
    NSDictionary *coordinates = json[kCoordinateKey];
    double latitude = [coordinates[kLatKey] doubleValue];
    double longitude = [coordinates[kLonKey] doubleValue];
    theCity.location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    return theCity;
}
@end
