//
//  Activity.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityPhoto, Route;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSDate * beginTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSSet *subRoute;
@property (nonatomic, retain) NSSet *photo;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addSubRouteObject:(Route *)value;
- (void)removeSubRouteObject:(Route *)value;
- (void)addSubRoute:(NSSet *)values;
- (void)removeSubRoute:(NSSet *)values;

- (void)addPhotoObject:(ActivityPhoto *)value;
- (void)removePhotoObject:(ActivityPhoto *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

@end
