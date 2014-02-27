//
//  ViewController.h
//  fuelpath
//
//  Created by Aldrich Huang on 2/12/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface BaseMapViewController : UIViewController <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end
