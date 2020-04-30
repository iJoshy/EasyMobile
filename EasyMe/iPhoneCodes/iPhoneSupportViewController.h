//
//  iPhoneSupportViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZDCChat/ZDCChat.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppConstants.h"

@interface iPhoneSupportViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *mybtn;
@property (nonatomic, strong) IBOutlet UILabel *myLbl;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
