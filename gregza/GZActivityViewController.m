//
//  GZActivityViewController.m
//  gregza
//
//  Created by Greg Cerveny on 2/6/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import "GZActivityViewController.h"
#import "GZStationListViewController.h"
#import "GZStationManager.h"

@interface GZActivityViewController ()

@property(nonatomic, strong) GZStationManager *stationManager;
@property(nonatomic, strong) NSArray *activities;

@end

@implementation GZActivityViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.stationManager = [[GZStationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.stationManager allActivitiesCompletionHandler:^(NSArray *activities) {
        self.activities = activities;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.activities = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *activity = [self.activities objectAtIndex:indexPath.row];
    cell.textLabel.text = activity[@"name"];
    cell.detailTextLabel.text = [activity[@"station_ids"] componentsJoinedByString:@", "];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GZStationListViewController *nextViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *activity = [self.activities objectAtIndex:indexPath.row];
    nextViewController.stationIDs = activity[@"station_ids"];
    [nextViewController.navigationItem setTitle:activity[@"name"]];
}

@end
