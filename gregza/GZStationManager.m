//
//  GZAPIController.m
//  gregza
//
//  Created by Greg Cerveny on 2/6/14.
//  Copyright (c) 2014 gregza. All rights reserved.
//

#define baseURL @"http://dev3.songza.com/api/1"

#import "GZStationManager.h"

@interface GZStationManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

static NSString *APIbaseURL = @"http://dev3.songza.com/api/1";

@implementation GZStationManager

- (id)init
{
    self = [super init];
    if (self) {
        [self configureSession];
    }
    return self;
}

- (void)configureSession {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 6;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:nil
                                            delegateQueue:nil];
}


- (void)allActivitiesCompletionHandler:(void(^)(NSArray *activities))completionHandler {
    NSURL *activityURL = [[NSURL URLWithString:APIbaseURL] URLByAppendingPathComponent:@"/gallery/tag/activities"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:activityURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSLog(@"%@", response);
                                                     NSError *err;
                                                     NSArray *activities = [NSJSONSerialization JSONObjectWithData:data options:
                                                                            NSJSONReadingAllowFragments error:&err];
                                                     completionHandler(activities);
                                                 }];
    
    [dataTask resume];
}


- (void)stationsWithIDs:(NSArray *)stationIDs completionHandler:(void(^)(NSArray *stations))completionHandler {
    NSURL *stationsURL = [NSURL URLWithString:[self absoluteURLStringWithStationIDs:stationIDs]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:stationsURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSLog(@"%@", response);
                                                     NSError *err;
                                                     NSArray *stations = [NSJSONSerialization JSONObjectWithData:data options:
                                                                          NSJSONReadingAllowFragments error:&err];
                                                     completionHandler(stations);
                                                 }];
    
    [dataTask resume];
}

- (NSString *)absoluteURLStringWithStationIDs:(NSArray *)stationIDs {
    NSString *queryparam = [@"?id=" stringByAppendingString:[stationIDs componentsJoinedByString:@"&id="]];
    NSString *pathComponent = [@"/station/multi" stringByAppendingString:queryparam];
    NSString *absoluteString = [APIbaseURL stringByAppendingString:pathComponent];
    return absoluteString;
}

- (UIImage *)imageWithURL:(NSURL *)imageURL defaultImage:(UIImage *)defaultImage completionHandler:(void (^)(NSData *imageData))completionHandler {
    UIImage *image;
    
    BOOL isCached = NO;
    if (isCached) {
        // image caching logic
        return image;
    }

    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:imageURL
                                                             completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                 NSError *err;
                                                                 NSFileHandle *fh = [NSFileHandle fileHandleForReadingFromURL:location
                                                                                                                        error: &err];
                                                                 NSData *imageData = [fh readDataToEndOfFile];
                                                                 completionHandler(imageData);
                                                                 
                                                                 // cache image
                                                             }];
    [downloadTask resume];
    
    return defaultImage;
}

@end
