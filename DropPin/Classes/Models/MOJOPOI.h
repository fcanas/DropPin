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
@property (nonatomic, copy) NSString *placeDescription;

// Display properties for MapKit
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/**
 The callback will be called with all MOJOPOIs in an array.
 */
+ (void)loadPOIsWithCompletion:(void(^)(NSArray *pois, NSError *error))completion;

+ (MOJOPOI *)poiWithCoordinate:(CLLocationCoordinate2D)coordinate;

// Asynchronously save the POI. Returns success.
- (void)saveWithBlock:(void(^)(BOOL success))completionBlock;

- (BOOL)isEditable;

@end
