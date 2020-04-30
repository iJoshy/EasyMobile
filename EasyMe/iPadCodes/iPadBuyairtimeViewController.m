//
//  iPadBuyairtimeViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadBuyairtimeViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import "AppConstants.h"

@implementation iPadBuyairtimeViewController

@synthesize scrollview;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // Position the view within the new parent.
    [[parent view] addSubview:[self view]];
    
    CGRect newFrame = CGRectMake(320, 0, 700, 768);
    [[self view] setFrame:newFrame];
    
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 307.0)];
    [self.scrollview setBounces:FALSE];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Purchase Airtime"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(IBAction)payWithRechargecode:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRechargeView" object:nil userInfo:nil];
}


-(IBAction)payWithDebitcard:(id)sender
{
    [self presentWebViewController:@"https://paywith.quickteller.com/?paymentCode=90806&ispopup=true&site=etisalat.com.ng"];
}


- (void)presentWebViewController:(NSString *)address
{
    
    NSURL *URL = [NSURL URLWithString:address];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:webViewController animated:YES completion:NULL];
}


-(void)removeSelfView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.view = nil;
}


- (IBAction)backButtonPressed:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMyAccountView" object:nil userInfo:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end