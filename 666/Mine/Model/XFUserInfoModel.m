//
//  XFUserInfoModel.m
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUserInfoModel.h"

@implementation XFUserInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return@{@"user_id":@"id"};
}
@end
