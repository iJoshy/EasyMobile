//
//  AppDelegate.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/14/12.
//  Copyright (c) 2012 Etisalat. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "AppConstants.h"
#import "ChatStyling.h"
#import <Google/Analytics.h>
#import <GooglePlus/GooglePlus.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self styleApp];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Chat setup
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    // apply appearance styling first if you want to customise the look of the chat
    [ChatStyling applyStyling];
    
    // configure account key and pre-chat form
    [ZDCChat configure:^(ZDCConfig *defaults) {
        
        defaults.accountKey = @"3JkPUVZBvdar5TUl8GqHPUgO9mTPDmHO";
        defaults.preChatDataRequirements.name = ZDCPreChatDataOptionalEditable;
        defaults.preChatDataRequirements.email = ZDCPreChatDataOptionalEditable;
        defaults.preChatDataRequirements.phone = ZDCPreChatDataOptionalEditable;
        defaults.preChatDataRequirements.department = ZDCPreChatDataOptionalEditable;
        defaults.preChatDataRequirements.message = ZDCPreChatDataOptional;
    }];
    
    // To override the default avatar uncomment and complete the image name
    //[[ZDCChatAvatar appearance] setDefaultAvatar:@"your_avatar_name_here"];
    
    // Uncomment to disable visitor data persistence between application runs
    //[[ZDCChat instance].session visitorInfo].shouldPersist = NO;
    
    // Uncomment if you don't want open chat sessions to be automatically resumed on application launch
    //[ZDCChat instance].shouldResumeOnLaunch = NO;
    
    // remember to switch off debug logging before app store submission!
    [ZDCLog enable:YES];
    [ZDCLog setLogLevel:ZDCLogLevelWarn];
    
    
    // Register for Push Notitications
    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions appId:@"80188c8a-ea6d-4a79-a2ec-63f9e0fc4622" handleNotification:nil];
    
    
    
    // [START tracker_objc]
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    //gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    // [END tracker_objc]
    
    
    
    [NSThread sleepForTimeInterval:3];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    if (idiom == UIUserInterfaceIdiomPhone)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:[NSBundle mainBundle]];
        MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideMenuViewController"];
        
        [container setLeftMenuViewController:leftSideMenuViewController];
        [container setCenterViewController:navigationController];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FIRSTTIME"];
    
    return YES;
    
}


- (void) styleApp
{
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([ZDUUtil isVersionOrNewer:@(7)])
    {
        
        // nav bar
        NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:38.0/255.0 green:47.0/255.0 blue:56.0/255.0 alpha:1]];
        
        
        if ([ZDUUtil isVersionOrNewer:@(8)])
        {
            
            // For translucent nav bars set YES
            [[UINavigationBar appearance] setTranslucent:NO];
        }
        
        // For a completely transparent nav bar uncomment this and set 'translucent' above to YES
        // (you may also want to change the title text and tint colors above since they are white by default)
        //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        //[[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //[[UINavigationBar appearance] setShadowImage:[UIImage new]];
        //[[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
        
    }
    else
    {
        
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:38.0/255.0 green:47.0/255.0 blue:56.0/255.0 alpha:1]];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight )
        return (YES);
    return (NO);
}


- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}


@end
