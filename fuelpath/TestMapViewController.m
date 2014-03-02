//
//  MapViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "TestMapViewController.h"
#import "RoutePoint.h"
#import "Route.h"
#import <MapKit/MapKit.h>

@interface TestMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isMapInitialized;
@property (nonatomic, strong) NSMutableArray *routePoints;
@end

@implementation TestMapViewController

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRenderer.strokeColor = [UIColor blueColor];
    polylineRenderer.fillColor = [UIColor blueColor];
    return polylineRenderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = userLocation.location.coordinate;
    if (location.latitude == 0) return;
    if (!self.isMapInitialized) {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location, 2000, 2000) animated:YES];
        self.isMapInitialized = YES;
    }
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
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.isMapInitialized = NO;
    self.routePoints = [[NSMutableArray alloc] initWithCapacity:self.activity.subRoute.count];
    [self.activity.subRoute enumerateObjectsUsingBlock:^(Route *route, BOOL *stop) {
        RoutePoint *routePoint = [[RoutePoint alloc] init];
        routePoint.filename = route.pathPointFilename;
        [routePoint loadFromFile];
        [self.routePoints addObject:routePoint];
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:routePoint.locationPoints count:routePoint.pointCount];
        [self.mapView addOverlay:polyline];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
