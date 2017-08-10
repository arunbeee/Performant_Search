//
//  PSCitiesDataInterface.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "PSCitiesDataInterface.h"

static NSString *kJsonFile = @"cities";
static NSString *kJsonExtentsion = @"json";

@implementation PSCitiesDataInterface


- (NSArray<PSCity*>*)fetchCitiesFromJson{
    NSMutableArray<PSCity*> *cities = [NSMutableArray new];
    NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:kJsonFile withExtension:kJsonExtentsion]];
    NSError *error;
    NSArray *citiesJsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for (NSDictionary *cityJson in citiesJsonObjects){
        PSCity *city = [PSCity fromJson:cityJson];
        if (city){
            [cities addObject:city];
        }
    }
    
    return [cities copy];
}
@end
