//
//  XFUserInfoModel.h
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFUserInfoModel : NSObject
/**地址*/
@property (nonatomic, copy) NSString *address;
/**地区*/
@property (nonatomic, copy) NSString *area;
/**驾驶证*/
@property (nonatomic, copy) NSString *car_card;
/**身份证*/
@property (nonatomic, copy) NSString *card;
/**亲友关系*/
@property (nonatomic, copy) NSString *friend;
/**亲友电话*/
@property (nonatomic, copy) NSString *friend_phone;
/**用户id*/
@property (nonatomic, copy) NSString *user_id;
/**头像地址*/
@property (nonatomic, copy) NSString *img;
/**错误信息*/
@property (nonatomic, copy) NSString *info;
/**isLogin*/
@property (nonatomic, assign) int islogin;
/**支付宝账号*/
@property (nonatomic, copy) NSString *paynumber;
/**电话*/
@property (nonatomic, copy) NSString *phone;
/**性别*/
@property (nonatomic, copy) NSString *sex;
/**状态 1:OK  */
@property (nonatomic, assign) int status;
/**姓名*/
@property (nonatomic, copy) NSString *username;
/**驾驶证号*/
@property (nonatomic, copy) NSString *driver_number;
/**身份证号*/
@property (nonatomic, copy) NSString *id_card;
/*
 {
 address = "";
 area = "";
 "car_card" = "";
 card = "";
 friend = "";
 "friend_phone" = "";
 id = 202;
 img = "";
 info = "";
 islogin = 0;
 paynumber = "";
 phone = 13566665555;
 sex = "\U5973";
 status = 1;
 username = Lee;
 }
 {
 id = 215,
 phone = 15629169373,
 sex = 男,
 friend = 亲友,
 id_card = 222222,
 area = 湖北 宜昌 西陵区,
 img = http://120.26.221.32:8081/Public/Upload/pic/pic/2017-11-09/5a03b5aac4681.png,
 address = CBD,
 friend_phone = 18571121872,
 driver_number = 111111,
 username = 香辣小面,
 card = http://120.26.221.32:8081/Public/Upload/pic/pic/2017-11-09/5a03b5aad4db4.png,http://120.26.221.32:8081/Public/Upload/pic/pic/2017-11-09/5a03b5aae41d4.png,
 islogin = 0,
 paynumber = ,
 car_card = http://120.26.221.32:8081/Public/Upload/pic/pic/2017-11-09/5a03b5aacdb45.png,
 status = 1,
 info =
 }
 */


@end
