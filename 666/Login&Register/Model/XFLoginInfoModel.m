//
//  XFLoginInfoModel.m
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFLoginInfoModel.h"
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
@implementation XFLoginInfoModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.phone forKey:@"login_phone"];
    [aCoder encodeObject:self.uid forKey:@"login_uid"];
    [aCoder encodeObject:self.img forKey:@"login_img"];
    [aCoder encodeObject:self.number forKey:@"login_number"];
    [aCoder encodeInt:self.user_state forKey:@"login_user_state"];
    [aCoder encodeInt:self.status forKey:@"login_status"];
    [aCoder encodeObject:self.info forKey:@"login_info"];
    [aCoder encodeObject:self.token forKey:@"login_token"];
    [aCoder encodeInt:self.type forKey:@"login_type"];
    [aCoder encodeObject:self.name forKey:@"login_name"];
    [aCoder encodeInt:self.car_state forKey:@"login_car_state"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.phone = [aDecoder decodeObjectForKey:@"login_phone"];
        self.uid = [aDecoder decodeObjectForKey:@"login_uid"];
        self.img = [aDecoder decodeObjectForKey:@"login_img"];
        self.number = [aDecoder decodeObjectForKey:@"login_number"];
        self.user_state = [aDecoder decodeIntForKey:@"login_user_state"];
        self.status = [aDecoder decodeIntForKey:@"login_status"];
        self.info = [aDecoder decodeObjectForKey:@"login_info"];
        self.token = [aDecoder decodeObjectForKey:@"login_token"];
        self.type = [aDecoder decodeIntForKey:@"login_type"];
        self.name = [aDecoder decodeObjectForKey:@"login_name"];
        self.car_state = [aDecoder decodeIntForKey:@"login_car_state"];
        
    }
    return self;
}



@end
