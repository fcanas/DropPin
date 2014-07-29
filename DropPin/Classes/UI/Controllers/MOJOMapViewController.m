//
//  MOJOMapViewController.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOMapViewController.h"

#import <Parse/Parse.h>

@import MapKit;

@interface MOJOMapViewController () <MKMapViewDelegate, UIToolbarDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) PFQuery *poiQuery;
@end

@implementation MOJOMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil) {
        return nil;
    }
    
    _poiQuery = [PFQuery queryWithClassName:@"POI"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.poiQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *poi in objects) {
            MKPointAnnotation *annotation = [self annotationForPOI:poi];
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (IBAction)addPinWithGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchLocation = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchLocation
                                              toCoordinateFromView:self.mapView];
    
    [self poiWithCoordinate:coordinate];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:@"pinViewIdentifier"];
    pin.animatesDrop = YES;
    return pin;
}

#pragma mark - POI managment

- (PFObject *)poiWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    PFObject *poi = [[PFObject alloc] initWithClassName:@"POI"];
    poi[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [poi saveInBackground];
    return poi;
}

- (MKPointAnnotation *)annotationForPOI:(PFObject *)poi
{
    PFGeoPoint *geoPoint = poi[@"coordinate"];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    return annotation;
}

@end
