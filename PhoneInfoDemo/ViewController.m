//
//  ViewController.m
//  PhoneInfoDemo
//
//  Created by PacteraLF on 2017/8/1.
//  Copyright © 2017年 PacteraLF. All rights reserved.
//

#import "ViewController.h"
#import <sys/utsname.h>
#include <mach/mach.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AddressBook/AddressBook.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#import "SAMKeychain.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ViewController ()
{
    CGFloat contentH; //ScrollView可滚动范围
}

@property (nonatomic, strong) UIScrollView *scrollView;

//存放各种标签的数组
@property (nonatomic, strong) NSMutableArray <UILabel *>*labelArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //获取手机型号，例如iPhone 5s
    self.labelArray[0].text = [NSString stringWithFormat:@"设备具体型号为：%@",[self getDeviceType]];
    //获取当前操作系统，例如 iOS 10.1.1
    self.labelArray[1].text = [NSString stringWithFormat:@"设备系统版本为：%@",[self getSystemVersion]];
    //屏幕分辨率；例如1920*1080
    self.labelArray[2].text = [NSString stringWithFormat:@"设备屏幕尺寸为：%@",[self getScreenSize]];
    //获取运营商；例如中国移动。。。无则显示为运营商
    self.labelArray[3].text = [NSString stringWithFormat:@"获取运营商方法1为：%@",[self serviceCompany]];
    //如果无则返回null
    self.labelArray[4].text = [NSString stringWithFormat:@"获取运营商方法2为：%@",[self getCarrierInfo]];
    //获取IMSI部分信息
    self.labelArray[5].text = [NSString stringWithFormat:@"IMSI部分信息：%@",[self getImsiPart]];
    //本机手机号码
    self.labelArray[6].text = [NSString stringWithFormat:@"本机手机号码为：%@",[self getPlistPhoneNum]];
    //运行内存
    self.labelArray[7].text = [NSString stringWithFormat:@"计算出的内存为：%fMB",[self getMemoryMB]];
    //CPU类型
    self.labelArray[8].text = [NSString stringWithFormat:@"CPU类型为：%@",[self getCPUKind]];
    //是否被破解jailbroken
    NSString *jailStr = [self isJailbreak]?@"是":@"否";
    self.labelArray[9].text = [NSString stringWithFormat:@"是否被破解：%@",jailStr];
    //网络状态
    self.labelArray[10].text = [NSString stringWithFormat:@"运营商为：%@",[self getNetWorkInfo]];
    //当前IP
    self.labelArray[11].text = [NSString stringWithFormat:@"当前IP为：%@",[self getIPAddress:NO]];
    //应用序列号
    self.labelArray[12].text = [NSString stringWithFormat:@"设备序列号为：%@",[self getUUID]];
    //应用创建实际和更新时间
    self.labelArray[13].text = [NSString stringWithFormat:@"App创建和更新时间：%@",[self getAppCreateTime]];
    
    //测试钥匙串里面的东西，在什么情况下清空
    [self testKeyChain];
    
}

#pragma mark - 测试钥匙串删除特性
-(void)testKeyChain{
    
    NSString *touchIDRSAPassword = [SAMKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:@"lf"];
    
    if (touchIDRSAPassword == nil || touchIDRSAPassword.length == 0) {
        self.labelArray[14].text = [NSString stringWithFormat:@"Keychain读取的密码为：%@",touchIDRSAPassword];
        //将加密后的值保存到钥匙串
        /*
         参数1 : 你要保存的密码
         参数2 : 为哪个APP保存密码
         参数3 : 为哪个账号保存密码
         参数4 : 如果保存错误，错误信息
         */
        NSError *error;
        [SAMKeychain setPassword:@"1234567890" forService:[NSBundle mainBundle].bundleIdentifier account:@"lf" error:&error];
    }else{
        //应用创建实际和更新时间
        self.labelArray[14].text = [NSString stringWithFormat:@"Keychain读取的密码为：%@",touchIDRSAPassword];
    }

}

