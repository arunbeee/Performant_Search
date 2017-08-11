//
//  Performant_SearchTests.m
//  Performant SearchTests
//
//  Created by Arun Balakrishnan on 11/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSCitiesDataInterface.h"
@interface Performant_SearchTests : XCTestCase

@end

@implementation Performant_SearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
     XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch all the entries"];
    [[PSCitiesDataInterface sharedInstance] fetchCitiesFromJsonWithCompletion:^(BOOL success) {
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testForEmptyInput {
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch all the entries"];
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"" withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertEqual(cities.count, 209557, @"Should have 209557 entries");
            [expectation fulfill];
            
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}
- (void)testForNoInput {
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch all the entries"];
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:nil withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertEqual(cities.count, 209557, @"Should have 209557 entries");
            [expectation fulfill];
            
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}


- (void)testForNoResults{
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch no entries"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"dnd88d99" withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertEqual(cities.count, 0, @"Should have 0 entries");
            [expectation fulfill];
            
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}

- (void)testForSingleCharacterResults{
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch result for one character"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"a" withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertTrue(cities.count > 0, @"Should have 0 entries");
            [expectation fulfill];
            
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}

- (void)testForMultipleCharacterResults{
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch  result for multiple characters"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"ef" withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertTrue(cities.count > 0, @"Should have 0 entries");
            [expectation fulfill];
            
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}


- (void)testForParticularCity{
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch for particular city"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"Sydney" withCompletion:^(NSArray<PSCity *> *cities) {
            
             XCTAssertEqual(cities.count, 5, @"Should have 1 entries");
             [expectation fulfill];
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}

- (void)testForConsecutiveSearch{
    XCTestExpectation *expectation = [[XCTestExpectation alloc]initWithDescription:@"fetch for particular city"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"S" withCompletion:^(NSArray<PSCity *> *cities) {
            
            XCTAssertGreaterThan(cities.count, 0, @"Should have more than 0 entries");
            [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"Sy" withCompletion:^(NSArray<PSCity *> *cities) {
                
                XCTAssertGreaterThan(cities.count, 0, @"Should have more than 0 entries");
                
                [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:@"Syd" withCompletion:^(NSArray<PSCity *> *cities) {
                    
                    XCTAssertGreaterThan(cities.count, 0, @"Should have more than 0 entries");
                    [expectation fulfill];
                }];
            }];
        }];
    }];
    [self waitForExpectations:@[expectation] timeout:5];
}
@end
