//
//  PathPoint.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "RoutePoint.h"

#define INITIAL_POINT_CAPACITY 1000

@implementation RoutePoint

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    return formatter;
}

- (id)init {
    self = [super init];
    if (self) {
        _pointCount = 0;
        _lastSaveTime = [NSDate date].timeIntervalSince1970;
        _lastSavePointIndex = 0;
        
        self.autoSaveTimeInterval = 30; // TODO: read from config
        
        [self adjustStorage:INITIAL_POINT_CAPACITY];
    }
    return self;
}

- (void)adjustStorage:(NSInteger)capacity {
    if (capacity <= 0) return;
    
    if (_pointCapacity == 0) {
        _pointCapacity = capacity;
        _locationPoints = malloc(sizeof(CLLocationCoordinate2D) * _pointCapacity);
        _timePoints = [[NSMutableArray alloc] initWithCapacity:_pointCapacity];
    }
    else {
        _pointCapacity = capacity;
        _locationPoints = realloc(_locationPoints, sizeof(CLLocationCoordinate2D) * _pointCapacity);
    }
}

- (CLLocationCoordinate2D *)locationPoints {
    return _locationPoints;
}

- (NSInteger)pointCount {
    return _pointCount;
}

- (void)addLocation:(CLLocation *)location autoSave:(BOOL)autoSave {
    if (_pointCount == _pointCapacity) {
        [self adjustStorage:_pointCapacity * 2];
    }
    
    _locationPoints[_pointCount] = location.coordinate;
    [_timePoints addObject: location.timestamp];
    ++_pointCount;
    
    if (autoSave && location.timestamp.timeIntervalSince1970 - _lastSaveTime > self.autoSaveTimeInterval) {
        [self saveToFile];
    }
}

- (NSString *)filePath {
    NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *fileURL = [storeURL URLByAppendingPathComponent:self.filename];
    return fileURL.path;
}

- (void)saveToFile {
    // TODO: support concurrency
    
    NSDateFormatter *dateFormatter = [RoutePoint dateFormatter];
    
    NSString *content = @"";
    for (NSInteger i = _lastSavePointIndex; i < _pointCount; ++i) {
        CLLocationCoordinate2D location = _locationPoints[i];
        content = [content stringByAppendingFormat:@"%@\t%f\t%f\n", [dateFormatter stringFromDate:[_timePoints objectAtIndex:i]], location.latitude, location.longitude];
    }
    
    NSString *filePath = [self filePath];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    }
    else {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
        [myHandle seekToEndOfFile];
        [myHandle writeData:data];
        [myHandle closeFile];
    }
    
    _lastSaveTime = [NSDate date].timeIntervalSince1970;
    _lastSavePointIndex = _pointCount;
}

- (void)loadFromFile {
    NSFileHandle *myHandle = [NSFileHandle fileHandleForReadingAtPath:[self filePath]];
    NSData *data = [myHandle readDataToEndOfFile];
    [myHandle closeFile];
    
    NSArray *dataPoints = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"\n"];
    
    [self adjustStorage:dataPoints.count];

    NSDateFormatter *dateFormatter = [RoutePoint dateFormatter];
    
    for (NSUInteger i = 0; i < dataPoints.count; ++i) {
        NSArray *point = [[dataPoints objectAtIndex:i] componentsSeparatedByString:@"\t"];
        if (point.count != 3) break;
        [_timePoints addObject:[dateFormatter dateFromString:[point objectAtIndex:0]]];
        _locationPoints[i] = CLLocationCoordinate2DMake([[point objectAtIndex:1] floatValue], [[point objectAtIndex:2] floatValue]);
        ++_pointCount;
    }
}

- (void)dealloc {
    free(_locationPoints);
}

@end

