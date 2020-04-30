//
//  iPadDataServicesViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"

@interface iPadDataServicesViewController : UIViewController  <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *mybtn;
@property (nonatomic, strong) IBOutlet UILabel *myLbl;

@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (nonatomic, strong) NSData *promoImage;
@property (nonatomic, strong) NSString *imageURL;
@property (strong, nonatomic) id<GAITracker> tracker;


@end
