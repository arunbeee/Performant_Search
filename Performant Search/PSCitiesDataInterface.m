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

@interface PSCitiesDataInterface()

@property (nonatomic, strong)NSArray *cities;
@property (nonatomic, strong)NSArray *filteredCities;
@property (nonatomic, assign)NSInteger currentBatch;
@end

@implementation PSCitiesDataInterface

+(instancetype)sharedInstance{
    static PSCitiesDataInterface *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PSCitiesDataInterface new];
        sharedInstance.batchSize = 0;
        sharedInstance.currentBatch = 0;
        sharedInstance.cities = @[];
        sharedInstance.filteredCities = @[];
    });
    return sharedInstance;
}

- (void)fetchCitiesFromJsonWithCompletion:(void(^)(BOOL))success{
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        if (weakSelf.cities.count == 0){
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
        weakSelf.cities = (NSArray*)cities;
            if (error){
                success(NO);
            } else {
                success(YES);
            }
        } else {
            success(YES);
        }
    });
}

- (void)fetcchCitiesForSearchString:(NSString*)searchString withCompletion:(void(^)(NSArray<PSCity*>*))completion{
    __weak typeof(self)weakSelf = self;
    
    [self fetchCitiesFromJsonWithCompletion:^(BOOL success) {
        if (success){
            if (searchString && searchString.length > 0){
            NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"searchableName beginswith %@", [searchString lowercaseString]];
            NSPredicate *countryPredicate = [NSPredicate predicateWithFormat:@"searchableCountry beginswith %@", [searchString lowercaseString]];
            NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[cityPredicate, countryPredicate]];
            weakSelf.filteredCities = [weakSelf.cities filteredArrayUsingPredicate:compoundPredicate];
            } else {
                weakSelf.filteredCities = weakSelf.cities;
            }
            NSSortDescriptor *citySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"searchableName" ascending:YES];
            NSSortDescriptor *countrySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"searchableCountry" ascending:YES];
            weakSelf.filteredCities  = [weakSelf.filteredCities sortedArrayUsingDescriptors:@[citySortDescriptor, countrySortDescriptor]];
            completion([weakSelf nextBatch]);
        }
    }];
}
- (NSArray<PSCity*>*)nextBatch{
    if (self.batchSize > 0 && self.currentBatch > -1 && self.filteredCities.count > 0){
        self.currentBatch++;
        NSInteger leftOverItems = self.filteredCities.count - self.currentBatch * self.batchSize;
        NSInteger batchEnd = leftOverItems > self.batchSize ? self.batchSize : leftOverItems;
        return [self.filteredCities subarrayWithRange:NSMakeRange(self.currentBatch * self.batchSize, batchEnd)];
        
    } else {
        return self.filteredCities;
    }
}
@end
