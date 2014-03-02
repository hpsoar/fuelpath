//
//  RunningActivity.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/1/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ActivityPhoto.h"
#import "DataStore.h"

typedef NS_ENUM(NSInteger, ActivityStatus) {
    kActivityStopped,
    kActivityOnGoing,
    kActivityPaused,
    kActivityCreated
};

@interface RunningActivity : NSObject

- (id)initWithDataStore:(DataStore *)dataStore;

- (void)updateLocation:(CLLocation *)location;

- (void)addPhoto:(ActivityPhoto *)photo;

- (void)removePhoto:(ActivityPhoto *)photo;

- (void)updateNote:(NSString *)note;

- (void)start;

- (void)stop;

- (void)pause;

- (void)resume;

@property (nonatomic, readonly) ActivityStatus status;

@end
