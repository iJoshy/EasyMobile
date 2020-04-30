//
//  iPadHomeViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/14/12.
//  Copyright (c) 2012 Etisalat. All rights reserved.
//

#import "iPadHomeViewController.h"
#import "iPadMenuViewController.h"
#import "iPadMyAccountViewController.h"
#import "iPadBuydataViewController.h"
#import "iPadDataPlansViewController.h"
#import "iPadRechargeViewController.h"
#import "iPadRechargeTransferViewController.h"
#import "iPadRechargeOthersViewController.h"
#import "iPadDataServicesViewController.h"
#import "iPadDataTransferViewController.h"
#import "iPadDataGiftingViewController.h"
#import "iPadBuyairtimeViewController.h"
#import "iPadSupportViewController.h"
#import "iPadSocialViewController.h"
#import "iPadStoresViewController.h"

@interface iPadHomeViewController ()
{
    //
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic,retain) NSMutableArray *images;

@end

@implementation iPadHomeViewController
{
    iPadMenuViewController *menuScene;
    
    iPadMyAccountViewController *myAccountScene;
    iPadBuydataViewController *buyDataOptScene;
    iPadDataPlansViewController *dataPlansScene;
    iPadBuyairtimeViewController *buyAirtimeOptScene;
    iPadRechargeViewController *rechargeScene;
    iPadRechargeTransferViewController *airtimeTrxnScene;
    iPadRechargeOthersViewController *rechargeOthersScene;
    
    iPadDataServicesViewController *dataServicesScene;
    iPadDataTransferViewController *dataTransferScene;
    iPadDataGiftingViewController *dataGiftingScene;
    
    iPadSupportViewController *supportScene;
    iPadSocialViewController *socialScene;
    iPadStoresViewController *storesScene;
}



-(void)viewDidLoad
{
    NSLog(@"This is Did load calling ....");
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenuView) name:@"ShowMenuView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyAccountView) name:@"ShowMyAccountView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBuyDataOptionsView) name:@"ShowBuyDataOptionsView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDataPlanView) name:@"ShowDataPlanView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBuyAirtimeOptionsView) name:@"ShowBuyAirtimeOptionsView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRechargeView) name:@"ShowRechargeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAirtimeTransferView) name:@"ShowAirtimeTransferView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRechargeOthersView) name:@"ShowRechargeOthersView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDataServicesView) name:@"ShowDataServicesView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDataTransferView) name:@"ShowDataTransferView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDataGiftingView) name:@"ShowDataGiftingView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSupportView) name:@"ShowSupportView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSocialView) name:@"ShowSocialView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStoresView) name:@"ShowStoresView" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showMyAccountView];
}


-(void)showMenuView
{
    
    if (menuScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        menuScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadMenuViewController"];
        
        [self addChildViewController:menuScene];
        [menuScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:menuScene];
        [menuScene didMoveToParentViewController:self];
    }
    
}


-(void)showMyAccountView
{
    
    if (myAccountScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        myAccountScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadMyAccountViewController"];
        menuScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadMenuViewController"];
        
        [self addChildViewController:myAccountScene];
        [myAccountScene didMoveToParentViewController:self];
        
        [self addChildViewController:menuScene];
        [menuScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:myAccountScene];
        [myAccountScene didMoveToParentViewController:self];
        
        [self addChildViewController:menuScene];
        [menuScene didMoveToParentViewController:self];
    }
    
}


-(void)showBuyDataOptionsView
{
    
    if (buyDataOptScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        buyDataOptScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadBuydataViewController"];
        
        [self addChildViewController:buyDataOptScene];
        [buyDataOptScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:buyDataOptScene];
        [buyDataOptScene didMoveToParentViewController:self];
    }
    
}


-(void)showDataPlanView
{
    
    if (dataPlansScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        dataPlansScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadDataPlansViewController"];
        
        [self addChildViewController:dataPlansScene];
        [dataPlansScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:dataPlansScene];
        [dataPlansScene didMoveToParentViewController:self];
    }
    
}


-(void)showBuyAirtimeOptionsView
{
    
    if (buyAirtimeOptScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        buyAirtimeOptScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadBuyairtimeViewController"];
        
        [self addChildViewController:buyAirtimeOptScene];
        [buyAirtimeOptScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:buyAirtimeOptScene];
        [buyAirtimeOptScene didMoveToParentViewController:self];
    }
    
}


-(void)showRechargeView
{
    
    if (rechargeScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        rechargeScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadRechargeViewController"];
        
        [self addChildViewController:rechargeScene];
        [rechargeScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:rechargeScene];
        [rechargeScene didMoveToParentViewController:self];
    }
    
}


-(void)showAirtimeTransferView
{
    
    if (airtimeTrxnScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        airtimeTrxnScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadRechargeTransferViewController"];
        
        [self addChildViewController:airtimeTrxnScene];
        [airtimeTrxnScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:airtimeTrxnScene];
        [airtimeTrxnScene didMoveToParentViewController:self];
    }
    
}


-(void)showRechargeOthersView
{
    
    if (rechargeOthersScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        rechargeOthersScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadRechargeOthersViewController"];
        
        [self addChildViewController:rechargeOthersScene];
        [rechargeOthersScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:rechargeOthersScene];
        [rechargeOthersScene didMoveToParentViewController:self];
    }
    
}


-(void)showDataServicesView
{
    
    if (dataServicesScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        dataServicesScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadDataServicesViewController"];
        
        [self addChildViewController:dataServicesScene];
        [dataServicesScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:dataServicesScene];
        [dataServicesScene didMoveToParentViewController:self];
    }
    
}


-(void)showDataTransferView
{
    
    if (dataTransferScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        dataTransferScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadDataTransferViewController"];
        
        [self addChildViewController:dataTransferScene];
        [dataTransferScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:dataTransferScene];
        [dataTransferScene didMoveToParentViewController:self];
    }
    
}


-(void)showDataGiftingView
{
    
    if (dataGiftingScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        dataGiftingScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadDataGiftingViewController"];
        
        [self addChildViewController:dataGiftingScene];
        [dataGiftingScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:dataGiftingScene];
        [dataGiftingScene didMoveToParentViewController:self];
    }
    
}


-(void)showSupportView
{
    
    if (supportScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        supportScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadSupportViewController"];
        
        [self addChildViewController:supportScene];
        [supportScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:supportScene];
        [supportScene didMoveToParentViewController:self];
    }
    
}


-(void)showSocialView
{
    
    if (socialScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        socialScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadSocialViewController"];
        
        [self addChildViewController:socialScene];
        [socialScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:socialScene];
        [socialScene didMoveToParentViewController:self];
    }
    
}


-(void)showStoresView
{
    
    if (storesScene == nil)
    {
        UIStoryboard *storyboard = [self storyboard];
        storesScene = [storyboard instantiateViewControllerWithIdentifier:@"iPadStoresViewController"];
        
        [self addChildViewController:storesScene];
        [storesScene didMoveToParentViewController:self];
        
    }
    else
    {
        [self addChildViewController:storesScene];
        [storesScene didMoveToParentViewController:self];
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
}


@end