#pragma mark - 获取应用安装时间
-(NSString *)getAppCreateTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.存储数据
//    [defaults setObject:APPLICATION.currentV forKey:name];
    NSString *createTime = [defaults stringForKey:@"createTime"];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *updateTime = [self getFileCreatDateWithPath:bundlePath];
    
    if (createTime == nil || createTime.length == 0) {
        [defaults setObject:updateTime forKey:@"createTime"];
        createTime = updateTime;
    }
    
    
    
    NSString *timeStr = [NSString stringWithFormat:@"创建时间:%@; 更新时间:%@",createTime,updateTime];
    return timeStr;
}

- (NSString *)getFileCreatDateWithPath:(NSString *)path
{
    NSString *date = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    date = [fileAttributes objectForKey:NSFileCreationDate];
    return date;
}

#pragma mark - 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
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

#pragma mark - 应用序列号，UUID可以替代
//获取UUID，删除重新安装会变，但如果有同一厂商的app，则不变
-(NSString *)getUUID{
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuidStr;
}

#pragma mark - 是否被破解
- (BOOL)isJailbreak {
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


// 是否越狱
- (BOOL)jailbroken
{
#if !TARGET_IPHONE_SIMULATOR
    
    //Apps and System check list
    BOOL isDirectory;
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Cyd", @"ia.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"bla", @"ckra1n.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Fake", @"Carrier.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Ic", @"y.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Inte", @"lliScreen.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"MxT", @"ube.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Roc", @"kApp.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"SBSet", @"ttings.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Wint", @"erBoard.a", @"pp"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/a", @"pt/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/c", @"ydia/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/mobile", @"Library/SBSettings", @"Themes/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/t", @"mp/cyd", @"ia.log"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/s", @"tash/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"us", @"r/b",@"in", @"s", @"shd"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"us", @"r/sb",@"in", @"s", @"shd"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/sftp-", @"server"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@",@"/Syste",@"tem/Lib",@"rary/Lau",@"nchDae",@"mons/com.ike",@"y.bbot.plist"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@%@",@"/Sy",@"stem/Lib",@"rary/Laun",@"chDae",@"mons/com.saur",@"ik.Cy",@"@dia.Star",@"tup.plist"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/Libr",@"ary/Mo",@"bileSubstra",@"te/MobileSubs",@"trate.dylib"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/va",@"r/c",@"ach",@"e/a",@"pt/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"ib",@"/apt/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"ib/c",@"ydia/"] isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@", @"/va",@"r/l",@"og/s",@"yslog"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/bi",@"n/b",@"ash"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/b",@"in/",@"sh"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/et",@"c/a",@"pt/"]isDirectory:&isDirectory]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@", @"/etc/s",@"sh/s",@"shd_config"]]
        || [defaultManager fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@", @"/us",@"r/li",@"bexe",@"c/ssh-k",@"eysign"]])
        
    {
        return YES;
    }
    
    // SandBox Integrity Check
    int pid = fork(); //返回值：子进程返回0，父进程中返回子进程ID，出错则返回-1
    if(!pid){
        exit(0);
    }
    if(pid>=0)
    {
        return YES;
    }
    
    //Symbolic link verification
    struct stat s;
    if(lstat("/Applications", &s) || lstat("/var/stash/Library/Ringtones", &s) || lstat("/var/stash/Library/Wallpaper", &s)
       || lstat("/var/stash/usr/include", &s) || lstat("/var/stash/usr/libexec", &s)  || lstat("/var/stash/usr/share", &s)
       || lstat("/var/stash/usr/arm-apple-darwin9", &s))
    {
        if(s.st_mode & S_IFLNK){
            return YES;
        }
    }
    
    //Try to write file in private
    NSError *error;
    [[NSString stringWithFormat:@"Jailbreak test string"] writeToFile:@"/private/test_jb.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(nil==error){
        //Writed
        return YES;
    } else {
        [defaultManager removeItemAtPath:@"/private/test_jb.txt" error:nil];
    }
    
#endif
    return NO;
}


