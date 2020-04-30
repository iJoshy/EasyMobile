//
//  iPhoneEasyLifeBundlesViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppConstants.h"

@interface iPhoneEasyLifeBundlesViewController : UIViewController 

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;

@property (nonatomic, strong) NSArray *easyLifeList;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSMutableArray *priceAr;
@property (nonatomic, strong) NSMutableArray *codeAr;
@property (nonatomic, strong) NSMutableArray *popupAr;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
