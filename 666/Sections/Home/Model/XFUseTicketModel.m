//
//  XFUseTicketModel.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUseTicketModel.h"

@implementation XFUseTicketModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ticket_id":@"id"};
}
@end
