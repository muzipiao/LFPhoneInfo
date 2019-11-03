//
//  LFPhoneDefine.h
//  PhoneInfoDemo
//
//  Created by 李飞 on 2019/6/1.
//  Copyright © 2019 PacteraLF. All rights reserved.
//

#ifndef LFPhoneDefine_h
#define LFPhoneDefine_h

#define IOS_CELLULAR    @"pdp_ip0" // 蜂窝移动网络
#define IOS_WIFI        @"en0"     // WiFi
#define IOS_VPN         @"utun0"   // VPN
#define IP_ADDR_IPv4    @"ipv4"    // ipv4
#define IP_ADDR_IPv6    @"ipv6"    // ipv6

// 设备类型
typedef NS_ENUM(NSInteger, LFDeviceType) {
    LFDeviceTypeUnkown,         //未知类型
    LFDeviceTypeIPhone,         //iPhone
    LFDeviceTypeIPad,           //iPad
    LFDeviceTypeIPod,           //iPod
    LFDeviceTypeIPhoneSimulator,//手机模拟器
    LFDeviceTypeIPadSimulator   //iPad模拟器
};

// 设备 CPU 类型
typedef NS_ENUM(NSInteger, LFCPUType) {
    LFCPUTypeUnkown,    //未知类型
    LFCPUTypeARM,       //32位手机 CPU
    LFCPUTypeARM64,     //64位手机 CPU
    LFCPUTypeX86,       //32位电脑 CPU
    LFCPUTypeX86_64     //64位电脑 CPU
};



#endif /* LFPhoneDefine_h */
