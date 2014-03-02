//
//  RunningActivity.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/1/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "RunningActivity.h"
#import "DataStore.h"
#import "Route.h"
#import "RoutePoint.h"

@interface RunningActivity () {
    ActivityStatus _status;
}

@property (nonatomic, weak) DataStore *dataStore;

@property (nonatomic) NSInteger updateCounter;

@property (nonatomic, strong) Activity *activity;

@property (nonatomic, strong) Route *currentSubRoute;

@property (nonatomic, strong) NSMutableArray *activityRoutePoints;

@property (nonatomic, strong) RoutePoint *currentSubRoutePoints;

- (void)newSubRoute;

@end

@implementation RunningActivity

- (ActivityStatus)status {
    return _status;
}

- (id)initWithDataStore:(DataStore *)dataStore {
    self = [super init];
    if (self) {
        self.dataStore = dataStore;
        self.updateCounter = 0;
        
        _status = kActivityCreated;
    }
    return self;
}

- (void)updateLocation:(CLLocation *)location {
    if (self.status != kActivityOnGoing) return;
    
    // TODO: if the app crashed/killed before a segment is finished, it's possible that route points are stored, however the corresponding summary info in activity and sub route object are not updated:
    // Solution1: disable this autoSave feature, thus all of the data of current sub route will be lost, but the data are consistent
    // Solution2: use the summary information to filter out in consistent data points, thus some data points will be lost, but the data are consistent
    // Solution3: compute the summary on request, least data lose, but this will complicate the usage
    [self.currentSubRoutePoints addLocation:location autoSave:NO];
    self.updateCounter++;
    
    NSLog(@"%f, %f, %@", location.coordinate.longitude, location.coordinate.latitude, location.timestamp);
}

- (void)addPhoto:(ActivityPhoto *)photo {
    
}

- (void)removePhoto:(ActivityPhoto *)photo {
}

- (void)updateNote:(NSString *)note {
    
}

- (void)newSubRoute {
    if (self.dataStore == nil) {
        NSLog(@"Please provide dataStore to Activity");
        abort();
    }
    self.currentSubRoute = [self.dataStore newRouteForActivity:self.activity];
    self.currentSubRoute.pathPointFilename = [NSString stringWithFormat:@"path-points-%@.txt", [NSDate date]];
    self.currentSubRoute.beginTime = [NSDate date];
    self.currentSubRoute.endTime = [NSDate date];
    self.currentSubRoute.duration = [NSNumber numberWithDouble:0.0];
    self.currentSubRoute.distance = [NSNumber numberWithDouble:0.0];
    
    [self.dataStore saveContext];
    
    self.currentSubRoutePoints = [[RoutePoint alloc] init];
    self.currentSubRoutePoints.filename = self.currentSubRoute.pathPointFilename;

    [self.activityRoutePoints addObject:self.currentSubRoutePoints];
}

- (void)finishSubRoute {
    if (self.currentSubRoute) {
        [self.currentSubRoutePoints saveToFile];
        
        self.currentSubRoute.endTime = [NSDate date];
    
        // summary sub route duration & distance
        double totalDuration = self.currentSubRoute.endTime.timeIntervalSince1970 - self.currentSubRoute.beginTime.timeIntervalSince1970;
        self.currentSubRoute.duration = [NSNumber numberWithDouble:totalDuration];
        
        double totalDistance = 0;
        CLLocationCoordinate2D coordinate = self.currentSubRoutePoints.locationPoints[0];
        CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        for (NSInteger i = 1; i < self.currentSubRoutePoints.pointCount; ++i) {
            coordinate = self.currentSubRoutePoints.locationPoints[i];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            totalDistance += [location distanceFromLocation:oldLocation];
            oldLocation = location;
        }
        
        self.currentSubRoute.distance = [NSNumber numberWithDouble:totalDistance];
        
        // update activity duration & distance
        self.activity.endTime = [NSDate date];
        self.activity.distance = [NSNumber numberWithDouble:(totalDistance + self.activity.distance.doubleValue)];
        self.activity.duration = [NSNumber numberWithDouble:(totalDuration + self.activity.duration.doubleValue)];
        
        [self.dataStore saveContext];
    
        self.currentSubRoute = nil;
        self.currentSubRoutePoints = nil;
    }
}

- (void)start {
    if (self.status == kActivityCreated) {
        self.activity = [self.dataStore newActivity];
        
        self.activity.title = @"Default";

        self.activity.beginTime = [NSDate date];
        self.activity.endTime = self.activity.beginTime;
        
        self.activity.duration = [NSNumber numberWithDouble:0.0];
        self.activity.distance = [NSNumber numberWithDouble:0.0];
        
        [self.dataStore saveContext];
        
        [self newSubRoute];
        _status = kActivityOnGoing;
    }
}

- (void)stop {
    if (self.status == kActivityOnGoing || self.status == kActivityPaused) {
        [self finishSubRoute];
        
        _status = kActivityStopped;
    }
}

- (void)pause {
    if (self.status == kActivityOnGoing) {
        [self finishSubRoute];
        _status = kActivityPaused;
    }
}

- (void)resume {
    if (self.status == kActivityPaused) {
        [self newSubRoute];
        _status = kActivityOnGoing;
    }
}

@end
