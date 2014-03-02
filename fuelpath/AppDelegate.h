//
//  AppDelegate.h
//  fuelpath
//
//  Created by Aldrich Huang on 2/12/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) DataStore *dataStore;

@end
