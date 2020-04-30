//
//  iPhoneEvolutionDataViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneEvolutionDataViewController.h"
#import "ShadowButton.h"


@implementation iPhoneEvolutionDataViewController
{
    AMSmoothAlertView *alert;
    AMSmoothAlertView *alertCool;
}

@synthesize easyLifeList, jsonResponse, priceAr, codeAr;
@synthesize scrollview, popupAr;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    priceAr = [[NSMutableArray alloc] init];
    codeAr = [[NSMutableArray alloc] init];
    popupAr = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"EASYFLEXEVOLUTIONDATA"];
    easyLifeList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSArray * dataContent = [self easyLifeList];
    int lengthOfBundles = (int)[dataContent count];
    int yLength = 105;
    int scrollLen =  333.0;
    
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, scrollLen)];
    [self.scrollview setBounces:FALSE];
    
    
    int i = 0, btncount = 0, multiplier = 0;
    
    //NSLog(@" lengthOfBundles == %d\n", lengthOfBundles);
    
    while ( i < lengthOfBundles )
    {
        
        //buttons
        NSDictionary *eachArray3 = [dataContent objectAtIndex:i];
        ShadowButton *button3 = [ShadowButton buttonWithType:UIButtonTypeCustom];
        [button3 addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        button3.frame = CGRectMake(20.0, (4.0 + (yLength * i)), 311.0, 100.0);
        button3.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:147.0/255.0 blue:0.0/255.0 alpha:1];
        button3.tag = i;
        
        UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 250, 70)];
        [lbl3 setFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:18.0]];
        lbl3.lineBreakMode = NSLineBreakByWordWrapping;
        lbl3.textAlignment = NSTextAlignmentCenter;
        lbl3.numberOfLines = 3;
        lbl3.textColor = [UIColor whiteColor];
        lbl3.text = [eachArray3 objectForKey:@"displayText"];
        [priceAr addObject:[eachArray3 objectForKey:@"amount"]];
        [codeAr addObject:[eachArray3 objectForKey:@"serviceFlag"]];
        [popupAr addObject:[eachArray3 objectForKey:@"popupMsg"]];
        
        [button3 addSubview:lbl3];
        [self.scrollview addSubview:button3];
        
        i+=1;
        btncount+=1;
        
        if (i > 3)
            multiplier += 1;
        
    }
    
    if ( multiplier > 0 )
    {
        int adder = (multiplier * yLength);
        int newScrollLen = adder + scrollLen;
        
        //NSLog(@"multiplier == %d\t,adder == %d\t,newScrollLen == %d\t", multiplier, adder, newScrollLen);
        
        [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, newScrollLen)];
        [self.scrollview setBounces:FALSE];
    }

    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tracker = [[GAI sharedInstance] defaultTracker];
    [self.tracker set:kGAIScreenName value:@"Easyflex Evolution Data"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(IBAction)clickedBtn:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSInteger btnNo = button.tag;
    
    NSLog(@":::::: button %ld was clicked ::::::",(long)btnNo);
    
    NSString *priceStr = [priceAr objectAtIndex:btnNo];
    NSString *popupStr = [popupAr objectAtIndex:btnNo];
    
    NSString *displayMessage = popupStr;
    
    __weak iPhoneEvolutionDataViewController *self_ = self;
    
    if (!alertCool || !alertCool.isDisplayed)
    {
        
        alertCool = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"" andText:displayMessage andCancelButton:YES forAlertType:AlertInfo];
        [alertCool.defaultButton setTitle:@"ok" forState:UIControlStateNormal];
        [alertCool setTitleFont:[UIFont fontWithName:@"NeoTechAlt-Medium" size:17.0f]];
        alertCool.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
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
        
        
        alertCool.cornerRadius = 3.0f;
        [alertCool show];
    }
    else
    {
        [alertCool dismissAlertView];
    }
    
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Easyflex Evolution Data"
                                                                action:@"touch"
                                                                 label:[NSString stringWithFormat:@"flex %@ bundle",priceStr]
                                                                 value:nil] build]];
    
}


-(void)actionTaken:(NSInteger)number
{
    
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    jsonResponse  = nil;
    
    NSDictionary *requestData = nil;
    NSString *serviceControllerCode = @"";
    NSString *prodMainPackage = @"";
    NSString *prodSubservice = @"";
    NSString *txnAmount = @"";
    NSString *serviceFlag = @"";
    
    serviceControllerCode = @"MIGRATE_TO_EASY_FLEX";
    prodMainPackage = @"EASYFLEX";
    prodSubservice = @"EASYFLEX";
    txnAmount = [priceAr objectAtIndex:number];
    serviceFlag = [codeAr objectAtIndex:number];
    
    requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"txnAmount":txnAmount, @"serviceFlag":serviceFlag };
    
    
    if ([appuser isEqualToString:@"APPLE"])
    {
        PSServerViewController *ps = [PSServerViewController new];
        [ps sendToServer:@"Easyflex Evolution Data"];
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
                
                __weak iPhoneEvolutionDataViewController *self_ = self;
                
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