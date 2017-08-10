//
//  MasterViewController.m
//  Performant Search
//
//  Created by Arun Balakrishnan on 10/08/17.
//  Copyright © 2017 Zedomo. All rights reserved.
//

#import "PSCitiesViewController.h"
#import "PSMapViewController.h"
#import "PSCitiesDataInterface.h"

@interface PSCitiesViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray<PSCity*> *filteredCities;
@property (nonatomic, assign)NSInteger lastRow;
@property (nonatomic, strong)UILabel *backgroundLabel;
@end

@implementation PSCitiesViewController

static const int  BATCH_SIZE = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    _filteredCities = [NSMutableArray new];
    NSLog(@"Loading data......");
    [self fetchDataForSearchString:@""];
    self.backgroundLabel = [[UILabel alloc]initWithFrame:self.tableView.frame];
    self.backgroundLabel.text = @"Loading cities...";
    self.backgroundLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.backgroundView =self.backgroundLabel;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.searchBar.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)moveToTopAction:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, -self.topLayoutGuide.length) animated:YES];
}

- (IBAction)moveToLastAction:(id)sender {
    if (self.filteredCities.count > 0){
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.filteredCities.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PSCity *city = self.filteredCities[indexPath.row];
        PSMapViewController *controller = (PSMapViewController *)[[segue destinationViewController] topViewController];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@, %@", indexPath.row + 1,city.name, city.country];
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
    [PSCitiesDataInterface sharedInstance].batchSize = BATCH_SIZE;
    [[PSCitiesDataInterface sharedInstance] fetcchCitiesForSearchString:searchText withCompletion:^(NSArray<PSCity *> *theCities) {
        [weakSelf.filteredCities removeAllObjects];
        [weakSelf.filteredCities addObjectsFromArray: theCities];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
            if(theCities.count == 0){
                weakSelf.backgroundLabel.text = @"No results found.";
            } else{
                weakSelf.backgroundLabel.text = @"";
                weakSelf.searchBar.hidden = NO;
            }
            weakSelf.title = [NSString stringWithFormat:@"%@ (%lu)",@"Cities", theCities.count];
        });
        
    }];

}
@end
