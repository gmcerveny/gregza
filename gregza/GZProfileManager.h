//
//  GZProfileManager.h
//  gregza
//
//  Created by Greg Cerveny on 2/9/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZProfileManager : NSObject

- (BOOL)isFavoriteStation:(NSString *)stationID;
- (void)addFavoriteStation:(NSString *)stationID;
- (void)removeFavoriteStation:(NSString *)stationID;

@end
