//
//  DetailViewController.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.location) {
        [self.mapView setCenterCoordinate:self.location.coordinate animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setLocation:(CLLocation *)location{
    if (![_location isEqual:location]){
        _location = location;
        [self configureView];
    }
}

@end
