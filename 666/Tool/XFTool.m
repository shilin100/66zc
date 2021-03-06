//
//  XFTool.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "UICKeyChainStore.h"


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation XFTool




/**
 get controller by view

 param currentView
 @return controller of view
 */
+(UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView
{
    for (UIView *next = currentView ; next ; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,170-179
     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|7[0-9])\\d{8}$";
    NSString * CU = @"^1([0-9][0-9])\\d{8}$";

    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}
+(NSMutableDictionary *) baseParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 系统标识(android:1 iOS:2)
    [dict setObject:@2 forKey:@"ostype"];
    // app版本
    [dict setObject:@3 forKey:@"version"];
    // imei
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.66zc"];
    if ([keychain stringForKey:@"imeiKeyChain"] != nil) {
        NSString *token = [keychain stringForKey:@"imeiKeyChain"];
        [dict setObject:token forKey:@"imei"];
    }else {
        NSString *token = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ;
        [dict setObject:token forKey:@"imei"];
        keychain[@"imeiKeyChain"] = token;
    }
    
//    [dict setObject:[XFTool getNetworkIPAddress ] forKey:@"getIP"];

    return dict;
}

+(NSMutableDictionary *)getBaseRequestParams{
    
    NSMutableDictionary *params = [XFTool baseParams];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:LoginModel_Doc_path]) {
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
    }
//    [params setObject:[XFTool getNetworkIPAddress ] forKey:@"getIP"];
    
    return params;
}


+(NSString *)stringWithMeter:(int)meter{
    return meter >= 1000 ? [NSString stringWithFormat:@"距您%.1f千米",meter*0.001] : [NSString stringWithFormat:@"距您%d米",meter];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //只判断是不是11位和第一位是否为1
    NSString *phoneRegex = @"^1[0-9]{10}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isMatch=[phoneTest evaluateWithObject:mobile];
    return isMatch;
    
}


#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getNetworkIPAddress {
    //方式一：淘宝api
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    NSString *ipStr = nil;
    if (data != nil) {
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (ipDic && [ipDic[@"code"] integerValue] == 0) {
            //获取成功
            ipStr = ipDic[@"data"][@"ip"];
        }

    }
    return (ipStr ? ipStr : @"0.0.0.0");
    
    //方式二：新浪api
//    NSError *error;
//    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
//
//    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
//    //判断返回字符串是否为所需数据
//    if ([ip hasPrefix:@"var returnCitySN = "]) {
//        //对字符串进行处理，然后进行json解析
//        //删除字符串多余字符串
//        NSRange range = NSMakeRange(0, 19);
//        [ip deleteCharactersInRange:range];
//        NSString * nowIp =[ip substringToIndex:ip.length-1];
//        //将字符串转换成二进制进行Json解析
//        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dict);
//        return dict[@"cip"] ? dict[@"cip"] : @"0.0.0.0";
//    }
//    return @"0.0.0.0";
}

#pragma mark - 获取设备当前本地IP地址
+ (NSString *)getLocalIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        //筛选出IP地址格式
        if([self isValidatIP:address]) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
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

+ (NSDictionary *)getIPAddresses {
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

static AFHTTPSessionManager * sharedManager ;
+ (AFHTTPSessionManager *)sharedHTTPSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [AFHTTPSessionManager manager];
        sharedManager.requestSerializer.timeoutInterval = 15;
    });
    return sharedManager;
}

#pragma mark -基本的GET 和POST请求

//*************************************基本的GET 和POST请求


+ (void)GetRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    NSMutableDictionary * params = [XFTool getBaseRequestParams];
    [params addEntriesFromDictionary:dic];
    
    //    MMLog(@"GET请求链接 == %@ ",urlString);
    AFHTTPSessionManager *manager = [XFTool sharedHTTPSessionManager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plan",@"text/plain", nil];
    [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falid(error);
    }];
    
}


+ (void)GetRequestWithUrlString:(NSString *)urlString Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    //    MMLog(@"GET请求链接 == %@ ",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [XFTool sharedHTTPSessionManager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plan",@"text/plain", nil];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falid(error);
    }];
}

+ (NSURLSessionDataTask *)PostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSMutableDictionary * params = [XFTool getBaseRequestParams];
    [params addEntriesFromDictionary:dic];

    //    MMLog(@"POST请求链接 == %@  %@",urlString,dic);
    AFHTTPSessionManager *manager = [XFTool sharedHTTPSessionManager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plan",@"text/plain", nil];
    NSURLSessionDataTask *urlSessionDataTask = [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falid(error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
    
    return urlSessionDataTask;
}

+ (NSURLSessionDataTask *)ClearPostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    //    MMLog(@"POST请求链接 == %@  %@",urlString,dic);
    AFHTTPSessionManager *manager = [XFTool sharedHTTPSessionManager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plan",@"text/plain", nil];
    NSURLSessionDataTask *urlSessionDataTask = [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falid(error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
    
    return urlSessionDataTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(Progress)progress
                              success:(DownloadSucceed)success
                              failure:(Failed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    AFHTTPSessionManager *sessionManager = [XFTool sharedHTTPSessionManager];
    __block NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //        返回文件位置的URL路径
        success(filePath);
        //保存的文件路径
        return [NSURL fileURLWithPath:filePath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    
    return downloadTask;
}


+ (NSURLSessionDataTask *)TestPostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSMutableDictionary * params = [XFTool getBaseRequestParams];
    [params addEntriesFromDictionary:dic];
    
    for (NSString * key in [params allKeys]) {
        
        NSData *encryptedData = [XTSecurityUtil encryptAESData:[NSString stringWithFormat:@"%@",params[key]]];
        //再进行base64位编码，不能直接转成String输出
        NSString *encryptedString = [XTSecurityUtil encodeBase64Data:encryptedData];

        
        [params setObject:encryptedString forKey:key];
    }
    
    //    MMLog(@"POST请求链接 == %@  %@",urlString,dic);
    AFHTTPSessionManager *manager = [XFTool sharedHTTPSessionManager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript",@"text/plan",@"text/plain", nil];
    NSURLSessionDataTask *urlSessionDataTask = [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falid(error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
    
    return urlSessionDataTask;
}


@end
