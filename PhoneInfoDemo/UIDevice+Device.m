//
//  UIDevice+Device.m
//  PracticeProject
//
//  Created by PacteraLF on 2017/6/12.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import "UIDevice+Device.h"
#import <sys/utsname.h>

@implementation UIDevice (Device)

+ (NSString *)getOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getOSModel{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)getOSName {
    return [[UIDevice currentDevice] name];
}

+ (BOOL)getDeviceIsIPhone {
    return [UIDevice getDeviceType] == CurrentDeviceTypeIPhone;
}

+ (BOOL)getDeviceIsIPad {
    return [UIDevice getDeviceType] == CurrentDeviceTypeIPad;
}

+ (BOOL)getDeviceIsIPod {
    return [UIDevice getDeviceType] == CurrentDeviceTypeIPod;
}


+ (CurrentDeviceType)getDeviceType {
    NSString *type = [UIDevice getDeviceTypeString];
    
    BOOL deviceIsSupport = [UIDevice getOSVersion].doubleValue >= 8.0;
    BOOL isPhone        = deviceIsSupport ? ([type containsString:@"iPhone"])       : ([type rangeOfString:@"iPhone"].location != NSNotFound);
    BOOL isSimulator    = deviceIsSupport ? ([type containsString:@"Simulator"])    : ([type rangeOfString:@"Simulator"].location != NSNotFound);
    BOOL isPad          = deviceIsSupport ? ([type containsString:@"iPad"])         : ([type rangeOfString:@"iPad"].location != NSNotFound);
    BOOL isPod          = deviceIsSupport ? ([type containsString:@"iPod"])         : ([type rangeOfString:@"iPod"].location != NSNotFound);
    
    if (isPhone && !isSimulator) {
        return CurrentDeviceTypeIPhone;
    }else {
        if (isPhone && isSimulator) {
            return CurrentDeviceTypeIPhoneSimulator;
        }else {
            if (isPad) {
                return CurrentDeviceTypeIPad;
            }else {
                if (isPod) {
                    return CurrentDeviceTypeIPod;
                }else {
                    return CurrentDeviceTypeNone;
                }
            }
        }
    }
}

// 获取设备型号
+ (NSString *)getDeviceTypeString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
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
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])  return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])  return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])  return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])  return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";
    if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro 10.5 inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([platform isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([platform isEqualToString:@"i386"])     return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])   return @"iPhone Simulator";
    // 如果全部匹配不上，则返回原始类型
    return platform;
}

+ (BOOL)isPad {
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPad:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

@end
