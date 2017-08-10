//
//  MasterViewController.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PSCitiesDataInterface.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray<PSCity*> *cities;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cities = [[PSCitiesDataInterface new] fetchCitiesFromJson];
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PSCity *city = self.cities[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setLocation:city.location];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PSCity *city = self.cities[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",city.name, city.country];
    return cell;
}

@end
