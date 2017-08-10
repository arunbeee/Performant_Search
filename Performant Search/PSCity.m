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
    /* Processing the filterable items to lowercase will help in improving search performance. The reason
     * being the elements will not be modified to lowercase string and then get filtered. If this is not done,
     * the predicates should use [cd] for  case and diacritic insensitivity
     */
    theCity.searchableName = [[theCity.name  stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
                                                                locale:[NSLocale systemLocale]] lowercaseString];
    theCity.searchableCountry = [[theCity.searchableCountry  stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
                                                                                 locale:[NSLocale systemLocale]]lowercaseString];
    return theCity;
}
@end
