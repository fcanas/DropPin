//
//  MOJOAppDelegate.m
//  DropPin
//
//  Created by Fabian Canas on 7/29/14.
//  Copyright (c) 2014 MojoTech. All rights reserved.
//

#import "MOJOAppDelegate.h"
#import "MOJOMapViewController.h"

#import <Parse/Parse.h>

@implementation MOJOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MOJOMapViewController *mapViewController = [[MOJOMapViewController alloc] initWithNibName:@"MOJOMapViewController"
                                                                                       bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    self.window.rootViewController = nc;
    
    [self setupParse];
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Configuration

- (void)setupParse
{
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
    
    [Parse setApplicationId:keys[@"ParseApplicationID"]
                  clientKey:keys[@"ParseClientKey"]];
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [[PFUser currentUser] saveInBackground];
}

@end
