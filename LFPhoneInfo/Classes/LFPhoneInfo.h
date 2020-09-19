//
//  LFPhoneInfo.h
//  PhoneInfoDemo
//
//  Created by lifei on 2019/5/31.
//  Copyright © 2019 PacteraLF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFPhoneDefine.h"
#import "LFReachability.h"
#import "UIDevice+LFDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFPhoneInfo : NSObject

// 获取当前设备的具体型号字符串 e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
@property(class, readonly) NSString *deviceTypeString;
// 设备系统版本号 e.g. @"12.0.1"
@property(class, readonly) NSString *deviceSystemVersion;
// 设备系统名称 e.g. @"iOS"
@property(class, readonly) NSString *deviceSystemName;
// 设备类型名称 e.g. @"iPhone", @"iPod touch", @"iPad"
@property(class, readonly) NSString *deviceModel;
// 获取当前设备类型 e.g. LFDeviceTypeIPhone  LFDeviceTypeIPad
@property(class, readonly) LFDeviceType deviceType;
// 当前设备用户设置的名称，设置->通用->关于本机->名称 e.g. "My iPhone"
@property(class, readonly) NSString *deviceSettingName;
// 判断当前设备是不是iPhone，YES 是 iPhone 设备，NO不是
@property(class, readonly) BOOL deviceIsIPhone;
// 判断当前设备是不是iPad，YES 是 iPad 设备，NO不是
@property(class, readonly) BOOL deviceIsIPad;
// 判断当前设备是不是iPod，YES 是 iPod 设备，NO不是
@property(class, readonly) BOOL deviceIsIPod;
// 判断当前设备是不是模拟器，YES 是 模拟器，NO不是
@property(class, readonly) BOOL deviceIsSimulator;
// 当前设备电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
@property(class, readonly) CGFloat deviceBatteryLevel;
// 屏幕逻辑尺寸 e.g. 逻辑像素尺寸为 2208x1242（屏幕实际物理像素尺寸是 1920x1080）
@property(class, readonly) CGSize deviceLogicalScreenSize;
// 当前设备总内存, 返回值为兆 MB, e.g. iPhone 总内存为 2048 MB
@property(class, readonly) CGFloat deviceTotalMemory;
// 当前 App 占用的设备内存，返回值为兆 MB, e.g. 占用 43 MB
@property(class, readonly) CGFloat appTakeUpMemory;
// 当前磁盘总空间，返回值为兆 MB，0为异常 e.g. 总共 16 GB 即 16384 MB
@property(class, readonly) CGFloat deviceTotalDisk;
// 当前磁盘未使用，返回值为兆 MB，0为异常 e.g. 空闲 2200 MB
@property(class, readonly) CGFloat deviceFreeDisk;
// 当前磁盘已经使用，返回值为兆 MB，0为异常 e.g. 已使用 2200 MB
@property(class, readonly) CGFloat deviceUsedDisk;
/// 通过系统框架获取设备运营商，未安装 SIM 时返回空数组
/// e.g. @[@"中国移动" @"中国联通"]，或 @[@"中国电信"]  或 @[]
@property(class, readonly) NSArray<NSString *> *deviceCarrierList;
// 当前设备的 CPU 数量
@property(class, readonly) NSInteger deviceCPUNum;
// 当前设备的 CPU 类型枚举
@property(class, readonly) LFCPUType deviceCPUType;
// 当前设备的 SIM 卡数量，eg. 0 1 2
@property(class, readonly) NSInteger deviceSIMCount;
// 当前设备网络状态 e.g. @"WiFi" @"无服务" @"2G" @"3G" @"4G" @"LTE" @"WWAN"
@property(class, readonly) NSString *deviceNetType;
// 当前设备局域网 ip 地址
@property(class, readonly) NSString *deviceLANIp;
// 当前 APP 最近的一次更新时间(或安装时间) e.g. @"2019-06-01 12:32:38 +0000"
@property(class, readonly) NSDate *appUpdateDate;
// 当前设备是否越狱, YES 是已经越狱，NO 为未越狱
@property(class, readonly) BOOL deviceIsJailbreak;
// 当前设备是否使用网络代理, YES 是使用，NO 为未使用
@property(class, readonly) BOOL deviceIsUseProxy;

@end

NS_ASSUME_NONNULL_END
