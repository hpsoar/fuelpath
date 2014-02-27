//
//  OverlayViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 2/12/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "OverlayViewController.h"
#import "Sqlite/CSqlite.h"
#import "CLLocation+Sino.h"
#import "WGS84ToGCJ02.h"

enum{
    OverlayViewControllerOverlayTypeCircle = 0,
    OverlayViewControllerOverlayTypePolyline,
    OverlayViewControllerOverlayTypePolygon
};

@interface OverlayViewController ()
@property (nonatomic, strong) NSMutableArray *overlays;
@property (nonatomic, strong) CSqlite *m_sqlite;

@end

@implementation OverlayViewController


- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth   = 8.f;
        circleView.strokeColor = [UIColor blueColor];
        circleView.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleView;
    }
    else if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth   = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonView.fillColor   = [UIColor redColor];
        
        return polygonView;
    }
    else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 8.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initOverlays
{
    self.overlays = [NSMutableArray array];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.91121667, 116.29694444);
    NSLog(@"%f, %f", location.longitude, location.latitude);
//    location = [self zzTransGPS:location];
    location = [WGS84ToGCJ02 transformFromWGSToGCJ:location];
    NSLog(@"%f, %f", location.longitude, location.latitude);

    /* Circle. */
    MACircle *circle = [MACircle circleWithCenterCoordinate:location radius:150];
    [self.overlays insertObject:circle atIndex:OverlayViewControllerOverlayTypeCircle];
    
//    /* Polyline. */
//    CLLocationCoordinate2D polylineCoords[4];
//    polylineCoords[0].latitude = 39.855539;
//    polylineCoords[0].longitude = 116.419037;
//    
//    polylineCoords[1].latitude = 39.858172;
//    polylineCoords[1].longitude = 116.520285;
//    
//    polylineCoords[2].latitude = 39.795479;
//    polylineCoords[2].longitude = 116.520859;
//    
//    polylineCoords[3].latitude = 39.788467;
//    polylineCoords[3].longitude = 116.426786;
//  
//    CFMutableArrayRef ar = CFArrayCreateMutable(NULL, 4, NULL);
//    for (int i = 0; i < 4; ++i) {
//        CFArrayAppendValue(ar, (void*)&polylineCoords[i]);
//    }
//    CLLocationCoordinate2D *ptr = nil;
//    CFArrayGetValues(ar, CFRangeMake(0, 4), (void*)&ptr);
//    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:ptr count:4];
//    [self.overlays insertObject:polyline atIndex:OverlayViewControllerOverlayTypePolyline];
    
    /* Polygon. */
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.781892;
    coordinates[0].longitude = 116.293413;
    
    coordinates[1].latitude = 39.787600;
    coordinates[1].longitude = 116.391842;
    
    coordinates[2].latitude = 39.733187;
    coordinates[2].longitude = 116.417932;
    
    coordinates[3].latitude = 39.704653;
    coordinates[3].longitude = 116.338255;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
//    [self.overlays insertObject:[polygon atIndex:1]OverlayViewControllerOverlayTypePolygon];
}

- (void)modeAction {
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //设置 为地图跟着位置移动
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationCoordinate2D location = [WGS84ToGCJ02 transformFromWGSToGCJ:userLocation.location.coordinate];
    NSLog(@"%f, %f", location.longitude, location.latitude);
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma Utilities
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    NSLog(@"%@", sql);
    sqlite3_stmt* stmtL = [self.m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
}

#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self)
    {
        self.m_sqlite = [[CSqlite alloc]init];
        [self.m_sqlite openSqlite];
        [self initOverlays];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView addOverlays:self.overlays];
    
    self.mapView.showsUserLocation = YES;
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
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
