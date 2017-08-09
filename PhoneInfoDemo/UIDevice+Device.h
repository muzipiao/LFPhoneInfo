//
//  UIDevice+Device.h
//  PracticeProject
//
//  Created by PacteraLF on 2017/6/12.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CurrentDeviceTypeNone,              // 未知类型
    CurrentDeviceTypeIPhone,            // 手机
    CurrentDeviceTypeIPad,              // pad
    CurrentDeviceTypeIPod,              // pod
    CurrentDeviceTypeIPhoneSimulator    // 模拟器
} CurrentDeviceType;

@interface UIDevice (Device)

/**
 获取当前的APP的运行的手机系统版本号
 e.g. @"9.3.5"
 */
+ (NSString *)getOSVersion;

/**
 获取当前的APP的运行的手机类型名称
 e.g. @"iPhone", @"iPod touch"
 */
+ (NSString *)getOSModel;

/**
 获取当前的APP的运行的手机系统名称(这个感觉有点鸡肋)
 e.g. @"iOS"
 */
+ (NSString *)getOSName;


/**
 判断当前设备是不是手机(iPhone)
 */
+ (BOOL)getDeviceIsIPhone;

/**
 判断当前设备是不是IPad
 */
+ (BOOL)getDeviceIsIPad;

/**
 判断当前设备是不是IPod
 */
+ (BOOL)getDeviceIsIPod;


/**
 获取当前设备类型
 */
+ (CurrentDeviceType)getDeviceType;

/**
 获取当前设备的具体型号
 */
+ (NSString *)getDeviceTypeString;


/**
 快速获得当前设备是不是ipad或者iphone
 
 PS:这个后期补充
 */
+ (BOOL)isPad;

@end
