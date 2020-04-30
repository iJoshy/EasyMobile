//
//  AppDelegate.h
//  EasyMobile
//
//  Created by Joshua Balogun on 11/14/12.
//  Copyright (c) 2012 Etisalat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneSignal/OneSignal.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OneSignal *oneSignal;

@end
