//
//  iPhoneEasyCliqViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneEasyCliqViewController.h"

@implementation iPhoneEasyCliqViewController
{
    AMSmoothAlertView * alert;
}

@synthesize jsonResponse;
@synthesize scrollview;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tracker = [[GAI sharedInstance] defaultTracker];
    [self.tracker set:kGAIScreenName value:@"EasyCliq"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}



-(IBAction)clickedBtn:(id)sender
{
    
    NSDictionary *requestData = nil;
    NSString *serviceControllerCode = @"";
    NSString *prodMainPackage = @"";
    NSString *prodSubservice = @"";
    NSString *txnAmount = @"";
    NSString *serviceFlag = @"";
    NSString *actionPerformed = @"";
    
    UIButton *btn = (UIButton *)sender;
    
    //voice balance
    if (btn.tag == 41)
    {
        
        actionPerformed = @"EasyCliq Optin";
        
        serviceControllerCode = @"MIGRATE_EASY_BRAND";
        prodMainPackage = @"EASYCLIQ";
        prodSubservice = @"EASYCLIQ";
        txnAmount = @"100";
        serviceFlag = @"5";
        
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"txnAmount":txnAmount, @"serviceFlag":serviceFlag };
        
        
        UIButton *button = (UIButton *)sender;
        NSInteger btnNo = button.tag;
        
        NSLog(@":::::: button %ld was clicked ::::::",(long)btnNo);
        
        __weak iPhoneEasyCliqViewController *self_ = self;
        
        if (!alert || !alert.isDisplayed)
        {
            
            alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"" andText:[NSString stringWithFormat:@"\rYou will be charged N100 for this plan. Do you wish to continue?"] andCancelButton:YES forAlertType:AlertInfo];
            [alert.defaultButton setTitle:@"ok" forState:UIControlStateNormal];
            [alert setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:17.0f]];
            alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
            {
                if(button == alertObj.defaultButton)
                {
                    NSLog(@"Default");
                    [self_ performServiceCall:requestData :actionPerformed];
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
    /*
    else if (btn.tag == 42)
    {
        
        actionPerformed = @"EasyCliq Optout";
        
        serviceControllerCode = @"CANCEL_CLIQ_4D_DAY";
        prodMainPackage = @"EASYCLIQ";
        prodSubservice = @"EASYCLIQ";
        
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice };
        
        [self performServiceCall:requestData :actionPerformed];
        
    }
    */
    //show number
    else if (btn.tag == 43)
    {
        
        [self showSelfDismissingAlertViewWithMessage:@"To opt-out, select any other package and opt-in to it. This action will automatically opt you out."];
        
        [self performSelector:@selector(gotoPrepaid) withObject:nil afterDelay:3.0];
        
    }
 
}


-(void)gotoPrepaid
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)performServiceCall:(NSDictionary *)requestData :(NSString *)actionPerformed
{
 
    jsonResponse  = nil;
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    
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
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"EasyCliq"
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
                
                __weak iPhoneEasyCliqViewController *self_ = self;
                
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
               afterDelay:3.0];
    
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


- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end