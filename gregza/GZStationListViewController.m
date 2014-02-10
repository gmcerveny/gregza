//
//  GZStationListViewController.m
//  gregza
//
//  Created by Greg Cerveny on 2/6/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import "GZStationListViewController.h"
#import "GZStationDetailViewController.h"
#import "GZStationManager.h"
#import "GZProfileManager.h"

@interface GZStationListViewController ()

@property (nonatomic, strong) NSArray *stations;
@property (strong, nonatomic) GZStationManager *stationManager;
@property (strong, nonatomic) GZProfileManager *profileManager;

@end

@implementation GZStationListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileManager = [[GZProfileManager alloc] init];
        self.stationManager = [[GZStationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.stationManager stationsWithIDs:self.stationIDs completionHandler:^(NSArray *stations) {
        self.stations = stations;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.stations = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Station";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *station = [self.stations objectAtIndex:indexPath.row];
    cell.textLabel.text = station[@"name"];
    cell.detailTextLabel.text = station[@"description"];

    NSURL *imageURL = [NSURL URLWithString:station[@"cover_url"]];
    
    cell.imageView.image = [self.stationManager imageWithURL:imageURL
                                                defaultImage:[UIImage imageNamed:@"120x120.gif"]
                                           completionHandler:^(NSData *imageData) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
                                                   updateCell.imageView.image = [UIImage imageWithData:imageData];
                                               });
                                           }];

    return cell;
}



#pragma mark UITableView Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *station = [self.stations objectAtIndex:indexPath.row];
    if ([self.profileManager isFavoriteStation: station[@"id"] ]) {
        [cell setBackgroundColor:[UIColor greenColor]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GZStationDetailViewController *nextController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    nextController.station = [self.stations objectAtIndex:indexPath.row];
}

@end
