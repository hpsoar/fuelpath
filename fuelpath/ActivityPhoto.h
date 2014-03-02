//
//  ActivityPhoto.h
//  fuelpath
//
//  Created by Aldrich Huang on 3/2/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActivityPhoto : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * filename;

@end
