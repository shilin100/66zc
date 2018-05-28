//
//  XFHomeCarModel.m
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFCarModel.h"

@implementation XFCarModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cid":@"id"};
}
//-(NSString *)description{
//    return [NSString stringWithFormat:@"车型：%@-车牌：%@-编号：%@",self.type,self.code,self.number];
//}
@end
