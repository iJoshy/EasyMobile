//
//  iPhoneBuydataViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface iPhoneBuydataViewController : UIViewController

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (nonatomic, strong) NSArray *easyblazeList;
@property (nonatomic, strong) NSString *buttonPressed;
@property (nonatomic, strong) NSDictionary *jsonResponse;

@end

