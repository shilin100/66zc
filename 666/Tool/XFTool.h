//
//  XFTool.h
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Succeed)(NSDictionary * responseObject);
typedef void(^Failed)(NSError *error);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^Progress)(NSProgress *progress);
//下载成功
typedef void(^DownloadSucceed)(NSString * filePath);


@interface XFTool : NSObject
/**判断手机号合法性*/
+ (BOOL) validateCellPhoneNumber:(NSString *)cellNum;
/*@弃用
 *请求基本参数*/
+ (NSMutableDictionary *) baseParams;
/**米-> km/m*/
+ (NSString *)stringWithMeter:(int)meter;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

/**请求基本参数*/
+(NSMutableDictionary *)getBaseRequestParams;

//获取视图所属的控制器
+(UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView;

//下载文件并缓存
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(Progress)progress
                              success:(DownloadSucceed)success
                              failure:(Failed)failure;

//post请求
+ (NSURLSessionDataTask *)PostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid;

//无参请求
+ (void)GetRequestWithUrlString:(NSString *)urlString Succeed:(Succeed)succeed andFaild:(Failed)falid;

//带参请求
+ (void)GetRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid;

@end
