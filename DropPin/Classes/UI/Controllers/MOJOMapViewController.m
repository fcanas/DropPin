//
//  MOJOMapViewController.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOMapViewController.h"
#import "MOJOPOI.h"
#import "MOJODetailViewController.h"

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
    self.navigationItem.title = @"DropPin";
    
    [self.navigationItem setRightBarButtonItem:[[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                            target:self
                                                                                            action:@selector(refreshPOIs)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshPOIs];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - POI Methods

- (IBAction)addPinWithGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchLocation = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchLocation
                                              toCoordinateFromView:self.mapView];
    
    [self.mapView addAnnotation:[MOJOPOI poiWithCoordinate:coordinate]];
}

- (void)refreshPOIs
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [MOJOPOI loadPOIsWithCompletion:^(NSArray *objects, NSError *error) {
        [self.mapView addAnnotations:objects];
    }];
}

#pragma mark - MapView Delegate Methods

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    MOJODetailViewController *detailViewController = [[MOJODetailViewController alloc] initWithPOI:view.annotation];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [MKPinAnnotationView safe_cast:[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinViewIdentifier"]];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                              reuseIdentifier:@"pinViewIdentifier"];
    }
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [pin setCanShowCallout:YES];
    
    [MOJOPOI safe_cast:annotation intoBlock:^(MOJOPOI *poi) {
        pin.pinColor = poi.isEditable?MKPinAnnotationColorGreen:MKPinAnnotationColorRed;
    }];
    
    pin.animatesDrop = YES;
    return pin;
}

#pragma mark - User Location

- (void)updateMapAnnotationDistancesFromLocation:(CLLocation *)currentLocation
{
    MKDistanceFormatter *formatter = [[MKDistanceFormatter alloc] init];
    
    [[self.mapView annotations] safe_enumerateObjectsOfKind:[MOJOPOI class]
                                                 usingBlock:^(MOJOPOI *annotation, NSUInteger idx, BOOL *stop) {
                                                     CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude
                                                                                                                 longitude:annotation.coordinate.longitude];
                                                     CLLocationDistance distance = [currentLocation distanceFromLocation:annotationLocation];
                                                     annotation.subtitle = [formatter stringFromDistance:distance];
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
