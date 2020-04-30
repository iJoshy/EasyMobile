//
//  iPadSocialViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "Social/Social.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface iPadSocialViewController : UIViewController <UITextFieldDelegate, GPPSignInDelegate>
{
    IBOutlet UIButton *Tweet;
    IBOutlet UIButton *FBPost;
}

@property (nonatomic, strong) IBOutlet UITextField *twitterBtn;
@property (nonatomic, strong) IBOutlet UITextField *googleplusBtn;
@property (nonatomic, strong) IBOutlet UITextField *facebookBtn;

-(IBAction)TweetPressed;
-(IBAction)FBPressed;

@end
