//
//  MOJODetailViewController.m
//  DropPin
//
//  Created by Chris Eldridge on 7/31/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJODetailViewController.h"
#import "MOJOEditPOIViewController.h"
#import "MOJOPOI.h"

@interface MOJODetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) MOJOPOI *poi;

@end

@implementation MOJODetailViewController

- (instancetype)initWithPOI:(MOJOPOI *)poi
{
    self = [super initWithNibName:@"MOJODetailViewController" bundle:nil];
    if (self) {

        if ([poi isEditable]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editDescription:)];
        }
        
        _poi = poi;
    }
    return self;
}

- (void)editDescription:(id)sender {
    
    MOJOEditPOIViewController *editViewController = [[MOJOEditPOIViewController alloc] initWithPOI:self.poi];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:editViewController];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.nameLabel.text = self.poi.name;
    self.descriptionLabel.text = self.poi.placeDescription;
}

@end
