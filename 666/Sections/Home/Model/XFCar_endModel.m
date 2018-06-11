//
//  XFCar_endModel.m
//  666
//
//  Created by TDC_MacMini on 2017/12/1.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFCar_endModel.h"

@implementation XFCar_endModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"order_id":@"id",@"longMiles":@"long"};
}

@end
