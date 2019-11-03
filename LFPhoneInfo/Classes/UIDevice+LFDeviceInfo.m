//
//  UIDevice+LFDeviceInfo.m
//  PhoneInfoDemo
//
//  Created by lifei on 2019/5/31.
//  Copyright © 2019 PacteraLF. All rights reserved.
//

#import "UIDevice+LFDeviceInfo.h"
#import <sys/utsname.h>

@implementation UIDevice (LFDeviceInfo)

/**
 * 获取当前的APP的运行的手机系统版本号
 * e.g. @"9.3.5"
 @return 系统版本
 */
+ (NSString *)getDeviceSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 * 获取当前设备的手机系统名称
 * e.g. @"iOS"
 @return 手机系统名称
 */
+ (NSString *)getDeviceSystemName{
    return [[UIDevice currentDevice] systemName];
}

/**
 * 获取当前设备类型名称
 * e.g. @"iPhone", @"iPod touch", @"iPad"
 @return 设备类型的名称
 */
+ (NSString *)getDeviceModel{
    return [[UIDevice currentDevice] model];
}

/**
 * 获取当前设备用户设置的名称，设置->通用->关于本机->名称
 * e.g. "My iPhone"
 @return 用户设置的本机名称
 */
+ (NSString *)getDeviceSettingName{
    return [[UIDevice currentDevice] name];
}

/**
 * 判断当前设备是不是手机(iPhone)
 @return YES 是 iPhone 设备，NO不是
 */
+ (BOOL)getDeviceIsIPhone{
    return [UIDevice getDeviceType] == LFDeviceTypeIPhone;
}

/**
 * 判断当前设备是不是IPad
 @return YES 是 iPad 设备，NO不是
 */
+ (BOOL)getDeviceIsIPad{
    return [UIDevice getDeviceType] == LFDeviceTypeIPad;
}

/**
 * 判断当前设备是不是IPod
 @return YES 是 iPod 设备，NO不是
 */
+ (BOOL)getDeviceIsIPod{
    return [UIDevice getDeviceType] == LFDeviceTypeIPod;
}

/**
 * 判断当前设备是不是模拟器
 @return YES 是 模拟器，NO不是
 */
+ (BOOL)getDeviceIsSimulator{
    return (BOOL)TARGET_IPHONE_SIMULATOR;
}

/**
 * 获取当前设备类型
 * e.g. LFDeviceTypeIPhone
 @return 当前设备类型的枚举
 */
+ (LFDeviceType)getDeviceType{
    NSString *type = [[UIDevice currentDevice] model];
    BOOL isSimulator    = TARGET_IPHONE_SIMULATOR;
    BOOL isPhone        = [type containsString:@"iPhone"];
    BOOL isPad          = [type containsString:@"iPad"];
    BOOL isPod          = [type containsString:@"iPod"];
    // 如果是模拟器
    if (isSimulator) {
        if (isPhone) {
            return LFDeviceTypeIPhoneSimulator;
        }else if (isPad){
            return LFDeviceTypeIPadSimulator;
        }else{
            return LFDeviceTypeUnkown;
        }
    }
    // 如果是真机
    if (isPhone) {
        return LFDeviceTypeIPhone;
    }else if (isPad){
        return LFDeviceTypeIPad;
    }else if (isPod){
        return LFDeviceTypeIPod;
    }else{
        return LFDeviceTypeIPadSimulator;
    }
}

/**
 * 获取当前设备的具体型号字符串
 * e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
 @return 手机型号字符串
 */
+ (NSString *)getDeviceTypeString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPod9,1"])      return @"iPod Touch 7G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    if ([platform isEqualToString:@"iPad7,5"])      return @"iPad 6th Gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,6"])      return @"iPad 6th Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,1"])      return @"iPad Pro 3rd Gen (11 inch, WiFi)";
    if ([platform isEqualToString:@"iPad8,2"])      return @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi)";
    if ([platform isEqualToString:@"iPad8,3"])      return @"iPad Pro 3rd Gen (11 inch, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,4"])      return @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,5"])      return @"iPad Pro 3rd Gen (12.9 inch, WiFi)";
    if ([platform isEqualToString:@"iPad8,6"])      return @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)";
    if ([platform isEqualToString:@"iPad8,7"])      return @"iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,8"])      return @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad11,1"])     return @"iPad mini 5th Gen (WiFi)";
    if ([platform isEqualToString:@"iPad11,2"])     return @"iPad mini 5th Gen";
    if ([platform isEqualToString:@"iPad11,3"])     return @"iPad Air 3rd Gen (WiFi)";
    if ([platform isEqualToString:@"iPad11,4"])     return @"iPad Air 3rd Gen";
    
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4";
    
    if ([platform isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    // 如果全部匹配不上，则返回原始类型
    return platform;
}

/**
 * 获取当前电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
 @return 0.53 表示剩余电量 53%
 */
+ (CGFloat)getDeviceBatteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [[UIDevice currentDevice] batteryLevel];
}

@end
