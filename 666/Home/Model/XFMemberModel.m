//
//  XFMemberModel.m
//  666
//
//  Created by TDC_MacMini on 2017/12/6.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMemberModel.h"

@implementation XFMemberModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"memberId":@"id"};
}
@end
