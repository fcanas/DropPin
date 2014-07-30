//
//  MOJOPOI.h
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface MOJOPOI : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *name;

// Display properties for MapKit
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

/**
 The callback will be called with all MOJOPOIs in an array.
 */
+ (void)loadPOIsWithCompletion:(void(^)(NSArray *pois, NSError *error))completion;

+ (MOJOPOI *)poiWithCoordinate:(CLLocationCoordinate2D)coordinate;

// Synchronously save the POI. Returns success.
- (BOOL)save;

@end
