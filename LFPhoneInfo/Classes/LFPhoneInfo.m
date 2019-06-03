//
//  LFPhoneInfo.m
//  PhoneInfoDemo
//
//  Created by lifei on 2019/5/31.
//  Copyright © 2019 PacteraLF. All rights reserved.
//

#import "LFPhoneInfo.h"
#include <mach/mach.h> // 获取内存
#import <CoreTelephony/CTTelephonyNetworkInfo.h> // 获取设备运营商
#import <CoreTelephony/CTCarrier.h> // 获取设备运营商
#import <sys/sysctl.h> // CPU 类型获取
#import <ifaddrs.h> // 获取ip
#import <arpa/inet.h> // 获取ip
#import <net/if.h> // 获取ip

@implementation LFPhoneInfo

// 获取当前设备的具体型号字符串 e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
+ (void)setDeviceTypeString:(NSString *)deviceTypeString{}
+ (NSString *)deviceTypeString{
    return [UIDevice getDeviceTypeString];
}

// 设备系统版本号 e.g. @"12.0.1"
+ (void)setDeviceSystemVersion:(NSString *)deviceSystemVersion{}
+ (NSString *)deviceSystemVersion{
    return [UIDevice getDeviceSystemVersion];
}

// 手机系统名称 e.g. @"iOS"
+ (void)setDeviceSystemName:(NSString *)deviceOSName{}
+ (NSString *)deviceSystemName{
    return [UIDevice getDeviceSystemName];
}

// 设备类型名称 e.g. @"iPhone", @"iPod touch", @"iPad"
+ (void)setDeviceModel:(NSString *)deviceModel{}
+ (NSString *)deviceModel{
    return [UIDevice getDeviceModel];
}

// 获取当前设备类型 e.g. LFDeviceTypeIPhone  LFDeviceTypeIPad
+ (void)setDeviceType:(LFDeviceType)deviceType{}
+ (LFDeviceType)deviceType{
    return [UIDevice getDeviceType];
}

// 当前设备用户设置的名称，设置->通用->关于本机->名称 e.g. "My iPhone"
+ (void)setDeviceSettingName:(NSString *)deviceSettingName{}
+ (NSString *)deviceSettingName{
    return [UIDevice getDeviceSettingName];
}

// 判断当前设备是不是iPhone，YES 是 iPhone 设备，NO不是
+ (void)setDeviceIsIPhone:(BOOL)deviceIsIPhone{}
+ (BOOL)deviceIsIPhone{
    return [UIDevice getDeviceIsIPhone];
}

// 判断当前设备是不是iPad，YES 是 iPad 设备，NO不是
+ (void)setDeviceIsIPad:(BOOL)deviceIsIPad{}
+ (BOOL)deviceIsIPad{
    return [UIDevice getDeviceIsIPad];
}

// 判断当前设备是不是iPod，YES 是 iPod 设备，NO不是
+ (void)setDeviceIsIPod:(BOOL)deviceIsIPod{}
+ (BOOL)deviceIsIPod{
    return [UIDevice getDeviceIsIPod];
}

// 判断当前设备是不是模拟器，YES 是 模拟器，NO不是
+ (void)setDeviceIsSimulator:(BOOL)deviceIsSimulator{}
+ (BOOL)deviceIsSimulator{
    return [UIDevice getDeviceIsSimulator];
}

// 当前设备电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
+ (void)setDeviceBatteryLevel:(CGFloat)deviceBatteryLevel{}
+ (CGFloat)deviceBatteryLevel{
    return [UIDevice getDeviceBatteryLevel];
}
//@property (nonatomic, assign, class) CGFloat deviceBatteryLevel;

// 屏幕逻辑尺寸 e.g. 逻辑像素尺寸为 2208x1242（屏幕实际物理像素尺寸是 1920x1080, ）
+ (void)setDeviceLogicalScreenSize:(CGSize)deviceLogicalScreenSize{}
+ (CGSize)deviceLogicalScreenSize{
    // 屏幕宽高
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    // 屏幕缩放率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    // 屏幕像素分辨率
    CGFloat width = size_screen.width * scale_screen;
    CGFloat height = size_screen.height * scale_screen;
    return CGSizeMake(width, height);
}

// 当前设备总内存, 返回值为兆 MB, e.g. iPhone 总内存为 2048 MB
+ (void)setDeviceTotalMemory:(CGFloat)deviceTotalMemory{}
+ (CGFloat)deviceTotalMemory{
    return [NSProcessInfo processInfo].physicalMemory/(1024.0*1024.0);
}

// 当前 App 占用的设备内存，返回值为兆 MB, e.g. 占用 43 MB
+ (void)setAppTakeUpMemory:(CGFloat)appTakeUpMemory{}
+ (CGFloat)appTakeUpMemory{
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte/(1024.0*1024.0);
}

// 当前磁盘总空间，返回值为兆 MB，0为异常 e.g. 总共 16 GB 即 16384 MB
+ (void)setDeviceTotalDisk:(CGFloat)deviceTotalDisk{}
+ (CGFloat)deviceTotalDisk{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return 0;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = 0;
    return space/(1024.0*1024.0);
}

// 当前磁盘未使用，返回值为兆 MB，0为异常 e.g. 空闲 2200 MB
+ (void)setDeviceFreeDisk:(CGFloat)deviceFreeDisk{}
+ (CGFloat)deviceFreeDisk{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return 0;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = 0;
    return space/(1024.0*1024.0);
}

