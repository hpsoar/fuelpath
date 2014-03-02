//
//  PathGenerator.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/1/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "PathGenerator.h"

@interface PathGenerator ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CLLocationCoordinate2D currentLoation;
@end

@implementation PathGenerator

- (id)init {
    self = [super init];
    if (self) {
        self.currentLoation = CLLocationCoordinate2DMake(39.91403889, 116.29174722);
        self.scale = 1.0;
    }
    return self;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(generateLocation) userInfo:nil repeats:YES];
    }
    return _timer;
}
                      
- (void) generateLocation {
    float xMove = (float)rand() / INT_MAX;
    float yMove = (float)rand() / INT_MAX;
    CLLocationCoordinate2D location = self.currentLoation;
    location.latitude += yMove * self.scale;
    location.longitude += xMove * self.scale;
    [self.delegate pathGenerator:self generatedLocation:location];
    self.currentLoation = location;
}
                      

- (void)start {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stop {
    [self.timer setFireDate:[NSDate distantFuture]];
}


@end
