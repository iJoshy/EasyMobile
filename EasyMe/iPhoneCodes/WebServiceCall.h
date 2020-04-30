//
//  WebServiceCall.h
//  TrustFund
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 TrustFund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"

@interface WebServiceCall : UIViewController

- (NSDictionary *)validator:(NSDictionary *)requestData;
- (NSArray *)categories:(NSString *)catType;
- (NSArray *)gifting;
- (NSDictionary *)promotions;
- (NSDictionary *)controllers:(NSDictionary *)requestData;

@end
