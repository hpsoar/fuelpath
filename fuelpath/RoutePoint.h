//
//  PathPoint.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RoutePoint : NSObject {
    CLLocationCoordinate2D *_locationPoints;
    NSMutableArray *_timePoints;
    
    NSInteger _pointCount;
    NSInteger _pointCapacity;
    
    NSTimeInterval _lastSaveTime;
    
    NSInteger _lastSavePointIndex;
}

- (void)addLocation:(CLLocation *)location autoSave:(BOOL)autoSave;

- (void)saveToFile;

- (void)loadFromFile;

@property (nonatomic, readonly) CLLocationCoordinate2D *locationPoints;

@property (nonatomic, readonly) NSInteger pointCount;

@property (nonatomic, strong) NSString *filename;

@property (nonatomic) NSTimeInterval autoSaveTimeInterval;

@end


