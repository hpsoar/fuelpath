//
//  Route.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Route : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * beginTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * pathPointFilename;

@end
