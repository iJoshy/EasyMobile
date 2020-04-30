//
//  iPadMyAccountViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"

@interface iPadMyAccountViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *mybtn;
@property (nonatomic, strong) IBOutlet UILabel *myLbl;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
