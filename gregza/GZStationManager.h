//
//  GZAPIController.h
//  gregza
//
//  Created by Greg Cerveny on 2/6/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZStationManager : NSObject 

- (void)allActivitiesCompletionHandler:(void(^)(NSArray *activities))completionHandler;
- (void)stationsWithIDs:(NSArray *)stationIDs completionHandler:(void(^)(NSArray *stations))completionHandler;

- (UIImage *)imageWithURL:(NSURL *)imageURL defaultImage:(UIImage *)defaultImage completionHandler:(void (^)(NSData *imageData))completionHandler;

@end
