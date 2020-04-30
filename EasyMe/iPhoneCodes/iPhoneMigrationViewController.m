//
//  iPhoneMigrationViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneMigrationViewController.h"
#import "AppConstants.h"
#import "iPhoneEasyFlexBundlesViewController.h"
#import "iPhoneEasyLifeBundlesViewController.h"
#import "iPhoneEasyBusinessViewController.h"

@implementation iPhoneMigrationViewController
{
    AMSmoothAlertView * alert;
    AMSmoothAlertView * alertCool;
}

@synthesize mybtn, scrollview, jsonResponse;
@synthesize easybizList, easylifeList, easyflexList;

- (void)viewDidLoad
{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpView];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Migration"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)setUpView
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 650.0)];
    [self.scrollview setBounces:FALSE];
    
}

-(IBAction)easyStarterClicked:(id)sender
{
    [self startProcessing:sender];
}


-(IBAction)easyCliqClicked:(id)sender
{
    [self startProcessing:sender];
}


-(IBAction)easyFlexClicked:(id)sender
{
    
    [SVProgressHUD show];
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    easyflexList  = nil;
    
    NSString *requestData = @"EASYFLEX";
    
    if ([appuser isEqualToString:@"APPLE"])
    {
        PSServerViewController *ps = [PSServerViewController new];
        [ps sendToServer:@"Migration"];
    }
    else
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           WebServiceCall *ws = [[WebServiceCall alloc] init];
                           
                           NSArray *response = [ws categories:requestData];
                           
                           [self setEasyflexList:response];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [SVProgressHUD dismiss];
                               [self processEasyflexData];
                           });
                       });
    }
    
}


-(void)processEasyflexData
{
    //NSLog(@"easyflexList :::: %@",easyflexList);
    
    if ([easyflexList isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:easyflexList];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"EASYFLEXDATA"];
        
        [self performSegueWithIdentifier: @"EasyFlexMigrateSegue" sender:self];
    }
    else
    {
        NSString *StatusDescription = @"This feature is only available with etisalat SIM card. Please turn off WiFi or insert an etisalat SIM card";
        [self showSelfDismissingAlertViewWithMessage:StatusDescription];
    }
    
}


/*
-(IBAction)easyLifeClicked:(id)sender
{
    
    [SVProgressHUD show];
    easylifeList  = nil;
    
    NSString *requestData = @"EASYLIFE";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSArray *response = [ws categories:requestData];
                       
                       [self setEasylifeList:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processEasylifeData];
                       });
                   });
    
}


-(void)processEasylifeData
{
    
    if ([easylifeList isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:easylifeList];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"EASYLIFEDATA"];
        
        [self performSegueWithIdentifier: @"EasyLifeMigrateSegue" sender:self];
    }
    else
    {
        NSString *StatusDescription = @"This feature is only available with etisalat SIM card. Please turn off WiFi or insert an etisalat SIM card";
        [self showSelfDismissingAlertViewWithMessage:StatusDescription];
    }
}
 */


-(IBAction)easyLifeClicked:(id)sender
{
    [self actionTaken:102];
}


-(IBAction)easyBusinessClicked:(id)sender
{
    
    [SVProgressHUD show];
    easybizList  = nil;
    
    NSString *requestData = @"EASYBUSINESS";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSArray *response = [ws categories:requestData];
                       
                       [self setEasybizList:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                           [self processEasybizData];
                       });
                   });
    
}


-(void)processEasybizData
{
    
    if ([easybizList isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:easybizList];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"EASYBIZDATA"];
        
        [self performSegueWithIdentifier: @"EasyBusinessMigrateSegue" sender:self];
    }
    else
    {
        NSString *StatusDescription = @"This feature is only available with etisalat SIM card. Please turn off WiFi or insert an etisalat SIM card";
        [self showSelfDismissingAlertViewWithMessage:StatusDescription];
    }
    
}



- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


-(void)startProcessing:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSInteger btnNo = button.tag;
    
    NSLog(@":::::: button %ld was clicked ::::::",(long)btnNo);
    
    __weak iPhoneMigrationViewController *self_ = self;
    
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
                [self_ actionTaken:btnNo];
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


-(void)actionTaken:(NSInteger)number
{
    
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    jsonResponse  = nil;
    
    NSDictionary *requestData = nil;
    NSString *serviceControllerCode = @"";
    NSString *prodMainPackage = @"";
    NSString *prodSubservice = @"";
    NSString *txnAmount = @"";
    NSString *serviceFlag = @"";
    
    if (number == 100)
    {
        serviceControllerCode = @"MIGRATE_TO_EASY_STARTER";
        prodMainPackage = @"EASYSTARTER";
        prodSubservice = @"EASYSTARTER";
        txnAmount = @"100";
        serviceFlag = @"6";
    }
    else if (number == 101)
    {
        serviceControllerCode = @"MIGRATE_TO_EASY_CLIQ";
        prodMainPackage = @"EASYCLIQ";
        prodSubservice = @"EASYCLIQ";
        txnAmount = @"100";
        serviceFlag = @"5";
    }
    else if (number == 102)
    {
        serviceControllerCode = @"MIGRATE_TO_EASY_LIFE";
        prodMainPackage = @"EASYLIFE";
        prodSubservice = @"EASYLIFE";
        txnAmount = @"0";
        serviceFlag = @"4";
    }
    
    requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"txnAmount":txnAmount, @"serviceFlag":serviceFlag };
    
    
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
                
                if (!alertCool || !alertCool.isDisplayed)
                {
                    
                    alertCool = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alertCool.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alertCool setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alertCool.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
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
                    
                    
                    alertCool.cornerRadius = 3.0f;
                    [alertCool show];
                }
                else
                {
                    [alertCool dismissAlertView];
                }
            }
            else
            {
                
                __weak iPhoneMigrationViewController *self_ = self;
                
                if (!alertCool || !alertCool.isDisplayed)
                {
                    
                    alertCool = [[AMSmoothAlertView alloc]initDropAlertWithTitle:nil andText:serverresponse andCancelButton:NO forAlertType:AlertSuccess];
                    [alertCool.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
                    [alertCool setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0f]];
                    alertCool.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
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
                    
                    
                    alertCool.cornerRadius = 3.0f;
                    [alertCool show];
                }
                else
                {
                    [alertCool dismissAlertView];
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


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end