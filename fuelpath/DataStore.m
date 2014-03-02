//
//  DataStore.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "DataStore.h"

@interface DataStore ()
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSURL *rootPath;
@end

@implementation DataStore

- (id)init {
    self = [super init];
    if (self) {
        self.rootPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Activity" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [self.rootPath URLByAppendingPathComponent:@"Activity.sqlite"];
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectModel == nil) {
        if (self.persistentStoreCoordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    return _managedObjectContext;
}

- (Route *)newRouteForActivity:(Activity *)activity {
    Route *route = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityRoute" inManagedObjectContext:self.managedObjectContext];
    [activity addSubRouteObject:route];
    return route;
}

- (ActivityPhoto *)newPhotoForActivity:(Activity *)activity {
    ActivityPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityPhoto" inManagedObjectContext:self.managedObjectContext];
    [activity addPhotoObject:photo];
    return photo;
}

- (Activity *)newActivity {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
}

- (void)removeActivity:(Activity *)activity {
    // TODO: delete subroutes, activity photos ect.
    [self.managedObjectContext deleteObject:activity];
}

- (void)removePhoto:(ActivityPhoto *)photo fromActivity:(Activity *)activity {
    [activity removePhotoObject:photo];
}

- (void)saveContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSFetchRequest *)fetchRequestForActivity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    return fetchRequest;
}

@end
