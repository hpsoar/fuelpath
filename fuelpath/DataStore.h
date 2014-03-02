//
//  DataStore.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Activity.h"

@interface DataStore : NSObject

@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (Activity *)newActivity;

- (Route *)newRouteForActivity:(Activity *)activity;

- (ActivityPhoto *)newPhotoForActivity:(Activity *)activity;

- (void)removeActivity:(Activity *)activity;

//- (void)addPhoto:(ActivityPhoto *)photo toActivity:(Activity *)activity;

- (void)removePhoto:(ActivityPhoto *)photo fromActivity:(Activity *)activity;

- (void)saveContext;

- (NSFetchRequest*)fetchRequestForActivity;

@end
