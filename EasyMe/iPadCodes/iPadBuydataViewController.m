//
//  iPadBuydataViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadBuydataViewController.h"
#import "iPhoneDataPlansViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import "AppConstants.h"

@implementation iPadBuydataViewController

@synthesize scrollview, jsonResponse, easyblazeList;
@synthesize buttonPressed;

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
    [tracker set:kGAIScreenName value:@"Purchase Data"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(IBAction)buydataButtons:(id)sender
{
    [SVProgressHUD show];
    easyblazeList  = nil;
    
    NSInteger tagIndex = [(UIButton *)sender tag];
    buttonPressed = [NSString stringWithFormat:@"%ld",(long)tagIndex];
    
    NSString *requestData = @"EASYBLAZE";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSArray *response = [ws categories:requestData];
                       
                       [self setEasyblazeList:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processEasyblazeData];
                       });
                   });
    
}


-(void)processEasyblazeData
{
    //NSLog(@"easyblazeList ::::: here  :::: %ld", [easyblazeList count]);
    
    if ([easyblazeList isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:easyblazeList];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"EASYBLAZEDATA"];
        
        [self showDataPlansView];
    }
    else
    {
        NSString *StatusDescription = @"This feature is only available with etisalat SIM card. Please turn off WiFi or insert an etisalat SIM card";
        [self showSelfDismissingAlertViewWithMessage:StatusDescription];
    }
    
}


-(void)removeSelfView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.view = nil;
}


- (void)showDataPlansView
{
    [self removeSelfView];
    [[NSUserDefaults standardUserDefaults] setObject:buttonPressed forKey:@"PAYMENTMODE"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDataPlanView" object:nil userInfo:nil];
}


- (IBAction)backButtonPressed:(id)sender
{
    [self removeSelfView];
    
    NSString *from = [[NSUserDefaults standardUserDefaults] objectForKey:@"FROM"];
    
    if ([from isEqualToString:@"data"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDataServicesView" object:nil userInfo:nil];
    else if ([from isEqualToString:@"account"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMyAccountView" object:nil userInfo:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)showSelfDismissingAlertViewWithMessage:(NSString *)message
{
    
    
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize textSize = [self getSizeForText:message withFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:15] maxSize:CGSizeMake(280, 200)];
    
    CGRect loadingFrame = CGRectMake(scrSize.width/2 - textSize.width/2 - 10, scrSize.height/2 - textSize.height/2 - 5 - (40), textSize.width + 20, textSize.height + 15);
    UIView *viewMessage = [[UIView alloc] initWithFrame:loadingFrame];
    [viewMessage setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, textSize.width, textSize.height)];
    [loadingLabel setNumberOfLines:0];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:15]];
    [loadingLabel setText:message];
    [viewMessage addSubview:loadingLabel];
    
    [viewMessage.layer setCornerRadius:4.0f];
    [self.view addSubview:viewMessage];
    
    [self performSelector:@selector(removeSelfDismissingAlertView:)
               withObject:viewMessage
               afterDelay:4.0];
    
}


- (CGSize)getSizeForText:(NSString *)text withFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    CGSize sizeText = CGSizeZero;
    
    NSDictionary *fontDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect textRect = [text boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:fontDict
                                         context:nil];
    sizeText = textRect.size;
    
    return sizeText;
}


- (void)removeSelfDismissingAlertView:(UIView *)viewMessage {
    [UIView animateWithDuration:0.25f
                     animations:^ {
                         [viewMessage setAlpha:0.0f];
                     }
                     completion:^ (BOOL finished) {
                         [viewMessage removeFromSuperview];
                     }];
}



@end