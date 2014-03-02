//
//  PathViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 2/14/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "PathViewController.h"
#import "WGS84ToGCJ02.h"

@interface PathViewController ()

@property (nonatomic, strong) MAPolyline *path;
@property (nonatomic) CFMutableArrayRef raw_path;

@end

@implementation PathViewController

//-(MAPolyline *)path {
//    if (_path == NULL) {
//        CLLocationCoordinate2D polylineCoords[4];
//        polylineCoords[0].latitude = 39.855539;
//        polylineCoords[0].longitude = 116.419037;
//        
//        polylineCoords[1].latitude = 39.858172;
//        polylineCoords[1].longitude = 116.520285;
//        
//        polylineCoords[2].latitude = 39.795479;
//        polylineCoords[2].longitude = 116.520859;
//        
//        polylineCoords[3].latitude = 39.788467;
//        polylineCoords[3].longitude = 116.426786;
//        
//        _path = [MAPolyline polylineWithCoordinates:polylineCoords count:4];
//    }
//    return _path;
//}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth   = 1.f;
        circleView.strokeColor = [UIColor blueColor];
        circleView.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleView;
    }
    else if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth   = 2.f;
        polygonView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonView.fillColor   = [UIColor redColor];
        
        return polygonView;
    }
    else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 1.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

- (void)modeAction {
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //设置 为地图跟着位置移动
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationCoordinate2D location2d = [WGS84ToGCJ02 transformFromWGSToGCJ:userLocation.location.coordinate];
    NSLog(@"%f, %f", location2d.longitude, location2d.latitude);
    
    CFArrayAppendValue(self.raw_path, (void*)&location2d);
    
    [self updatePath];
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)updatePath {
    CLLocationCoordinate2D *coordinates = nil;
    CFIndex len = CFArrayGetCount(self.raw_path);
    NSLog(@"%d", len);
    CFArrayGetValues(self.raw_path, CFRangeMake(0, len), (void*)&coordinates);
   // CFRelease(self.raw_path);
    
   // NSLog(@"%d", self.mapView.overlays.count);
//    if (self.path != nil) {
//        [self.mapView removeOverlay:self.path];
//    }
    //MAMapPoint *pt = [MAMapPoint alloc]
    self.path = [MAPolyline polylineWithCoordinates:coordinates count:len];
    //[self.mapView addOverlay:self.path];
}

#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self != nil) {
        self.raw_path = CFArrayCreateMutable(NULL, 10, NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
       //    [self.overlays insertObject:polyline atIndex:OverlayViewControllerOverlayTypePolyline];
    self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
