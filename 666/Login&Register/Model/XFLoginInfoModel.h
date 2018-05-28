//
//  XFLoginInfoModel.h
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 @"phone" : @"13566665555"
 @"uid" : @"202"
 @"img" : @""
 @"number" : (no summary)
 @"user_state" : (long)2
 @"status" : (long)1
 @"info" : @""
 @"token" : @"C0D2977E647876FB60EC28400397BA91"
 @"type" : @"2"
 @"name" : @""
 @"car_state" : (long)0
 */
@interface XFLoginInfoModel : NSObject <NSCoding>
/**手机号*/
@property (nonatomic, copy) NSString *phone;
/**用户id*/
@property (nonatomic, copy) NSString *uid;
/**头像地址*/
@property (nonatomic, copy) NSString *img;
/**用户的邀请码*/
@property (nonatomic, copy) NSString *number;
/**用户状态  0：未提交信息1：待审核  2：审核通过*/
@property (nonatomic, assign) int user_state;
/**登录成功与否，1:成功 其他：失败*/
@property (nonatomic, assign) int status;
/**错误信息*/
@property (nonatomic, copy) NSString *info;
/**token*/
@property (nonatomic, copy) NSString *token;
/**用户类型 1.普通用户 2.内部用户*/
@property (nonatomic, assign) int type;
/**用户名*/
@property (nonatomic, copy) NSString *name;
/**用车状态*/
@property (nonatomic, assign) int car_state;
////////////////////////////////////////////
//user_state = 2,   0：未提交信息1：待审核  2：审核通过
/**审核状态*/
//@property (nonatomic, assign) int uesr_state;
//state = 4,  0:正常 1：需完善信息 2：押金不足 3：正在用车 4：有未完成的订单
/**用车状态*/
//@property (nonatomic, assign) int state;



@end