#pragma mark - 获取本机号码

//此方法不能获取本机号码
-(NSString *)getPlistPhoneNum{
    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    return number;
}

//获取通讯录所有号码，本机号码可能在其中，iOS10.3测试，本机号码混在里面，但无法挑出
-(NSString *)getPhoneNum{
    __block NSString *phoneStr = nil;
    
    ABAuthorizationStatus status =ABAddressBookGetAuthorizationStatus();
    // 2.判断授权状态
    if(status ==kABAuthorizationStatusNotDetermined) {
        // 3.创建通讯录
        ABAddressBookRef addressBook =ABAddressBookCreateWithOptions(NULL,NULL);
        // 4.请求用户授权
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                phoneStr = [self getPhoneNum2];
            }
        });
        CFRelease(addressBook);
    }else{
         phoneStr = [self getPhoneNum2];
    }
    return phoneStr;
}

-(NSString *)getPhoneNum2{
    NSString *iphoneNum = nil;
    if(ABAddressBookGetAuthorizationStatus() ==kABAuthorizationStatusAuthorized) {
        // 1.获取所有联系人的数据
        // 1.1创建通讯录
        ABAddressBookRef addressBook =ABAddressBookCreateWithOptions(NULL,NULL);
        // 1.2获取所有的联系人的数组
        CFArrayRef peopleArray =ABAddressBookCopyArrayOfAllPeople(addressBook);
        // 2.获取每一个联系人的姓名和电话
        // 2.1获取联系人数组的长度
        CFIndex peopleCount =CFArrayGetCount(peopleArray);
        // 2.2获取每一个联系人
        for(NSInteger i =0; i < peopleCount; i++) {
            
            ABRecordRef person =CFArrayGetValueAtIndex(peopleArray, i);
            // 获取姓名
            NSString*firstName =CFBridgingRelease(ABRecordCopyValue(person,kABPersonFirstNameProperty));
            NSString*lastName =CFBridgingRelease(ABRecordCopyValue(person,kABPersonLastNameProperty));
            
            firstName = firstName?firstName:@"";
            lastName = lastName?lastName:@"";
            
            NSString *sumName1 = [NSString stringWithFormat:@"%@%@",firstName,lastName];
            NSString *sumName2 = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            
            
//            kABPersonPrefixProperty;             // 前缀
//            kABPersonSuffixProperty;             // 后缀
//            kABPersonNicknameProperty;           // 昵称
//            kABPersonFirstNamePhoneticProperty;  // 名字的汉语拼音或者音标
//            kABPersonLastNamePhoneticProperty;   // 姓氏汉语拼音或者音标
//            kABPersonMiddleNamePhoneticProperty; // 中间名的汉语拼音或者音标
//            kABPersonOrganizationProperty;       // 组织名
            
//            kABPersonJobTitleProperty;           // 工作头衔
//            kABPersonDepartmentProperty;         // 部门
//            kABPersonNoteProperty;               // 备注
//            kABPersonBirthdayProperty;           // 生日
//            kABPersonCreationDateProperty;       // 创建时间
//            kABPersonModificationDateProperty;   // 修改日期
            
            NSString *phoneName = [NSString stringWithFormat:@"%@%@",sumName1,sumName2];
            
            if (phoneName.length > 0) {
                // 获取电话
                ABMultiValueRef phones =ABRecordCopyValue(person,kABPersonPhoneProperty);
                // 获取电话的长度
                CFIndex phonesCount =ABMultiValueGetCount(phones);
                // 获取每一个电话
                NSMutableString *phoneStr = [NSMutableString string];
                for(NSInteger i =0; i < phonesCount; i++) {
                    //标签家庭，工作
                    NSString*label =CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
                    
                    NSLog(@"label==%@,name==%@",label,sumName2);
                    //电话号码
                    NSString*value =CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                    [phoneStr appendString:value];
                    [phoneStr appendString:@" "];
                }
                iphoneNum = phoneStr.copy;
                
                CFRelease(phones);
            }
        }
        CFRelease(addressBook);
        CFRelease(peopleArray);
    }
    return iphoneNum;
}

