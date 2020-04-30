//
//  iPhoneReplaceNumberViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface iPhoneReplaceNumberViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *scrollview;

@property (nonatomic, strong) NSString *dbPass;
@property (nonatomic, strong) UIAlertView *alertBox;
@property (nonatomic, strong) IBOutlet UITextField *number;
@property (nonatomic, strong) IBOutlet UITextField *replaceno;

@property (nonatomic, strong) NSDictionary *jsonResponse;

@end
