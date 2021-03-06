//
//  DetailViewController.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "PSMapViewController.h"
#import <MapKit/MapKit.h>
@interface PSMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PSMapViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.location) {
        [self.mapView setCenterCoordinate:self.location.coordinate animated:YES];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 10000, 10000);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        [self.mapView addAnnotation:[[MKPlacemark alloc] initWithCoordinate:self.location.coordinate
                                                          addressDictionary:nil]];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.mapView setZoomEnabled:YES];
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
