//
//  iPadMenuViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 11/1/15.
//  Copyright © 2015 Etisalat Nigeria. All rights reserved.
//

#import "iPadMenuViewController.h"
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


@implementation iPadMenuViewController

@synthesize nameLbl, phoneLbl;
@synthesize tableMenuView, myArray;
@synthesize profilepic;


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // Position the view within the new parent.
    [[parent view] addSubview:[self view]];
    
    CGRect newFrame = CGRectMake(0, 0, 320, 768);
    [[self view] setFrame:newFrame];
    
    
    [tableMenuView setDelegate:self];
    [tableMenuView setDataSource:self];
    
    myArray = [NSMutableArray array];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"my account", @"title",
                        @"\uf015", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"data services", @"title",
                        @"\uf233", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"etisalat stores", @"title",
                        @"\uf1ad", @"image", nil]];
    
    [myArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"support", @"title",
                        @"\uf0ad", @"image", nil]];
    
    
    [self.tableMenuView reloadData];
    
    
    profilepic.layer.cornerRadius = 73.0;
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


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
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
    return 80;
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
    cell.textLabel.font=[UIFont fontWithName:@"NeoTechAlt-Medium" size:30.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 27, 30, 30)];
    
    NSUInteger row = [indexPath row];
    if (row == 0)
        label.font = [UIFont fontWithName:@"FontAwesome" size:30];
    else if (row == 1)
        label.font = [UIFont fontWithName:@"FontAwesome" size:35];
    else if (row == 4)
        label.font = [UIFont fontWithName:@"FontAwesome" size:27];
    else
        label.font = [UIFont fontWithName:@"FontAwesome" size:30];
    
    label.text =  [eachArray objectForKey:@"image"];
    label.textColor = [UIColor darkGrayColor];
    [cell addSubview:label];
    
    [cell setIndentationLevel:3];
    [cell setIndentationWidth:23];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    
    if (row == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMyAccountView" object:nil userInfo:nil];
    }
    else if (row == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDataServicesView" object:nil userInfo:nil];
    }
    else if (row == 2)
    {
        [self removeSelfView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStoresView" object:nil userInfo:nil];
    }
    else if (row == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSupportView" object:nil userInfo:nil];
    }
    
}


-(void)removeSelfView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.view = nil;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSocialView" object:nil userInfo:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end