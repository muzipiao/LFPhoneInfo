//
//  LFPhoneInfoTests.m
//  LFPhoneInfoTests
//
//  Created by 李飞 on 06/02/2019.
//  Copyright (c) 2019 李飞. All rights reserved.
//

@import XCTest;
#import "LFPhoneInfo.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    /**
     * "platform=iOS Simulator,name=iPhone 8,OS=latest"
     * 通过 Travis CI 进行单元测试，设置 .travis.yml 文件如上
     */
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPhoneInfo
{
    // 获取当前设备的具体型号字符串 e.g. @"iPhone X" @"iPhone XS" @"iPhone XS Max
    BOOL typeIPhone8 = [LFPhoneInfo.deviceTypeString isEqualToString:@"iPhone 8"];
    BOOL typeSimulator = [LFPhoneInfo.deviceTypeString isEqualToString:@"iPhone Simulator"];
    XCTAssertTrue(typeIPhone8 || typeSimulator, @"The device type should be iPhone 8 or Simulator.");
    // 设备系统版本号 e.g. @"12.0.1"
    NSArray *systemVersion = [LFPhoneInfo.deviceSystemVersion componentsSeparatedByString:@"."];
    int systemVersionValue = [systemVersion[0] intValue];
    XCTAssertTrue(systemVersionValue >= 12, @"The device system should be iOS 12.");
    // 设备系统名称 e.g. @"iOS"
    XCTAssertTrue([LFPhoneInfo.deviceSystemName isEqualToString:@"iOS"], @"The device system name should be iOS.");
    // 设备类型名称 e.g. @"iPhone", @"iPod touch", @"iPad"
    XCTAssertTrue([LFPhoneInfo.deviceModel isEqualToString:@"iPhone"], @"The device type should be iPhone.");
    // 获取当前设备类型 e.g. LFDeviceTypeIPhone  LFDeviceTypeIPad
    XCTAssertEqual(LFPhoneInfo.deviceType, LFDeviceTypeIPhoneSimulator, @"The device type enumeration should be the iPhone simulator.");
//    // 当前设备用户设置的名称，设置->通用->关于本机->名称 e.g. "My iPhone"
    XCTAssertTrue(LFPhoneInfo.deviceSettingName.length > 0, @"The device user name should not be empty.");
    // 判断当前设备是不是iPhone，YES 是 iPhone 设备，NO不是
    XCTAssertFalse(LFPhoneInfo.deviceIsIPhone, @"The device type should be the iPhone simulator.");
    // 判断当前设备是不是iPad，YES 是 iPad 设备，NO不是
    XCTAssertFalse(LFPhoneInfo.deviceIsIPad, @"The device type should be the iPhone simulator.");
    // 判断当前设备是不是iPod，YES 是 iPod 设备，NO不是
    XCTAssertFalse(LFPhoneInfo.deviceIsIPod, @"The device type should be the iPhone simulator.");
    // 判断当前设备是不是模拟器，YES 是 模拟器，NO不是
    XCTAssertTrue(LFPhoneInfo.deviceIsSimulator, @"The current device should be an iPhone simulator.");
    // 当前设备电池电量百分比，取值范围 0 至 1.0，如果返回 -1.0 表示无法识别电池
    CGFloat batteryLevelNum = LFPhoneInfo.deviceBatteryLevel;
    BOOL batteryLevelNumIsNormal = (batteryLevelNum<=1 && batteryLevelNum>=0) || (batteryLevelNum==-1);
    XCTAssertTrue(batteryLevelNumIsNormal, @"The device battery level should be within the normal range.");
    // 屏幕逻辑尺寸 e.g. 逻辑像素尺寸为 2208x1242（屏幕实际物理像素尺寸是 1920x1080）
    CGSize device8Size = LFPhoneInfo.deviceLogicalScreenSize;
    BOOL isEqualIPhone8Screen = (device8Size.width == 750) && (device8Size.height == 1334);
    XCTAssertTrue(isEqualIPhone8Screen, @"The iPhone 8 screen size should be 750*1334px.");
    // 当前设备总内存, 返回值为兆 MB, e.g. iPhone 总内存为 2048 MB
    XCTAssertTrue(LFPhoneInfo.deviceTotalMemory > 0, @"The emulator returns memory as the carrier memory.");
    // 当前 App 占用的设备内存，返回值为兆 MB, e.g. 占用 43 MB
    XCTAssertTrue(LFPhoneInfo.appTakeUpMemory > 0, @"App occupies more than 0 memory.");
    // 当前磁盘总空间，返回值为兆 MB，0为异常 e.g. 总共 16 GB 即 16384 MB
    XCTAssertTrue(LFPhoneInfo.deviceTotalDisk > 0, @"The total disk space of the device is greater than zero.");
    // 当前磁盘未使用，返回值为兆 MB，0为异常 e.g. 空闲 2200 MB
    XCTAssertTrue(LFPhoneInfo.deviceFreeDisk > 0, @"The device free disk space is greater than zero.");
    // 当前磁盘已经使用，返回值为兆 MB，0为异常 e.g. 已使用 2200 MB
    XCTAssertTrue(LFPhoneInfo.deviceUsedDisk > 0, @"The device has used a disk larger than zero.");
    // @[@"中国移动" @"中国联通"] 或 @[]
    XCTAssertTrue(LFPhoneInfo.deviceCarrierList.count==0, @"carrier name is nil.");
    // 当前设备的 CPU 数量
    XCTAssertTrue(LFPhoneInfo.deviceCPUNum > 0, @"The number of CPUs of the device is not 0.");
    // 当前设备的 CPU 类型枚举LFCPUTypeX86_64
    BOOL cpuTypeIsEqual = (LFPhoneInfo.deviceCPUType == LFCPUTypeX86_64) || (LFPhoneInfo.deviceCPUType == LFCPUTypeX86) || (LFPhoneInfo.deviceCPUType == LFCPUTypeUnkown);
    XCTAssertTrue(cpuTypeIsEqual, @"The emulator CPU type should be of the X86 type.");
    // SIM 卡个数
    XCTAssertTrue(LFPhoneInfo.deviceSIMCount==0, @"The number of CPUs of the device is not 0.");
    // 当前设备网络状态 e.g. @"WiFi" @"无服务" @"2G" @"3G" @"4G" @"LTE"
    XCTAssertTrue([LFPhoneInfo.deviceNetType isEqualToString:@"Wi-Fi"], @"The simulator net should be Wi-Fi.");
    // 当前设备局域网 ip 地址
    XCTAssertTrue(LFPhoneInfo.deviceLANIp.length > 0, @"Device LAN IP address.");
    // 当前 APP 最近的一次更新时间(或安装时间) e.g. @"2019-06-01 12:32:38 +0000"
    XCTAssertTrue(LFPhoneInfo.appUpdateDate, @"App update time.");
    // 当前设备是否越狱, YES 是已经越狱，NO 为未越狱
    XCTAssertTrue(LFPhoneInfo.deviceIsJailbreak, @"The simulator detects jailbreak.");
    // 当前设备是否使用网络代理, YES 是使用，NO 为未使用
    BOOL isProxy = LFPhoneInfo.deviceIsUseProxy;
    XCTAssert(isProxy==YES || isProxy==NO, @"The device may use a proxy network.");
}

@end

