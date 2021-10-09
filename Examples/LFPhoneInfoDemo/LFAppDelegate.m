//
//  LFAppDelegate.m
//  LFPhoneInfo
//
//  Created by 李飞 on 06/02/2019.
//  Copyright (c) 2019 李飞. All rights reserved.
//

#import "LFAppDelegate.h"
#import "LFViewController.h"

@implementation LFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LFViewController *vc = [[LFViewController alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
