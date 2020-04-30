//
//  TimerApplication.m
//  TIMERUIApplication
//
//  Created by Robin on 13-8-14.
//  Copyright (c) 2013年 Robin. All rights reserved.
//

#import "TimerApplication.h"

@implementation TimerApplication

-(void)sendEvent:(UIEvent *)event
{
    
    [super sendEvent:event];
    
    if (!_timer) {
        
        [self resetIdleTimer];
        
    }
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] > 0)
    {
        
        UITouchPhase phase= ((UITouch *)
                             
        [allTouches anyObject]).phase;
        
        if (phase ==UITouchPhaseBegan)
        {
            
            [self resetIdleTimer];
            
        }
        
    }
    
}
//重置时钟

-(void)resetIdleTimer
{
    
    if (_timer ) {
        
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
    
    //将超时时间由分钟转换成秒数
    
    int timeout =
    
    kApplicationTimeoutInMinutes* 60 *15;
    
    _timer = [[NSTimer
                   
                   scheduledTimerWithTimeInterval:timeout
                   
                   target:self
                   
                   selector:@selector(idleTimerExceeded)
                   
                   userInfo:nil
               repeats:NO] retain];;
    
}

//当达到超时时间，张贴 kApplicationTimeoutInMinutes通知

-(void)idleTimerExceeded
{
    
    [[NSNotificationCenter defaultCenter]
     
     postNotificationName:
     
     kApplicationDidTimeoutNotification
     
     object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"APP has been idle for a while,\n Please login again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    [_timer release];
    [super dealloc];
}

@end
