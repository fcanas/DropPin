//
//  MOJOMapViewController.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOMapViewController.h"

@import MapKit;

@interface MOJOMapViewController () <MKMapViewDelegate, UIToolbarDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@end

@implementation MOJOMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView]];
    
    [self.navigationItem setRightBarButtonItem:self.trackingButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
