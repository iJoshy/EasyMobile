//
//  iPhoneDataPlansViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface iPhoneDataPlansViewController : UIViewController 

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIButton *mybtn;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSMutableArray *priceAr;
@property (nonatomic, strong) NSMutableArray *codeAr;
@property (nonatomic, strong) NSMutableArray *planAr;
@property (nonatomic, strong) NSMutableArray *popupAr;
@property (nonatomic, strong) NSMutableArray *iswAr;
@property (nonatomic, strong) NSString *paymode;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
