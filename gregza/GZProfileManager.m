//
//  GZProfileManager.m
//  gregza
//
//  Created by Greg Cerveny on 2/9/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import "GZProfileManager.h"

@interface GZProfileManager()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation GZProfileManager

- (id)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self.defaults registerDefaults:@{@"favorites": @[]}];
    }
    return self;
}

- (BOOL)isFavoriteStation:(NSString *)stationID {
    NSArray *favorites = [self.defaults arrayForKey:@"favorites"];
    return [favorites containsObject:stationID];
}

- (void)addFavoriteStation:(NSString *)stationID {
    NSMutableArray *favorites = [[self.defaults arrayForKey:@"favorites"] mutableCopy];
    [favorites addObject:stationID];
    [self.defaults setObject:favorites forKey:@"favorites"];
}

- (void)removeFavoriteStation:(NSString *)stationID {
    NSMutableArray *favorites = [[self.defaults arrayForKey:@"favorites"] mutableCopy];
    [favorites removeObject:stationID];
    [self.defaults setObject:favorites forKey:@"favorites"];
}

@end
