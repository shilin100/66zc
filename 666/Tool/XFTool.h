//
//  XFTool.h
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end