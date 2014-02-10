//
//  GZStationDetailViewController.h
//  gregza
//
//  Created by Greg Cerveny on 2/9/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZStationDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *featuredArtistsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) NSDictionary *station;

- (IBAction)favoriteTouched:(id)sender;

@end
