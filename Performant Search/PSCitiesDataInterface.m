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
- (void)fetchCitiesFromJsonWithCompletion:(void(^)(NSArray<PSCity*>*))completion{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableArray<PSCity*> *cities = [NSMutableArray new];
        NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:kJsonFile withExtension:kJsonExtentsion]];
        NSError *error;
        NSArray *citiesJsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        int lastBatch = citiesJsonObjects.count % 50;
        int currentBatch = 0;
        int batchSize = 50;
        long maxDivisor = citiesJsonObjects.count / batchSize;
        for (NSDictionary *cityJson in citiesJsonObjects){
            PSCity *city = [PSCity fromJson:cityJson];
            if (city){
                [cities addObject:city];
                if (citiesJsonObjects.count < batchSize || cities.count % batchSize == 0 || (currentBatch == maxDivisor &&  cities.count % batchSize == lastBatch)){
                    completion([cities copy]);
                    currentBatch++;
                    [cities removeAllObjects];
                    NSLog(@"Current Batch:%d", currentBatch);
                }
            }
        }
        cities = nil;
    });
}
@end
