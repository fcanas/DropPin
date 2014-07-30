//
//  MOJOPOI.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOPOI.h"

#import <BlocksKit/BlocksKit.h>
#import <Parse/Parse.h>

@interface MOJOPOI ()
@property (nonatomic, strong) PFObject *parseObject;
@end

@implementation MOJOPOI

+ (void)loadPOIsWithCompletion:(void(^)(NSArray *pois, NSError *error))completion
{
    PFQuery *poiQuery = [PFQuery queryWithClassName:@"POI"];
    
    [poiQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray *pois = [objects bk_map:^id(PFObject *obj) {
            return [[MOJOPOI alloc] initWithParseObject:obj];
        }];
        
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
    return mojoPoi;
}

- (NSString *)subtitle {
    return self.name;
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

- (BOOL)save
{
    return [self.parseObject save:nil];
}

@end