#pragma mark - 获取当前网络状态
-(NSString *)getNetWorkInfo{
    NSString *networktype = nil;
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
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
};


#pragma mark - 获取运行内存
-(double)getMemoryMB{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    double mem = (vm_page_size * vmStats.free_count) + (vmStats.inactive_count * vm_page_size);
    
    return mem/1024.0/1024.0;
}


#pragma mark - 获取CPU类型和核心数
-(NSString *)getCPUKind{
    
    NSInteger cpuNumber = [self getCPUNum]; //CPU核心数
    NSString *cpuType = [self getCPUType]; //获取CPU类型
    
    NSString *cpuKind = [NSString stringWithFormat:@"CPU核心数：%ld,类型：%@",(long)cpuNumber,cpuType];
    
    return cpuKind;
}

//CPU核心数
-(NSInteger)getCPUNum{
    unsigned int ncpu;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    NSInteger cpuNum = ncpu;
    return cpuNum;
}

//获取CPU类型
- (NSString *)getCPUType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return @"CPU_TYPE_ARM";
            break;
            
        case CPU_TYPE_ARM64:
            return @"CPU_TYPE_ARM64";
            break;
            
        case CPU_TYPE_X86:
            return @"CPU_TYPE_X86";
            break;
            
        case CPU_TYPE_X86_64:
            return @"CPU_TYPE_X86_64";
            break;
            
        default:
            return @"";
            break;
    }
}


#pragma mark - 获取运营商
- (NSString *)getCarrierInfo{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName=[carrier carrierName];
    return carrierName;
};

//获取运营商信息；例如，中国移动/中国联通/中国电信/运营商
-(NSString *)serviceCompany{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")])
        {
            NSString *serviceString = [info valueForKeyPath:@"serviceString"];
            return serviceString;
        }
    }
    return @"";
}


#pragma mark - 获取IMSI部分信息
-(NSString *)getImsiPart{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName=[carrier carrierName];
    NSString *cnCode = [carrier mobileCountryCode];
    NSString *mobieCode = [carrier mobileNetworkCode];
    return [NSString stringWithFormat:@"国家代码:%@;网络代码：%@;运营商：%@",cnCode,mobieCode,carrierName];
}

- (NSString *)deviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}


#pragma mark - 获取屏幕分辨率
-(NSString *)getScreenSize{
    //屏幕逻辑宽高
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    //屏幕分辨率
    CGFloat width = size_screen.width * scale_screen;
    CGFloat height = size_screen.height * scale_screen;
    
    return [NSString stringWithFormat:@"逻辑：%.0f × %.0f; 物理：%.0f × %.0f",size_screen.height,size_screen.width,height,width];
}

#pragma mark - 获取操作系统版本
-(NSString *)getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - 获取手机型号种类
-(NSString *)getDeviceType{
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
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

//创建label
-(void)createUI{
    self.labelArray = [NSMutableArray arrayWithCapacity:20];
    
    UIScrollView *sView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:sView];
    self.scrollView = sView;
    
    for (NSInteger i = 0; i < 20; i++) {
        UILabel *tempLabel = [[UILabel alloc]init];
        [self.scrollView addSubview:tempLabel];
        tempLabel.font = [UIFont systemFontOfSize:11];
        tempLabel.numberOfLines = 0;
        tempLabel.frame = CGRectMake(15, 44 * i + 20, self.view.bounds.size.width - 30, 44);
        [self.labelArray addObject:tempLabel];
    }
    contentH = 20 * 40 + 10;
    self.scrollView.contentSize = CGSizeMake(0, contentH);
}


@end
