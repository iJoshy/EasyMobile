//
//  iPhoneMigrationViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneMigrationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UIButton *mybtn;
@property (nonatomic, strong) IBOutlet UILabel *myLbl;
@property (nonatomic, strong) NSDictionary *jsonResponse;

@property (nonatomic, strong) NSArray *easyflexList;
@property (nonatomic, strong) NSArray *easylifeList;
@property (nonatomic, strong) NSArray *easybizList;

@end
