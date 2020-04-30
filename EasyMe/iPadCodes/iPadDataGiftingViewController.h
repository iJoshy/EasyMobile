//
//  iPadDataGiftingViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface iPadDataGiftingViewController : UIViewController <CustomIOSAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITextField *dropdown;
@property (nonatomic, strong) IBOutlet UITextField *receiversNo;
@property (nonatomic, strong) NSString *dbPass;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) UIAlertView *alertBox;

@property (nonatomic, strong) NSDictionary *jsonResponse;

@property (strong, nonatomic) CustomIOSAlertView *alertView;
@property (strong, nonatomic) UITableView *tableListView;
@property(nonatomic, strong) NSArray *dataplans;

@end
