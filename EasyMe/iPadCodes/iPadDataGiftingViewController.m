//
//  iPadDataGiftingViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadDataGiftingViewController.h"
#import "AppConstants.h"

@implementation iPadDataGiftingViewController
{
    AMSmoothAlertView * alert;
    AMSmoothAlertView * alertCool;
}

@synthesize scrollview, dropdown, receiversNo, jsonResponse, amount;
@synthesize alertView, tableListView, dataplans, alertBox, dbPass;


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
    
    
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, 290.0)];
    [self.scrollview setBounces:FALSE];
    
    
    UIImageView *usernameicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down.png"]];
    usernameicon.frame = CGRectMake(0.0, 0.0, usernameicon.image.size.width+30.0, usernameicon.image.size.height);
    usernameicon.contentMode = UIViewContentModeCenter;
    self.dropdown.rightView = usernameicon;
    self.dropdown.rightViewMode = UITextFieldViewModeAlways;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.dropdown.superview addGestureRecognizer:tapGesture];
    
    [self getGiftData];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Data Gifting"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)getGiftData
{
    
    [SVProgressHUD show];
    dataplans  = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       WebServiceCall *ws = [[WebServiceCall alloc] init];
                       
                       NSArray *response = [ws gifting];
                       
                       [self setDataplans:response];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [SVProgressHUD dismiss];
                       });
                   });
    
}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(self.dropdown.frame, point))
        {
            // Here we need to pass a full frame
            alertView = [[CustomIOSAlertView alloc] init];
            
            // Add some custom content to the alert view
            [alertView setContainerView:[self createDemoView]];
            
            // Modify the parameters
            [alertView setButtonTitles:nil];
            [alertView setDelegate:self];
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
        }
    }
}


- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 300)];
    
    tableListView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 270, 280)];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    //dataplans = [[NSMutableArray alloc] initWithObjects:@"EasyBlaze 10MB",@"EasyBlaze 50MB",@"EasyBlaze Night/Weekend",@"EasyBlaze 200MB",@"EasyBlaze 2GB",@"EasyBlaze 3GB",@"EasyBlaze 5GB",@"EasyBlaze 8GB",@"EasyBlaze 10GB",@"EasyBlaze 15GB",@"EasyBlaze 20GB",@"Smartphone 200MB",@"Smartphone 2GB",@"Smartphone 3GB",@"Smartphone 5GB",@"Smartphone 8GB", nil];
    
    [self.tableListView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tableListView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [demoView addSubview:tableListView];
    
    return demoView;
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)outalertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[outalertView tag]);
    [outalertView close];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.dataplans count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Please choose a dataplan ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell= @"Menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: Cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *eachArray = [self.dataplans objectAtIndex:indexPath.row];
    cell.textLabel.text = [eachArray objectForKey:@"name"];
    cell.textLabel.font=[UIFont fontWithName:@"NeoTechAlt" size:13.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@" name :: %@", cell.textLabel.text);
    NSLog(@" amount :: %@", amount);
    
    dropdown.text = cell.textLabel.text;
    [alertView close];
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
    
    NSLog(@"My rechargecode is : %@",receiversNo.text);
    
    if ( receiversNo.text.length == 0 )
    {
        [self EmptyField];
    }
    else if ( receiversNo.text.length > 0 && receiversNo.text.length < 11 )
    {
        [self TooShortField];
    }
    else if ( receiversNo.text.length > 11 )
    {
        [self TooLongField];
    }
    else if ( receiversNo.text.length == 11 )
    {
        
        NSDictionary *eachArray = [self.dataplans objectAtIndex:[tableListView indexPathForSelectedRow].row];
        amount = [eachArray objectForKey:@"cost"];
        int amtInt = amount.intValue / 100;
        amount = [NSString stringWithFormat:@"%d",amtInt];
        
        
        NSString *displayMessage = [NSString stringWithFormat:@"You will be charged N%@ for this gift plan. Do you wish to continue?",amount];
        
        __weak iPadDataGiftingViewController *self_ = self;
        
        if (!alertCool || !alertCool.isDisplayed)
        {
            
            alertCool = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"etisalat" andText:displayMessage andCancelButton:YES forAlertType:AlertInfo];
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

- (void)actionTaken
{
    
    NSString *appuser = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPUSER"];
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    
    if ([appuser isEqualToString:@"APPLE"])
    {
        PSServerViewController *ps = [PSServerViewController new];
        [ps sendToServer:@"Data Gifting"];
    }
    else
    {
        jsonResponse  = nil;
        
        NSDictionary *requestData = nil;
        NSString *destinationMsisdnOne = receiversNo.text;
        NSString *serviceControllerCode = @"SUBSCRIBER_GIFT_DATA";
        NSString *prodMainPackage = @"SUBSCRIBER_GIFT_DATA";
        NSString *prodSubservice = @"SUBSCRIBER_GIFT_DATA";
        NSString *serviceFlag = [self dataplancode:(int)[tableListView indexPathForSelectedRow].row];
        
        requestData = @{ @"versionNo":versionNo, @"originatingMsisdn":originatingMsisdn, @"osType":osType, @"destinationMsisdnOne":destinationMsisdnOne, @"serviceControllerCode":serviceControllerCode, @"prodMainPackage":prodMainPackage, @"prodSubservice":prodSubservice, @"serviceFlag":serviceFlag };
        
        
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


-(NSString *)dataplancode:(int)selected
{
    NSDictionary *eachArray = [self.dataplans objectAtIndex:selected];
    NSString *dataplancode = [eachArray objectForKey:@"wsCode"];
    
    return dataplancode;
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
                
                __weak iPadDataGiftingViewController *self_ = self;
                
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
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"This field cannot be blank !" message:@"\nKindly fill-in the value correctly.\n\nreceivers no - 11 digits" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
}

-(void) TooShortField
{
    //NSLog(@"Call in recharge view ....");
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"This field is too short !" message:@"\nKindly fill-in the value correctly.\n\nreceivers no - 11 digits" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
}

-(void) TooLongField
{
    //NSLog(@"Call in recharge view ....");
    
    alertBox = [[UIAlertView alloc] initWithTitle:@"This field is too long !" message:@"\nKindly fill-in the value correctly.\n\nreceivers no - 11 digits" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertBox show];
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDataServicesView" object:nil userInfo:nil];
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