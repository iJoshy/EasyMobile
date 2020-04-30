//
//  iPhoneMenuViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppConstants.h"

@interface iPhoneMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITableView* tableMenuView;
@property (nonatomic, strong) NSMutableArray *myArray;
@property (nonatomic, strong) IBOutlet UIImageView *profilepic;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *phoneLbl;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) id<GAITracker> tracker;

@end
