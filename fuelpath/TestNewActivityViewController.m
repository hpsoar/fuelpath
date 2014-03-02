//
//  TestNewActivityViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "TestNewActivityViewController.h"
#import "PathGenerator.h"
#import "RunningActivity.h"

@interface TestNewActivityViewController () <PathGeneratorDelegate>

@property (nonatomic, strong) PathGenerator *pathGenerator;
@property (nonatomic, strong) RunningActivity *runningActivity;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation TestNewActivityViewController
- (IBAction)stopActivity:(id)sender {
    [self.runningActivity stop];
    [self.delegate testNewActivityViewController:self didFinishActivity:self.runningActivity];
}


- (IBAction)pauseActivity:(id)sender {
    if (self.runningActivity.status == kActivityPaused) {
        [self.runningActivity resume];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    else if (self.runningActivity.status == kActivityOnGoing){
        [self.runningActivity pause];
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
}

- (void)pathGenerator:(PathGenerator *)pathGenerator generatedLocation:(CLLocationCoordinate2D)location {
    [self.runningActivity updateLocation:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.runningActivity = [[RunningActivity alloc] initWithDataStore:self.dataStore];
    
    [self.runningActivity addObserver:self forKeyPath:@"updateCounter" options:NSKeyValueObservingOptionNew context:nil];
    
    self.pathGenerator = [[PathGenerator alloc] init];
    self.pathGenerator.delegate = self;
    self.pathGenerator.scale = 0.1;
    [self.pathGenerator start];
    [self.runningActivity start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observed location change");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
