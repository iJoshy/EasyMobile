//
//  iPadRechargeOthersViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppConstants.h"

@interface iPadRechargeOthersViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *scrollview;

@property (nonatomic, strong) NSString *dbPass;
@property (nonatomic, strong) UIAlertView *alertBox;
@property (nonatomic, strong) IBOutlet UITextField *rechargeCode;
@property (nonatomic, strong) IBOutlet UITextField *receiversNo;

@property (nonatomic, strong) NSDictionary *jsonResponse;

@end

