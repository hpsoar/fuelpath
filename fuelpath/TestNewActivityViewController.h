//
//  TestNewActivityViewController.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "RunningActivity.h"

@class TestNewActivityViewController;
@protocol TestNewActivityViewControllerDelegate <NSObject>

- (void)testNewActivityViewController:(TestNewActivityViewController *)controller didFinishActivity:(RunningActivity *)activity;

@end

@interface TestNewActivityViewController : UIViewController

@property (nonatomic, weak) DataStore *dataStore;

@property (nonatomic, strong) id<TestNewActivityViewControllerDelegate> delegate;

@end
