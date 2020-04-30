//
//  iPhoneEvolutionViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"

@interface iPhoneEvolutionViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) NSArray *easyflexList;
@property (nonatomic, strong) NSDictionary *jsonResponse;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
