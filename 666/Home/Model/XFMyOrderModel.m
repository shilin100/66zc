//
//  XFMyOrderModel.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrderModel.h"

@implementation XFMyOrderModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"order_id":@"id",@"sumMiles":@"long"};
}
@end
