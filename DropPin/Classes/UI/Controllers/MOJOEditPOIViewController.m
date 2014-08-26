//
//  MOJOEditPOIViewController.m
//  DropPin
//
//  Created by Fabian Canas on 7/30/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOEditPOIViewController.h"
#import "MOJOPOI.h"

@interface MOJOEditPOIViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (nonatomic, strong) MOJOPOI *poi;
@end

@implementation MOJOEditPOIViewController

- (instancetype)initWithPOI:(MOJOPOI *)poi
{
    self = [super initWithNibName:@"MOJOEditPOIViewController" bundle:nil];
    if (self == nil) {
        return nil;
    }
    
    self.navigationItem.title = @"Edit";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(save:)];
    _poi = poi;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameField.text = self.poi.name;
    self.descriptionField.text = self.poi.placeDescription;
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender
{
    self.poi.name = self.nameField.text;
    self.poi.placeDescription = self.descriptionField.text;
    
    [self.poi saveWithBlock:^(BOOL success) {
        if (success) {
            [self.presentingViewController dismissViewControllerAnimated:YES
                                                              completion:nil];
        } else {
            [self showAlertDialog];
        }
    }];
}

- (void)showAlertDialog {
    
    [[[UIAlertView alloc] initWithTitle:@"Save Failed"
                                message:@"Unable to save the POI."
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

@end
