//
//  LFPhoneInfo.h
//  PhoneInfoDemo
//
//  Created by lifei on 2019/5/31.
//  Copyright © 2019 PacteraLF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFPhoneDefine.h"
#import "UIDevice+LFDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFPhoneInfo : NSObject

// 获取当前设备的具体型号字符串 e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
@property (nonatomic, copy, class) NSString *deviceTypeString;
// 设备系统版本号 e.g. @"12.0.1"
@property (nonatomic, copy, class) NSString *deviceSystemVersion;
// 设备系统名称 e.g. @"iOS"
@property (nonatomic, copy, class) NSString *deviceSystemName;
// 设备类型名称 e.g. @"iPhone", @"iPod touch", @"iPad"
@property (nonatomic, copy, class) NSString *deviceModel;
// 获取当前设备类型 e.g. LFDeviceTypeIPhone  LFDeviceTypeIPad
@property (nonatomic, assign, class) LFDeviceType deviceType;
// 当前设备用户设置的名称，设置->通用->关于本机->名称 e.g. "My iPhone"
@property (nonatomic, copy, class) NSString *deviceSettingName;
// 判断当前设备是不是iPhone，YES 是 iPhone 设备，NO不是
@property (nonatomic, assign, class) BOOL deviceIsIPhone;
// 判断当前设备是不是iPad，YES 是 iPad 设备，NO不是
@property (nonatomic, assign, class) BOOL deviceIsIPad;
// 判断当前设备是不是iPod，YES 是 iPod 设备，NO不是
@property (nonatomic, assign, class) BOOL deviceIsIPod;
// 判断当前设备是不是模拟器，YES 是 模拟器，NO不是
@property (nonatomic, assign, class) BOOL deviceIsSimulator;
// 当前设备电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
@property (nonatomic, assign, class) CGFloat deviceBatteryLevel;
// 屏幕逻辑尺寸 e.g. 逻辑像素尺寸为 2208x1242（屏幕实际物理像素尺寸是 1920x1080）
@property (nonatomic, assign, class) CGSize deviceLogicalScreenSize;
// 当前设备总内存, 返回值为兆 MB, e.g. iPhone 总内存为 2048 MB
@property (nonatomic, assign, class) CGFloat deviceTotalMemory;
// 当前 App 占用的设备内存，返回值为兆 MB, e.g. 占用 43 MB
@property (nonatomic, assign, class) CGFloat appTakeUpMemory;
// 当前磁盘总空间，返回值为兆 MB，0为异常 e.g. 总共 16 GB 即 16384 MB
@property (nonatomic, assign, class) CGFloat deviceTotalDisk;
// 当前磁盘未使用，返回值为兆 MB，0为异常 e.g. 空闲 2200 MB
@property (nonatomic, assign, class) CGFloat deviceFreeDisk;
// 当前磁盘已经使用，返回值为兆 MB，0为异常 e.g. 已使用 2200 MB
@property (nonatomic, assign, class) CGFloat deviceUsedDisk;
/**
 * 通过系统框架获取设备运营商，未安装 SIM 时返回值大概率为 nil，也可能为其他值
 * e.g. @"中国移动" @"中国联通" @"中国电信" nil
 */
@property (nonatomic, copy, class) NSString *deviceCarrierNameBySys;
/**
 * 通过状态栏视图获取设备运营商，依赖于状态栏显示
 * e.g. @"中国移动" @"中国联通" @"中国电信" @"Carrier" @"无 SIM 卡"
 */
@property (nonatomic, copy, class) NSString *deviceCarrierNameByView;
// 当前设备的 CPU 数量
@property (nonatomic, assign, class) NSInteger deviceCPUNum;
// 当前设备的 CPU 类型枚举
@property (nonatomic, assign, class) LFCPUType deviceCPUType;
// 当前设备网络状态 e.g. @"Wi-Fi" @"无服务" @"2G" @"3G" @"4G" @"LTE"
@property (nonatomic, copy, class) NSString *deviceNetType;
// 当前设备局域网 ip 地址
@property (nonatomic, copy, class) NSString *deviceLANIp;
// 当前 APP 最近的一次更新时间(或安装时间) e.g. @"2019-06-01 12:32:38 +0000"
@property (nonatomic, strong, class) NSDate *appUpdateDate;
// 当前设备是否越狱, YES 是已经越狱，NO 为未越狱
@property (nonatomic, assign, class) BOOL deviceIsJailbreak;
// 当前设备是否使用网络代理, YES 是使用，NO 为未使用
@property (nonatomic, assign, class) BOOL deviceIsUseProxy;

@end

NS_ASSUME_NONNULL_END
