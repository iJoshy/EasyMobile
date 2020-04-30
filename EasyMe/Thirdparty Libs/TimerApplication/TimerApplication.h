//
//  TimerApplication.h
//  TIMERUIApplication
//
//  Created by Robin on 13-8-14.
//  Copyright (c) 2013年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义应用程序超时时间，单位为分钟，因此我们会在这个数上乘以60，以便折算成秒数。

#define kApplicationTimeoutInMinutes 1

//定义通知名称，其真实内容是字符串 "timed out"

#define kApplicationDidTimeoutNotification @"AppTimeOut"


@interface TimerApplication : UIApplication
{
    NSTimer *_timer;
}

- (void)resetIdleTimer;

@end
