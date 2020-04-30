//
//  iPadStoresViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadStoresViewController.h"
#import "StoreListCell.h"
#import "GetShopService.h"
#import "OpenInGoogleMapsController.h"

static NSString * const kOpenInMapsSampleURLScheme = @"com.etisalat.easy-mobile://";

@implementation iPadStoresViewController

@synthesize tableview, jsonResponse;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // Position the view within the new parent.
    [[parent view] addSubview:[self view]];
    
    CGRect newFrame = CGRectMake(0, 0, 320, 768);
    [[self view] setFrame:newFrame];

    [tableview setBackgroundColor:[UIColor clearColor]];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1]];
    [self.tableview setSeparatorColor:[UIColor clearColor]];
    [tableview setFrame:CGRectMake(0, 25, 320, 680)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStoreList:) name:@"refreshStoreList" object:nil];
    
    
    [OpenInGoogleMapsController sharedInstance].callbackURL = [NSURL URLWithString:kOpenInMapsSampleURLScheme];
    
    [OpenInGoogleMapsController sharedInstance].fallbackStrategy = kGoogleMapsFallbackChromeThenAppleMaps;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tracker = [[GAI sharedInstance] defaultTracker];
    [self.tracker set:kGAIScreenName value:@"Etisalat Shops"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetchShops];
    
}


-(void)fetchShops
{
    
    [SVProgressHUD show];
    jsonResponse  = nil;
    
    GetShopService *gws = [GetShopService new];
    [gws getShops];
}


- (void)refreshStoreList:(NSNotification *) obj
{
    
    NSArray *stores = (NSArray *) [obj object];
    //NSLog(@"stroes from server -- %@", stores);
    
    [self setJsonResponse:stores];
    
    [self.tableview reloadData];
    [SVProgressHUD dismiss];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"StoreListCell";
    
    StoreListCell *cell =  (StoreListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *eachArray = [[self jsonResponse] objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[eachArray objectForKey:@"name"]];
    [cell.locationLabel setText:[eachArray objectForKey:@"description"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[self jsonResponse] count];
    NSLog(@"length of row :: count  :: %li",(long)count);
    return count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    GoogleDirectionsDefinition *definition = [[GoogleDirectionsDefinition alloc] init];
    
    /*
    GoogleDirectionsWaypoint *destinationPoint = [[GoogleDirectionsWaypoint alloc] init];
    destinationPoint.queryString = @"palms mall, lekki lagos";
    definition.destinationPoint = destinationPoint;
    */
    
    NSDictionary *eachArray = [[self jsonResponse] objectAtIndex:indexPath.row];
    NSString *coordinates = [eachArray objectForKey:@"coordinates"];
    NSArray *strings = [coordinates componentsSeparatedByString:@","];
    float longF = [[strings objectAtIndex:0] floatValue];
    float latF = [[strings objectAtIndex:1] floatValue];
    
    definition.destinationPoint = [GoogleDirectionsWaypoint waypointWithLocation:CLLocationCoordinate2DMake(latF, longF)];
    
    definition.startingPoint = nil;
    definition.travelMode = kGoogleMapsTravelModeWalking;
    
    [[OpenInGoogleMapsController sharedInstance] openDirections:definition];
}


-(void)removeSelfView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.view = nil;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self removeSelfView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMenuView" object:nil userInfo:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end