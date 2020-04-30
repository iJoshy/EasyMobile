//
//  iPhoneEasyStarterViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneEasyStarterViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) NSString *dbPass;
@property (nonatomic, strong) NSDictionary *jsonResponse;

@end
