//
//  GZStationDetailViewController.m
//  gregza
//
//  Created by Greg Cerveny on 2/9/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import "GZStationDetailViewController.h"
#import "GZProfileManager.h"
#import "GZStationManager.h"

@interface GZStationDetailViewController ()

@property (assign, nonatomic, getter=isFavorite) BOOL favorite;
@property (strong, nonatomic) GZProfileManager *profileManager;
@property (strong, nonatomic) GZStationManager *stationManager;

@end

@implementation GZStationDetailViewController

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
    
    self.nameLabel.text = self.station[@"name"];
    self.descriptionLabel.text = self.station[@"description"];
    self.descriptionLabel.preferredMaxLayoutWidth = 300.0;
    self.featuredArtistsLabel.text = [self stringFromFeaturedArtist:self.station[@"featured_artists"]];
    self.featuredArtistsLabel.preferredMaxLayoutWidth = 300.0;

    self.favorite = [self.profileManager isFavoriteStation:self.station[@"id"]];
    [self updateFavoriteButtonState];
    
    NSURL *imageURL = [NSURL URLWithString:self.station[@"cover_url"]];
    
    self.coverImageView.image = [self.stationManager imageWithURL:imageURL
                                                     defaultImage:[UIImage imageNamed:@"120x120.gif"]
                                                completionHandler:^(NSData *imageData) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.coverImageView.image = [UIImage imageWithData:imageData];
                                                    });
                                                }];

}

- (NSString *) stringFromFeaturedArtist:(NSArray *)featuredArtists {
    NSMutableArray *artistNames = [NSMutableArray arrayWithCapacity:[featuredArtists count]];
    for (NSDictionary *artist in featuredArtists) {
        [artistNames addObject:artist[@"name"]];
    }
    return [artistNames componentsJoinedByString:@", "];
}

- (IBAction)favoriteTouched:(id)sender {
    NSString *stationID = self.station[@"id"];
    self.favorite = ![self isFavorite];
    if (self.favorite) {
        [self.profileManager addFavoriteStation:stationID];
    } else {
        [self.profileManager removeFavoriteStation:stationID];
    }
    [self updateFavoriteButtonState];
}

- (void)updateFavoriteButtonState {
    if (self.favorite) {
        [self.favoriteButton setTitle:@"Remove Favorite" forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setTitle:@"Add Favorite" forState:UIControlStateNormal];
    }
}

@end
