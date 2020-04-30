//
//  iPhoneMenuViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPhoneMenuViewController.h"
#import "iPhoneMyAccountViewController.h"
#import "iPhoneDataServicesViewController.h"
#import "iPhonePrepaidViewController.h"
#import "iPhoneBlackberryViewController.h"
#import "iPhoneMigrationViewController.h"
#import "iPhoneSupportViewController.h"
#import "iPhoneStoresViewController.h"
#import "iPhoneSocialViewController.h"
#import "MFSideMenu.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Google/Analytics.h>


@implementation iPhoneMenuViewController

@synthesize nameLbl, phoneLbl;
@synthesize tableMenuView, myArray;
@synthesize profilepic;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [tableMenuView setDelegate:self];
    [tableMenuView setDataSource:self];
    
    myArray = [NSMutableArray array];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"my account", @"title",
                          @"\uf015", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"prepaid", @"title",
                          @"\uf10b", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"data services", @"title",
                          @"\uf233", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"etisalat stores", @"title",
                          @"\uf1ad", @"image", nil]];
    
    /*
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"migration", @"title",
                          @"\uf08e", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"support", @"title",
                          @"\uf0ad", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"social media", @"title",
                        @"\uf0c0", @"image", nil]];
     */
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"support", @"title",
                        @"\uf0ad", @"image", nil]];
    
    [self.tableMenuView reloadData];
    
    
    profilepic.layer.cornerRadius = 60.0;
    profilepic.layer.borderWidth = 2.0;
    profilepic.layer.masksToBounds = YES;
    profilepic.layer.borderColor = [[UIColor whiteColor] CGColor];
    profilepic.layer.sublayerTransform = CATransform3DMakeTranslation(12.0f, 0.0f, 0.0f);
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMAGEPATH"];
    if (data)
    {
        NSDictionary *uploadMediaPath = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        profilepic.image = uploadMediaPath[UIImagePickerControllerEditedImage];
    }
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePctureTapped:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    profilepic.userInteractionEnabled = YES;
    [profilepic addGestureRecognizer:tapRecognizer];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Menu"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


#pragma tableview delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.myArray count];
    //NSLog(@"length of row :: count  :: %li",(long)count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell= @"Menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: Cell];
    }
    
    NSDictionary *eachArray = [self.myArray objectAtIndex:indexPath.row];

    cell.textLabel.text = [eachArray objectForKey:@"title"];
    cell.textLabel.font=[UIFont fontWithName:@"NeoTechAlt-Medium" size:20.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 20, 20)];
    
    NSUInteger row = [indexPath row];
    if (row == 0)
        label.font = [UIFont fontWithName:@"FontAwesome" size:22];
    else if (row == 1)
        label.font = [UIFont fontWithName:@"FontAwesome" size:28];
    else if (row == 4)
        label.font = [UIFont fontWithName:@"FontAwesome" size:18];
    else
        label.font = [UIFont fontWithName:@"FontAwesome" size:20];
    
    label.text =  [eachArray objectForKey:@"image"];
    label.textColor = [UIColor darkGrayColor];
    [cell addSubview:label];
    
    [cell setIndentationLevel:3];
    [cell setIndentationWidth:20];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers;
    
    if (row == 0)
    {
        iPhoneMyAccountViewController *myAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhoneMyAccountViewController"];
        controllers = [NSArray arrayWithObject:myAccountVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (row == 1)
    {
        iPhonePrepaidViewController *prepaidVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhonePrepaidViewController"];
        controllers = [NSArray arrayWithObject:prepaidVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (row == 2)
    {
        iPhoneDataServicesViewController *dataServicesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhoneDataServicesViewController"];
        controllers = [NSArray arrayWithObject:dataServicesVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (row == 3)
    {
        iPhoneStoresViewController *storesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhoneStoresViewController"];
        controllers = [NSArray arrayWithObject:storesVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (row == 4)
    {
        iPhoneSupportViewController *supportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhoneSupportViewController"];
        controllers = [NSArray arrayWithObject:supportVC];
        
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    
}



-(IBAction)profilePctureTapped:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"change profile photo !"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:@"take photo"
                                                    otherButtonTitles:@"choose from library", nil];

    [actionSheet showInView:self.view];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            UIAlertView *altnot=[[UIAlertView alloc]initWithTitle:@"Camera Not Available" message:@"Camera Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            altnot.tag=101;
            [altnot show];
        }
    }
    else if (buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
    }
    else
    {
        //NSLog(@"The Color selection action sheet.");
    }
    
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *)kUTTypeImage, nil];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.imagePickerController = imagePicker;
    }
    else 
    {
        self.imagePickerController = imagePicker;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    profilepic.image = info[UIImagePickerControllerEditedImage];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"IMAGEPATH"];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}


-(IBAction)socialClicked:(id)sender
{
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;;
    NSArray *controllers;
    
    iPhoneSocialViewController *socialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iPhoneSocialViewController"];
    controllers = [NSArray arrayWithObject:socialVC];
    
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end