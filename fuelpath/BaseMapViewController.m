//
//  ViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 2/12/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "BaseMapViewController.h"


@interface BaseMapViewController ()

@end

@implementation BaseMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [MAMapServices sharedServices].apiKey =@"6a5b5a2865b3c643e2214731272618cc";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)]; self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)mapTypeAction: (NSUInteger) type {
    self.mapView.mapType = type; //type 取值为 MAMapTypeStandard 或 MAMapTypeSatellite }
}

@end
