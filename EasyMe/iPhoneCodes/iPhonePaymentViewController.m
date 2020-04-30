//
//  iPhonePaymentViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhonePaymentViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import "AppConstants.h"

@implementation iPhonePaymentViewController

@synthesize scrollview;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 250.0)];
    [self.scrollview setBounces:FALSE];
    
    
    self.navigationController.navigationBarHidden = YES;
    
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
    [self performSegueWithIdentifier: @"RechargeCodeSegue" sender:self];
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


- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end