// 当前磁盘已经使用，返回值为兆 MB，0为异常 e.g. 已使用 2200 MB
+ (void)setDeviceUsedDisk:(CGFloat)deviceUsedDisk{}
+ (CGFloat)deviceUsedDisk{
    CGFloat totalDisk = [self deviceTotalDisk];
    CGFloat freeDisk = [self deviceFreeDisk];
    if (totalDisk < 0 || freeDisk < 0) return 0;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = 0;
    return usedDisk;
}

/**
 * 通过系统框架获取设备运营商，返回值可能不准确
 * e.g. @"中国移动" @"中国联通" @"中国电信" nil
 */
+ (void)setDeviceCarrierNameBySys:(NSString *)deviceCarrierNameBySys{}
+ (NSString *)deviceCarrierNameBySys{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName=[carrier carrierName];
    return carrierName;
}

/**
 * 通过状态栏视图获取设备运营商，依赖于状态栏显示
 * e.g. @"中国移动" @"中国联通" @"中国电信" @"Carrier" @"无 SIM 卡"
 */
+ (void)setDeviceCarrierNameByView:(NSString *)deviceCarrierNameByView{}
+ (NSString *)deviceCarrierNameByView{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")])
        {
            NSString *serviceString = [info valueForKeyPath:@"serviceString"];
            return serviceString; // 遍历状态栏视图找到运营商
        }
    }
    return @"";
}

// 当前设备的 CPU 数量
+ (void)setDeviceCPUNum:(NSInteger)deviceCPUNum{}
+ (NSInteger)deviceCPUNum{
    unsigned int ncpu;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    NSInteger cpuNum = ncpu;
    return cpuNum;
}

// 当前设备的 CPU 类型
+ (void)setDeviceCPUType:(LFCPUType)deviceCPUType{}
+ (LFCPUType)deviceCPUType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return LFCPUTypeARM;
            break;
            
        case CPU_TYPE_ARM64:
            return LFCPUTypeARM64;
            break;
            
        case CPU_TYPE_X86:
            return LFCPUTypeX86;
            break;
            
        case CPU_TYPE_X86_64:
            return LFCPUTypeX86_64;
            break;
            
        default:
            return LFCPUTypeUnkown;
            break;
    }
}

// 当前设备网络状态 e.g. @"Wi-Fi" @"无服务" @"2G" @"3G" @"4G" @"LTE"
+ (void)setDeviceNetType:(NSString *)deviceNetType{}
+ (NSString *)deviceNetType{
    NSString *networktype = @"";
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            networktype = @"无服务";
            break;
        case 1:
            networktype = @"2G";
            break;
        case 2:
            networktype = @"3G";
            break;
        case 3:
            networktype = @"4G";
            break;
        case 4:
            networktype = @"LTE";
            break;
        case 5:
            networktype = @"Wi-Fi";
            break;
        default:
            break;
    }
    return networktype;
}

// 当前设备局域网 ip 地址，只读取IPV4地址
+ (void)setDeviceLANIp:(NSString *)deviceLANIp{}
+ (NSString *)deviceLANIp{
    NSDictionary *addressDict = [self getIPAddressDict];
    if ([[self deviceNetType] isEqualToString:@"Wi-Fi"]) {
        NSString *wfKey = [NSString stringWithFormat:@"%@/%@",IOS_WIFI,IP_ADDR_IPv4];
        NSString *wfIp = [addressDict objectForKey:wfKey];
        return wfIp?wfIp:@"";
    }else{
        NSString *cellKey = [NSString stringWithFormat:@"%@/%@",IOS_CELLULAR,IP_ADDR_IPv4];
        NSString *cellIp = [addressDict objectForKey:cellKey];
        return cellIp?cellIp:@"";
    }
}

/**
 * 字典格式如下：
 * "awdl0/ipv6" = "fe80::1c4a:6fff:fe04:fea0";
 * "en0/ipv4" = "192.168.1.4";
 * "en0/ipv6" = "240e:82:700:2b7e:713a:6f38:ffc2:fdd0";
 * "lo0/ipv4" = "127.0.0.1";
 * "lo0/ipv6" = "fe80::1";
 * "utun0/ipv6" = "fe80::74d9:38ee:dbf3:16f7";
 @return 当前网络状态字典
 */
+ (NSDictionary *)getIPAddressDict{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// 当前 APP 最近的一次更新时间(或安装时间) e.g. @"2019-06-01 12:32:38 +0000"
+ (void)setAppUpdateDate:(NSDate *)appUpdateDate{}
+ (NSDate *)appUpdateDate{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:bundlePath error:nil];
    NSDate *date = [fileAttributes objectForKey:NSFileCreationDate];
    return date;
}

// 当前设备是否越狱, YES 是已经越狱，NO 为未越狱
+ (void)setDeviceIsJailbreak:(BOOL)deviceIsJailbreak{}
+ (BOOL)deviceIsJailbreak{
    static BOOL isjbroken = NO;
    if (isjbroken) {
        return isjbroken;
    }
    @try {
        NSArray *paths = [NSArray arrayWithObjects:
                          @"/User/Applications/",
                          @"/Applications/Cydia.app",
                          @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                          @"/bin/bash",
                          @"/usr/sbin/sshd",
                          @"/etc/apt",
                          nil];
        
        for (NSString *one in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:one]) {
                isjbroken = YES;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Jailbroken exception:%@",exception);
    }
    
    return isjbroken;
}

// 当前设备是否使用网络代理, YES 是使用，NO 为未使用
+ (void)setDeviceIsUseProxy:(BOOL)deviceIsUseProxy{}
+ (BOOL)deviceIsUseProxy{
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *dictProxy = (__bridge  id)proxySettings;
    return [[dictProxy objectForKey:@"HTTPEnable"] boolValue];
}

@end
