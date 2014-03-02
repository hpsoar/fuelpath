//
//  PathGenerator.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/1/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PathGenerator;

@protocol PathGeneratorDelegate <NSObject>

- (void)pathGenerator:(PathGenerator *)pathGenerator generatedLocation:(CLLocationCoordinate2D)location;

@end

@interface PathGenerator : NSObject

- (void)start;
- (void)stop;

@property (nonatomic, strong) id<PathGeneratorDelegate> delegate;

@property (nonatomic) float scale;

@end
