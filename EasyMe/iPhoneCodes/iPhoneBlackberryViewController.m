//
//  iPhoneBlackberryViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneBlackberryViewController.h"
#import "AppConstants.h"

@implementation iPhoneBlackberryViewController

@synthesize mybtn;

/*
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.screenName = @"Blackberry Screen";
}
*/

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Blackberry"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(IBAction)clickedBtn:(id)sender
{
    NSLog(@":::::: button was clicked ::::::");
}


- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end