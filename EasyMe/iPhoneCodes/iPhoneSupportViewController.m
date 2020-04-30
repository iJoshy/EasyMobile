//
//  iPhoneSupportViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneSupportViewController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"


@implementation iPhoneSupportViewController

@synthesize mybtn;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tracker = [[GAI sharedInstance] defaultTracker];
    [self.tracker set:kGAIScreenName value:@"Support"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(IBAction)website
{
    [self presentWebViewController:@"http://www.etisalat.com.ng"];
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Website Support" value:nil] build]];
}


-(IBAction)chat
{
    
    // track the event
    [[ZDCChat instance].session trackEvent:@"EasyMobile | iPhone"];
    
    
    // start a chat pushed on to the current navigation controller
    // with session config setting all pre-chat fields as not required
    [ZDCChat startChatIn:self.navigationController withConfig:^(ZDCSessionConfig *config) {
        
        config.preChatDataRequirements.name = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.email = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.phone = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.department = ZDCPreChatDataNotRequired;
        config.preChatDataRequirements.message = ZDCPreChatDataNotRequired;
        config.emailTranscriptAction = ZDCEmailTranscriptActionNeverSend;
    }];
    
    
   [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Chat Support" value:nil] build]];
    
}


-(IBAction)facebook
{
    [self presentWebViewController:@"https://www.facebook.com/etisalatnigeria"];
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Facebook Support" value:nil] build]];
}


-(IBAction)twitter
{
    [self presentWebViewController:@"https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fwww.etisalat.com.ng%2F&screen_name=0809ja_support&text=Kindly%20Support%20me&tw_p=tweetbutton"];
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Twitter Support" value:nil] build]];
}


- (void)presentWebViewController:(NSString *)address
{
    NSURL *URL = [NSURL URLWithString:address];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:webViewController animated:YES completion:NULL];
}


-(IBAction)mail
{
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Email Support" value:nil] build]];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"EasyMobile_Feedback!"];
    
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"care@etisalat.com.ng"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"joshua.balogun@etisalat.com.ng", nil];
    
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    [picker setMessageBody:@"" isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)launchMailAppOnDevice
{
    
    NSString *urlString = @"mailto:care@etisalat.com.ng?subject=EasyMobile_Feedback!";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [ self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Support" action:@"touch" label:@"Email Support" value:nil] build]];
    
}


- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end