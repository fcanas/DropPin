//
//  MOJOPOI.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOPOI.h"

#import <Parse/Parse.h>

@interface MOJOPOI ()
@property (nonatomic, strong) PFObject *parseObject;
@end

@implementation MOJOPOI

+ (void)loadPOIsWithCompletion:(void(^)(NSArray *pois, NSError *error))completion
{
    PFQuery *poiQuery = [PFQuery queryWithClassName:@"POI"];
    
    [poiQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *pois = [NSMutableArray arrayWithCapacity:objects.count];
        
        for (PFObject *obj in objects) {
            MOJOPOI *poi = [[MOJOPOI alloc] initWithParseObject:obj];
            if (poi) {
                [pois addObject:poi];
            }
        }
        
        if (completion) {
            completion(pois, error);
        }
    }];
}

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _parseObject = parseObject;
    
    return self;
}

+ (MOJOPOI *)poiWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    PFObject *parsePoi = [[PFObject alloc] initWithClassName:@"POI"];
    parsePoi[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [parsePoi saveInBackground];
    
    MOJOPOI *mojoPoi = [[MOJOPOI alloc] initWithParseObject:parsePoi];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [[CLGeocoder new] reverseGeocodeLocation:location
                           completionHandler:^(NSArray *placemarks, NSError *error) {
                               CLPlacemark *placemark = [placemarks firstObject];
                               mojoPoi.name = [placemark name];
                               mojoPoi.placeDescription = [NSString stringWithFormat:@"%@ %@", placemark.thoroughfare?:@"", placemark.locality?:@""];
                               [mojoPoi.parseObject saveInBackground];
                           }];
    return mojoPoi;
}

- (NSString *)title
{
    return self.name?:@"Untitled";
}

- (NSString *)subtitle
{
    return self.placeDescription;
}

- (BOOL)isEditable
{
    // TODO : Does not consider globally writable objects, or group access.
    return [self.parseObject.ACL getWriteAccessForUser:[PFUser currentUser]];
}

#pragma mark - Parse Properties

- (CLLocationCoordinate2D)coordinate
{
    PFGeoPoint *geoPoint = self.parseObject[@"coordinate"];
    return CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
}

- (NSString *)name
{
    return self.parseObject[@"name"];
}

- (void)setName:(NSString *)name
{
    self.parseObject[@"name"] = name;
}

- (void)setPlaceDescription:(NSString *)placeDescription
{
    self.parseObject[@"placeDescription"] = placeDescription;
}

- (NSString *)placeDescription
{
    return self.parseObject[@"placeDescription"];
}

- (void)saveWithBlock:(void(^)(BOOL success))completionBlock
{
    [self.parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded);
        }
    }];
}

@end
