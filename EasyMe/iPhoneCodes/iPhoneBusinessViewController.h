//
//  iPhoneBusinessViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppConstants.h"

@interface iPhoneBusinessViewController : UIViewController

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;

@property (nonatomic, strong) NSArray *easyBizList;
@property (nonatomic, strong) NSArray *easyExecList;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
