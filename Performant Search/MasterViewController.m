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
#define  BATCH_SIZE 0
@interface MasterViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray<PSCity*> *filteredCities;
@property (nonatomic, assign)NSInteger lastRow;
@property (nonatomic, strong)UILabel *backgroundLabel;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _filteredCities = [NSMutableArray new];
    NSLog(@"Loading data......");
    [self fetchDataForSearchString:@""];
    self.backgroundLabel = [[UILabel alloc]initWithFrame:self.tableView.frame];
    self.backgroundLabel.text = @"Loading data...";
    self.backgroundLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.backgroundView =self.backgroundLabel;
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
        PSCity *city = self.filteredCities[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setLocation:city.location];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.title = [NSString stringWithFormat:@"%@, %@", city.name, city.country];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PSCity *city = self.filteredCities[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",city.name, city.country];
    self.lastRow = indexPath.row;
    return cell;
}

#pragma mark - Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fetchDataForSearchString:searchText];
}

#pragma mark - Helpers

- (void)fetchDataForSearchString:(NSString*)searchText{
    __weak typeof(self)weakSelf = self;
    [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:searchText withCompletion:^(NSArray<PSCity *> *theCities) {
        [weakSelf.filteredCities removeAllObjects];
        [weakSelf.filteredCities addObjectsFromArray: theCities];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            weakSelf.backgroundLabel.text = @"No results found.";
        });
        
    }];

}
@end