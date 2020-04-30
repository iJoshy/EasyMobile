//
//  iPadSocialViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadSocialViewController.h"
#import "MFSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface iPadSocialViewController ()

@end

@implementation iPadSocialViewController

static NSString * const kClientID = @"132399761676-09648smpdegcnj7r19q8i8rc3pat0ljo.apps.googleusercontent.com";

@synthesize facebookBtn, twitterBtn, googleplusBtn;

- (void)viewDidLoad
{
    
    [self setUpView];
    
    [super viewDidLoad];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // Position the view within the new parent.
    [[parent view] addSubview:[self view]];
    
    CGRect newFrame = CGRectMake(320, 0, 700, 768);
    [[self view] setFrame:newFrame];
}


-(void)setUpView
{
    
    
    //facebook
    self.facebookBtn.layer.cornerRadius = 26.0;
    self.facebookBtn.layer.borderWidth = 1.0;
    self.facebookBtn.layer.masksToBounds = YES;
    self.facebookBtn.layer.borderColor = [[UIColor colorWithRed:0.271 green:0.380 blue:0.647 alpha:1.000] CGColor];
    self.facebookBtn.layer.sublayerTransform = CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f);
    
    UIImageView *facebookicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook"]];
    facebookicon.frame = CGRectMake(0.0, 0.0, facebookicon.image.size.width+30.0, facebookicon.image.size.height);
    facebookicon.contentMode = UIViewContentModeCenter;
    self.facebookBtn.leftView = facebookicon;
    self.facebookBtn.leftViewMode = UITextFieldViewModeAlways;
    
    self.facebookBtn.text = @"Share on Facebook";
    self.facebookBtn.textColor = [UIColor whiteColor];
    self.facebookBtn.backgroundColor = [UIColor colorWithRed:0.271 green:0.380 blue:0.647 alpha:1.000];
    
    
    UITapGestureRecognizer *fbTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.facebookBtn.superview addGestureRecognizer:fbTapGesture];
    
    
    
    //twitter
    self.twitterBtn.layer.cornerRadius = 26.0;
    self.twitterBtn.layer.borderWidth = 1.0;
    self.twitterBtn.layer.masksToBounds = YES;
    self.twitterBtn.layer.borderColor = [[UIColor colorWithRed:0.263 green:0.820 blue:0.926 alpha:1.000] CGColor];
    self.twitterBtn.layer.sublayerTransform = CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f);
    
    UIImageView *twittericon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter"]];
    twittericon.frame = CGRectMake(0.0, 0.0, twittericon.image.size.width+30.0, twittericon.image.size.height);
    twittericon.contentMode = UIViewContentModeCenter;
    self.twitterBtn.leftView = twittericon;
    self.twitterBtn.leftViewMode = UITextFieldViewModeAlways;
    
    self.twitterBtn.text = @"Share on Twitter";
    self.twitterBtn.textColor = [UIColor whiteColor];
    self.twitterBtn.backgroundColor = [UIColor colorWithRed:0.263 green:0.820 blue:0.926 alpha:1.000];
    
    UITapGestureRecognizer *twTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.twitterBtn.superview addGestureRecognizer:twTapGesture];
    
    
    
    //googleplus
    self.googleplusBtn.layer.cornerRadius = 26.0;
    self.googleplusBtn.layer.borderWidth = 1.0;
    self.googleplusBtn.layer.masksToBounds = YES;
    self.googleplusBtn.layer.borderColor = [[UIColor colorWithRed:0.851 green:0.322 blue:0.196 alpha:1.000] CGColor];
    self.googleplusBtn.layer.sublayerTransform = CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f);
    
    UIImageView *googleicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"googleplus"]];
    googleicon.frame = CGRectMake(0.0, 0.0, googleicon.image.size.width+30.0, googleicon.image.size.height);
    googleicon.contentMode = UIViewContentModeCenter;
    self.googleplusBtn.leftView = googleicon;
    self.googleplusBtn.leftViewMode = UITextFieldViewModeAlways;
    
    self.googleplusBtn.text = @"Share on Google+";
    self.googleplusBtn.textColor = [UIColor whiteColor];
    self.googleplusBtn.backgroundColor = [UIColor colorWithRed:0.851 green:0.322 blue:0.196 alpha:1.000];
    
    UITapGestureRecognizer *gpTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.googleplusBtn.superview addGestureRecognizer:gpTapGesture];
    
}


- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(self.facebookBtn.frame, point))
        {
            [self FBPressed];
        }
        else if (CGRectContainsPoint(self.twitterBtn.frame, point))
        {
            [self TweetPressed];
        }
        else if (CGRectContainsPoint(self.googleplusBtn.frame, point))
        {
            [self GooglePressed];
        }
    }
}


-(IBAction)FBPressed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPostSheet setInitialText:@"I use EasyMobile App to manage my Etisalat account & its awesome! You can download using this link: https://goo.gl/3AuKGE"];
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign-in Error"
                                                            message:@"You can't post right now, make sure your device has an internet connection and you have at least one Facebook account setup in Settings"
                                                           delegate:self
                                                  cancelButtonTitle: @"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        [alertView show];
    }
}


-(IBAction)TweetPressed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"I use EasyMobile App to manage my Etisalat account & its awesome! You can download using this link: https://goo.gl/3AuKGE"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign-in Error"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup in Settings"
                                                           delegate:self
                                                  cancelButtonTitle: @"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        [alertView show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


-(IBAction)GooglePressed
{
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    [signIn authenticate];
}


- (void)finishedSharingWithError:(NSError *)error
{
    NSString *text;
    
    if (!error)
    {
        text = @"Google+ post was shared successfully";
    }
    else if (error.code == kGPPErrorShareboxCanceled)
    {
        text = @"Google+ post was cancelled";
    }
    else
    {
        text = [NSString stringWithFormat:@"Error (%@)", [error localizedDescription]];
    }
    
    [self showSelfDismissingAlertViewWithMessage:text];
    NSLog(@"Status: %@", text);
    
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://etisalat.com.ng/"]];
    [shareBuilder setPrefillText:@"I use EasyMobile App to manage my Etisalat account & its awesome! You can download using this link: https://goo.gl/3AuKGE"];
    [shareBuilder setContentDeepLinkID:kClientID];
    [shareBuilder open];
    
}

- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
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