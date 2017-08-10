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
@property (nonatomic, assign)NSInteger batchSize; //Should be a positive integer . 0 will return all the objects. Default is 0
+ (instancetype)sharedInstance;
- (NSArray<PSCity*>*)nextBatch; // Sends next batch if `batchSize` is greater than 0
- (void)fetchCitiesFromJsonWithCompletion:(void(^)(BOOL))success;
- (void)fetcchCitiesForSearchString:(NSString*)searchString withCompletion:(void(^)(NSArray<PSCity*>*))completion;
- (instancetype)init NS_UNAVAILABLE ;

@end
