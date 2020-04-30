//
//  PSServerViewController.m
//  EasyMobile
//
//  Created by Joshua Balogun on 8/12/13.
//  Copyright (c) 2013 Etisalat. All rights reserved.
//

#import "PSServerViewController.h"
#import "SVProgressHUD.h"

@implementation PSServerViewController

@synthesize request;
@synthesize alert;

-(void)sendToServer:(NSString *)dataToSend
{
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(-80.0, 110.0)];
    [SVProgressHUD showWithStatus:@"Please wait ..."];
    
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://etisalat.com.ng/easymobile/index.php?"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[NSString stringWithFormat:@"msg=%@",dataToSend] dataUsingEncoding:NSASCIIStringEncoding]];
    
    //NSLog(@"The Request -> %@",theRequest);
    
    NSURLResponse* response;
    NSError* error;
    NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *serverResponse = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    if (serverResponse)
    {
        [self displayResult:serverResponse];
    }
    
}

-(void)displayResult:(NSString *)serverResponse
{
    //NSLog(@"URL response: %@", serverResponse);
    
    [SVProgressHUD dismiss];
    
    if ( serverResponse == NULL || [serverResponse isEqualToString:@""] )
    {
        serverResponse = @"The parameters supplied seem invalid, please try again later.";
    }
    
    
    alert = [[UIAlertView alloc] initWithTitle:@"Etisalat" message:serverResponse delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //alert.transform = CGAffineTransformTranslate(alert.transform, -110.0, -40.0);
    [alert show];
    
}


@end
