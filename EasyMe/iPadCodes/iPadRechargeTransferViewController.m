//
//  iPadRechargeTransferViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadRechargeTransferViewController.h"
#import "AppConstants.h"

@implementation iPadRechargeTransferViewController
{
    AMSmoothAlertView * alert;
    AMSmoothAlertView * alertCool;
}

@synthesize scrollview, dbPass, securityCode, receiversNo;
@synthesize amount, alertBox, jsonResponse;

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
    
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 471.0)];
    [self.scrollview setBounces:FALSE];
    
    dbPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"PASSWORD"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Airtime Transfer"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^([0-9]+)?$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    
    return YES;
    
}


-(IBAction)clickedBtn:(id)sender
{
    
    if ( securityCode.text.length == 0 || receiversNo.text.length == 0  || amount.text.length == 0)
    {
        [self EmptyField];
    }
    else
    {
        
        if ( ( securityCode.text.length > 0 && securityCode.text.length < 4 ) ||
            ( receiversNo.text.length > 0 && receiversNo.text.length < 11 ) ||
            ( amount.text.length > 0 && amount.text.length < 2 ) )
        {
            [self TooShortField];
        }
        else
        {
            
            if ( securityCode.text.length > 4  || receiversNo.text.length > 11 || amount.text.length > 5 )
            {
                [self TooLongField];
            }
            else
            {
                
                if ( securityCode.text.length == 4 && receiversNo.text.length == 11 )
                {
                    /*
                     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n"
                     delegate:self
                     cancelButtonTitle:nil
                     destructiveButtonTitle:nil
                     otherButtonTitles:nil];
                     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.0, 0.0, 280.0, 170.0)];
                     titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
                     titleLabel.textAlignment = NSTextAlignmentCenter;
                     titleLabel.numberOfLines = 8;
                     titleLabel.text = [NSString stringWithFormat:@"Confirm your entry \n\n security code : %@ \n\n receivers no : %@ \n\n amount : N%@",securityCode.text,receiversNo.text, amount.text];
                     
                     actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle: @"Send"];
                     actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle: @"Cancel"];
                     
                     if([[[UIDevice currentDevice] systemVersion] integerValue] < 7)
                     {
                     titleLabel.backgroundColor = [UIColor clearColor];
                     titleLabel.textColor = [UIColor whiteColor];
                     [actionSheet addSubview:titleLabel];
                     //[actionSheet showFromRect:CGRectMake(147, 280, 25, 25) inView:self.view animated:YES];
                     [actionSheet showInView:self.navigationController.toolbar];
                     }
                     else
                     {
                     [actionSheet addSubview:titleLabel];
                     //[actionSheet showFromRect:CGRectMake(0, 100, 25, 25) inView:self.view animated:YES];
                     [actionSheet showInView:self.navigationController.toolbar];
                     }
                     */
                    
                    __weak iPadRechargeTransferViewController *self_ = self;
                    
                    if (!alertCool || !alertCool.isDisplayed)
                    {
                        
                        alertCool = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Confirm your entry" andText:[NSString stringWithFormat:@"\nsecurity code : %@ \nnumber : %@ \namount : %@",securityCode.text,receiversNo.text, amount.text] andCancelButton:YES forAlertType:AlertInfo];
                        [alertCool.defaultButton setTitle:@"ok" forState:UIControlStateNormal];
                        [alertCool setTitleFont:[UIFont fontWithName:@"NeoTechAlt" size:17.0f]];
                        alertCool.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button)
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
    
}

- (void)actionTaken
{
    
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    NSString *actionPerformed = @"Airtime Transfer";
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    
    if ([appuser isEqualToString:@"APPLE"])
    {
        PSServerViewController *ps = [PSServerViewController new];
        [ps sendToServer:actionPerformed];
    }
    else
    {
        jsonResponse  = nil;
        
        NSDictionary *requestData = nil;
        NSString *destinationMsisdnOne = receiversNo.text;
        NSString *serviceControllerCode = @"SUBCRIBER_ACCOUNT_TRANSFER";
        NSString *prodMainPackage = @"SUBCRIBER_ACCOUNT_TRANSFER";
        NSString *prodSubservice = @"SUBCRIBER_ACCOUNT_TRANSFER";
        NSString *txnAmount = amount.text;
        NSString *passKey = securityCode.text;
        
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"destinationMsisdnOne":destinationMsisdnOne, @"osType":osType, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"passKey":passKey, @"txnAmount":txnAmount };
        
        
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
                
                __weak iPadRechargeTransferViewController *self_ = self;
                
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


-(void) EmptyField
{
    //NSLog(@"Call in recharge view ....");
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"Field cannot be blank !" message:@"\nKindly fill-in the values correctly.\n\nsecurity code - 4 digits\n\nreceivers no - 11 digits\n\namount - (between N10 and N20000)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
}

-(void) TooShortField
{
    //NSLog(@"Call in recharge view ....");
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"Field is too short !" message:@"\nKindly fill-in the values correctly.\n\nsecurity code - 4 digits\n\nreceivers no - 11 digits\n\namount - (between N10 and N20000)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
}

-(void) TooLongField
{
    //NSLog(@"Call in recharge view ....");
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"Field is too long !" message:@"\nKindly fill-in the values correctly.\n\nsecurity code - 4 digits\n\nreceivers no - 11 digits\n\namount - (between N10 and N20000)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //self.view.hidden = NO;
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


@end