//
//  UIDevice+LFDeviceInfo.h
//  PhoneInfoDemo
//
//  Created by lifei on 2019/5/31.
//  Copyright © 2019 PacteraLF. All rights reserved.
//
/**
 * UIDevice分类，检测设备类型，获取设备设备版本等信息
 */

#import <UIKit/UIKit.h>
#import <LFPhoneDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (LFDeviceInfo)

/**
 * 获取当前设备的具体型号字符串
 * e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
 @return 手机型号字符串
 */
+ (NSString *)getDeviceTypeString;

/**
 * 获取当前的APP的运行的手机系统版本号
 * e.g. @"9.3.5"
 @return 系统版本
 */
+ (NSString *)getDeviceSystemVersion;

/**
 * 获取当前设备的手机系统名称
 * e.g. @"iOS"
 @return 手机系统名称
 */
+ (NSString *)getDeviceSystemName;

/**
 * 获取当前设备类型名称
 * e.g. @"iPhone", @"iPod touch", @"iPad"
 @return 设备类型的名称
 */
+ (NSString *)getDeviceModel;

/**
 * 获取当前设备类型
 * e.g. LFDeviceTypeIPhone
 @return 当前设备类型的枚举
 */
+ (LFDeviceType)getDeviceType;

/**
 * 获取当前设备用户设置的名称，设置->通用->关于本机->名称
 * e.g. "My iPhone"
 @return 用户设置的本机名称
 */
+ (NSString *)getDeviceSettingName;

/**
 * 判断当前设备是不是手机(iPhone)
 @return YES 是 iPhone 设备，NO不是
 */
+ (BOOL)getDeviceIsIPhone;

/**
 * 判断当前设备是不是IPad
 @return YES 是 iPad 设备，NO不是
 */
+ (BOOL)getDeviceIsIPad;

/**
 * 判断当前设备是不是IPod
 @return YES 是 iPod 设备，NO不是
 */
+ (BOOL)getDeviceIsIPod;

/**
 * 判断当前设备是不是模拟器
 @return YES 是 模拟器，NO不是
 */
+ (BOOL)getDeviceIsSimulator;

/**
 * 获取当前电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
 @return 0.53 表示剩余电量 53%
 */
+ (CGFloat)getDeviceBatteryLevel;

@end

NS_ASSUME_NONNULL_END
