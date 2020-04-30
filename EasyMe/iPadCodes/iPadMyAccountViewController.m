//
//  iPadMyAccountViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadMyAccountViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import "BlockViewController.h"


@implementation iPadMyAccountViewController
{
    AMSmoothAlertView * alert;
}

@synthesize mybtn, jsonResponse;

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
    
    NSString *firsttime = [[NSUserDefaults standardUserDefaults] stringForKey:@"FIRSTTIME"];
    if ([firsttime isEqualToString:@"1"])
    {
        [self fetchInitData];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tracker = [[GAI sharedInstance] defaultTracker];
    [self.tracker set:kGAIScreenName value:@"Menu"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}



-(void)fetchInitData
{
    
    [SVProgressHUD show];
    jsonResponse  = nil;
    
    NSDictionary *requestData = nil;
    
    requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSDictionary *response = [ws validator:requestData];
                       
                       [self setJsonResponse:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processInitData];
                       });
                   });
    
}


-(void)processInitData
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FIRSTTIME"];
    NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *StatusCode = [dataContent objectForKey:@"StatusCode"];
    NSLog(@" StatusCode : %@",StatusCode);
    
    NSString *eventCode = [dataContent objectForKey:@"eventCode"];
    
    if ([eventCode isEqualToString:@"-25"] )
    {
        NSString *mirageCode = [dataContent objectForKey:@"mirage"];
        if ([mirageCode isEqualToString:@"APPLE"])
        {
            NSLog(@" mirageCode :::: %@",mirageCode);
            [[NSUserDefaults standardUserDefaults] setObject:mirageCode forKey:@"APPUSER"];
            
            NSString *StatusDescription = @"Welcome to Etisalat Mobile Service.";
            [self showSelfDismissingAlertViewWithMessage:StatusDescription];
            
        }
        else
        {
            NSString *StatusDescription = @"WiFi detected. Some features will not be available. Please turn off WiFi or insert an etisalat SIM card";
            [self showSelfDismissingAlertViewWithMessage:StatusDescription];
        }
        
    }
    else
    {
        if ([StatusCode isEqualToString:@"123"] || [StatusCode isEqualToString:@"789"])
        {
            
            NSString *StatusDescription = [dataContent objectForKey:@"StatusDescription"];
            NSLog(@" StatusDescription : %@",StatusDescription);
            [self showSelfDismissingAlertViewWithMessage:StatusDescription];
        }
        else
        {
            NSString *serverresponse = [dataContent objectForKey:@"displayMessage"];
            NSString *allowORnot = [dataContent objectForKey:@"validationTypeFG"];
            
            NSLog(@" serverresponse : %@",serverresponse);
            
            if ([allowORnot isEqualToString:@"ALLOW"])
            {
                
                if (!alert || !alert.isDisplayed)
                {
                    
                    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alert setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
                    {
                        if(button == alertObj.defaultButton)
                        {
                            NSLog(@"Default");
                        }
                        else
                        {
                            NSLog(@"Others");
                        }
                    };
                    
                    
                    alert.cornerRadius = 3.0f;
                    [alert show];
                }
                else
                {
                    [alert dismissAlertView];
                }
            }
            else
            {
                
                __weak iPadMyAccountViewController *self_ = self;
                
                if (!alert || !alert.isDisplayed)
                {
                    
                    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alert setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
                    {
                        if(button == alertObj.defaultButton)
                        {
                            NSLog(@"Default");
                            [self_ actionTaken];
                        }
                        else
                        {
                            NSLog(@"Others");
                        }
                    };
                    
                    
                    alert.cornerRadius = 3.0f;
                    [alert show];
                }
                else
                {
                    [alert dismissAlertView];
                }
                
            }
            
        }
        
    }
    
    
}



-(void)actionTaken
{

    BlockViewController *blockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    blockVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    blockVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:blockVC animated:NO completion:nil];
    
}



