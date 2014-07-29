//
//  MOJOMapViewController.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOMapViewController.h"
#import "MOJOPOI.h"

@import CoreLocation;
@import MapKit;

@interface MOJOMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MOJOMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil) {
        return nil;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MOJOPOI loadPOIsWithCompletion:^(NSArray *objects, NSError *error) {
        [self.mapView addAnnotations:objects];
    }];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)addPinWithGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchLocation = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchLocation
                                              toCoordinateFromView:self.mapView];
    
    MOJOPOI *annotation = [MOJOPOI poiWithCoordinate:coordinate];
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinViewIdentifier"];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                              reuseIdentifier:@"pinViewIdentifier"];
    }
    
    [pin setCanShowCallout:YES];
    
    pin.animatesDrop = YES;
    return pin;
}

#pragma mark - User Location

- (void)updateMapAnnotationDistancesFromLocation:(CLLocation *)currentLocation
{
    MKDistanceFormatter *formatter = [[MKDistanceFormatter alloc] init];
    
    [[self.mapView annotations] enumerateObjectsOfKind:[MOJOPOI class]
                                            usingBlock:^(MOJOPOI *annotation, NSUInteger idx, BOOL *stop) {
                                                CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude
                                                                                                            longitude:annotation.coordinate.longitude];
                                                CLLocationDistance distance = [currentLocation distanceFromLocation:annotationLocation];
                                                annotation.title = [formatter stringFromDistance:distance];
                                            }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.mapView setCenterCoordinate:currentLocation.coordinate];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 2000, 2000) animated:NO];
    });
    
    [self updateMapAnnotationDistancesFromLocation:currentLocation];
}

@end
