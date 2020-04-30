//
//  iPadRechargeViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppConstants.h"

@interface iPadRechargeViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *rechargeCode;
@property (nonatomic, strong) NSString *dbPass;
@property (nonatomic, strong) UIAlertView *alertBox;
@property (strong, nonatomic) id<GAITracker> tracker;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@end

