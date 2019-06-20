## iOS获取设备信息

[![CI Status](https://img.shields.io/travis/muzipiao/LFPhoneInfo.svg?style=flat)](https://travis-ci.org/muzipiao/LFPhoneInfo)
[![codecov](https://codecov.io/gh/muzipiao/LFPhoneInfo/branch/master/graph/badge.svg)](https://codecov.io/gh/muzipiao/LFPhoneInfo)
[![Version](https://img.shields.io/cocoapods/v/LFPhoneInfo.svg?style=flat)](https://cocoapods.org/pods/LFPhoneInfo)
[![License](https://img.shields.io/cocoapods/l/LFPhoneInfo.svg?style=flat)](https://cocoapods.org/pods/LFPhoneInfo)
[![Platform](https://img.shields.io/cocoapods/p/LFPhoneInfo.svg?style=flat)](https://cocoapods.org/pods/LFPhoneInfo)

|信息类型|类型说明|能否获取|示例|备注|
|:---:|:---:|:---:|:---:|:---:|
|设备型号|具体那一款手机|支持|iPhone，iPad，iPod|通过 systemInfo.machine 获取|
|系统版本|设备系统的版本|支持|iPhone9,1，iPhone9,2|通过 systemInfo.machine 获取|
|屏幕分辨率|手机屏幕分辨率|支持|568×320，667×375|包括物理分辨率和逻辑分辨率|
|IMEI|手机设备唯一标识|~~不支持~~|493002407599521|iOS 5 之后被禁止获取|
|IMSI|sim 卡用户身份识别码|~~不支持~~|460030912121001|只能获取部分代号|
|SIM 卡序列号|sim 卡的唯一标识|~~不支持~~|手机卡背面 4 行共 20 个数字|无法获取|
|手机号码|一般为11位数字|~~不支持~~|18888888888|iOS 5 之后被禁止获取，获取值都为 nil|
|运营商信息|提供网络服务的供应商|支持|中国移动，中国联通，中国电信|有多种方法获取|
|设备内存|手机内存 RAM|支持|2000.0MB|可通过系统 API 获取|
|App 占用内存|App 占用的内存 RAM|支持|43.5MB|可通过系统 API 获取|
|磁盘总空间|设备存储的总大小|支持|16384.0MB|可通过系统 API 获取|
|磁盘空闲空间|设备存储未使用空间大小|支持|2200.0MB|可通过系统 API 获取|
|磁盘已使用空间|设备存储未使用空间大小|支持|2200.0MB|可通过系统 API 获取|
|CPU 型号|CPU 类型|支持|CPU_TYPE_X86_64|CPU 类型|
|CPU 个数|CPU 是几核的|支持|4，核心数为 4|CPU 核心数|
|手机主板型号|手机主板硬件的编号|~~不支持~~|无法获取|无法获取|
|是否破解|手机是否越狱|不准确|通过判断是否存在某些文件|新越狱工具可能检测不到|
|mac 地址|网卡的物理地址|~~不支持~~|02:00:00:00:00:00|iOS 7 之后被禁止获取|
|当前网络环境|当前手机使用 WiFi/4G|支持|2G/3G/4G/WIFI|系统方法获取或读取状态栏获取|
|局域网 IP|手机连入网络的局域网地址|不准确|192.168.1.3|使用 VPN 等复杂网络可能会不准确|
|IP|手机连入网络的地址|~~不支持~~|111.200.9.21|不支持本地获取，可通过后台返回|
|GPS|卫星定位|不准确|获取经纬度反地理编码|地下室等 GPS 信号弱有较大误差|
|设备序列号|设备唯一标识|不准确|iOS 的 UUID|删除重装会变，重置位置和隐私会变|
|APP 更新时间|软件更新时间或首次安装时间|支持|2019-06-01 12:32:38|可读取info.plist创建时间|
|检测代理|设备使用代理 IP|支持|YES/NO|可准确检测设备是否设置了代理|
|电池电量|当前设备电池电量百分比|支持|0.53 表示剩余电量 53%|取值范围 0 至 1.0，-1.0 表示无法识别电池|

`LFPhoneInfo ` 可快速获取设备信息。

```objective-c
#import "LFPhoneInfo.h"

// 获取当前设备型号，显示为 iPhone 5S
NSString *typeStr = LFPhoneInfo.deviceTypeString;

// 获取当前设备电池电量，假设电量为 53%，则返回 0.53
CGFloat batteryLevel = LFPhoneInfo.deviceBatteryLevel;
```

## 图示

![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/phone_info/phone_info1.PNG)
![](https://raw.githubusercontent.com/muzipiao/GitHubImages/master/phone_info/phone_info2.PNG)

## 环境需求

`LFPhoneInfo ` 工作环境为 iOS 8+  和 ARC 编译环境，Demo 编译环境为 Xcode 10.2.1。

## 安装

### CocoaPods

CocoaPods 是最简单方便的安装方法，编辑 Podfile 文件，添加

```ruby
pod 'LFPhoneInfo'
```
然后执行 `pod install` 即可。

### 直接安装

1. 从 Git 下载最新代码，找到和 README 同级的 LFPhoneInfo 文件夹，将 LFPhoneInfo 文件夹拖入项目即可。
2. 在需要使用的地方导入 `#import "LFPhoneInfo.h"` 即可。

## 用法

`LFPhoneInfo `返回值采用类属性的方式，你可以通过点语法`LFPhoneInfo.属性名称 `直接获取。

假设你需要获取网络运营商、网络状态、设备局域网 IP、是否越狱

```objective-c
#import "LFPhoneInfo.h"

// 通过系统框架获取设备运营商 e.g. @"中国移动" @"中国联通" @"中国电信"
NSString *carrierName = LFPhoneInfo.deviceCarrierName;

// 当前设备网络状态 e.g. @"WiFi" @"无服务" @"2G" @"3G" @"4G" @"LTE"
NSString *netType = LFPhoneInfo.deviceNetType;

// 当前设备局域网 ip 地址
NSString *LANIP = LFPhoneInfo.deviceLANIp;

// 当前设备是否越狱,模拟器会认为已经越狱，YES 是已经越狱
BOOL isJailbreak = LFPhoneInfo.deviceIsJailbreak;

```

## 其他

如果您觉得有所帮助，请在 [GitHub LFPhoneInfoDemo](https://github.com/muzipiao/LFPhoneInfo) 上赏个 Star ⭐️，您的鼓励是我前进的动力
