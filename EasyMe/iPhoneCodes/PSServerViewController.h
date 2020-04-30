//
//  PSServerViewController.h
//  EasyMobile
//
//  Created by Joshua Balogun on 8/12/13.
//  Copyright (c) 2013 Etisalat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSServerViewController : UIViewController < UIAlertViewDelegate >
{
}

@property (nonatomic, strong) NSString *request;
@property (nonatomic, strong)  UIAlertView *alert;

-(void)sendToServer:(NSString *)dataToSend;

@end
