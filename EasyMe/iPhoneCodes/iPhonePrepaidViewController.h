//
//  iPhonePrepaidViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhonePrepaidViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIButton *mybtn;
@property (nonatomic, strong) IBOutlet UILabel *myLbl;

@property (nonatomic, strong) NSArray *easybizList;

@end
