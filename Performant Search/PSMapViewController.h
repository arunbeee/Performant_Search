//
//  DetailViewController.h
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;

@interface PSMapViewController : UIViewController

@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