-(IBAction)queryBtnClicked:(id)sender
{
    NSLog(@":::::: button was clicked ::::::");
    
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    
    jsonResponse  = nil;
    
    NSDictionary *requestData = nil;
    NSString *serviceControllerCode = @"";
    NSString *prodMainPackage = @"";
    NSString *prodSubservice = @"";
    NSString *optCode = @"";
    NSString *actionPerformed = @"";
    
    UIButton *btn = (UIButton *)sender;
    
    //voice balance
    if (btn.tag == 1)
    {
        actionPerformed = @"Airtime Balance";
        
        serviceControllerCode = @"QUERY_VOICE_PLAN";
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode };
    }
    //data balance
    else if (btn.tag == 2)
    {
        actionPerformed = @"Data Balance";
        
        serviceControllerCode = @"QUERY_DATA_PLAN";
        prodMainPackage = @"QUERY_DATA_PLAN";
        prodSubservice = @"QUERY_DATA_PLAN";
        optCode = @"QUERY";
        
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"optCode":optCode };
    }
    //show number
    else if (btn.tag == 3)
    {
        actionPerformed = @"Show Number";
        
        serviceControllerCode = @"QUERY_SUBSCRIBER_MOBILE_NO";
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode };
    }
    //check package
    else if (btn.tag == 4)
    {
        actionPerformed = @"Show Package";
        
        serviceControllerCode = @"QUERY_SUBSCRIBER_PACKAGE";
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode };
    }
    
    
    if ([appuser isEqualToString:@"APPLE"])
    {
        PSServerViewController *ps = [PSServerViewController new];
        [ps sendToServer:actionPerformed];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           WebServiceCall *ws = [[WebServiceCall alloc] init];
                        
                           NSDictionary *response = [ws controllers:requestData];
                           
                           [self setJsonResponse:response];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [SVProgressHUD dismiss];
                               [self processResult];
                           });
                       });
    }
    
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"DataServices"
                                                                action:@"touch"
                                                                 label:actionPerformed
                                                                 value:nil] build]];
    
}



-(void)processResult
{
    NSLog(@" reponse : %@",[self jsonResponse]);
    
    NSDictionary * dataContent = [self jsonResponse];
    NSString *StatusCode = [dataContent objectForKey:@"StatusCode"];
    NSLog(@" StatusCode : %@",StatusCode);

    NSString *eventCode = [dataContent objectForKey:@"eventCode"];
    if ([eventCode isEqualToString:@"-25"] )
    {
        NSString *StatusDescription = @"This feature is only available with etisalat SIM card. Please turn off WiFi or insert an etisalat SIM card";
        [self showSelfDismissingAlertViewWithMessage:StatusDescription];
    }
    else
    {
        if ([StatusCode isEqualToString:@"123"] || [StatusCode isEqualToString:@"789"])
        {
            
            NSString *StatusDescription = [dataContent objectForKey:@"StatusDescription"];
            NSLog(@" StatusDescription : %@",StatusDescription);
            [self showSelfDismissingAlertViewWithMessage:StatusDescription];
        }
        else
        {
            NSString *serverresponse = [dataContent objectForKey:@"displayMessage"];
            NSString *allowORnot = [dataContent objectForKey:@"validationTypeFG"];
            
            NSLog(@" serverresponse : %@",serverresponse);
            
            if ([allowORnot isEqualToString:@"ALLOW"])
            {
                
                if (!alert || !alert.isDisplayed)
                {
                    
                    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alert setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
                    {
                        if(button == alertObj.defaultButton)
                        {
                            NSLog(@"Default");
                        }
                        else
                        {
                            NSLog(@"Others");
                        }
                    };
                    
                    
                    alert.cornerRadius = 3.0f;
                    [alert show];
                }
                else
                {
                    [alert dismissAlertView];
                }
            }
            else
            {
                
                __weak iPadMyAccountViewController *self_ = self;
                
                if (!alert || !alert.isDisplayed)
                {
                    
                    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alert setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
                    {
                        if(button == alertObj.defaultButton)
                        {
                            NSLog(@"Default");
                            [self_ action2Taken];
                        }
                        else
                        {
                            NSLog(@"Others");
                        }
                    };
                    
                    
                    alert.cornerRadius = 3.0f;
                    [alert show];
                }
                else
                {
                    [alert dismissAlertView];
                }
                
            }
            
        }
        
    }
    
    
}



-(void)action2Taken
{
    
    BlockViewController *blockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    blockVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    blockVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:blockVC animated:NO completion:nil];
    
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


-(void)removeSelfView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.view = nil;
}


-(IBAction)buyDataClicked:(id)sender
{
    [self removeSelfView];
    [[NSUserDefaults standardUserDefaults] setObject:@"account" forKey:@"FROM"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuyDataOptionsView" object:nil userInfo:nil];
}


-(IBAction)rechargeClicked:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuyAirtimeOptionsView" object:nil userInfo:nil];
}


-(IBAction)rechargeOthersClicked:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRechargeOthersView" object:nil userInfo:nil];
}


-(IBAction)rechargeTransferClicked:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAirtimeTransferView" object:nil userInfo:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end