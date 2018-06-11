//
//  XFUseTicketModel.h
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFUseTicketModel : NSObject
@property (nonatomic, copy) NSString *cou_type;
//@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *ticket_id;
@property (nonatomic, assign) float money;
@property (nonatomic, assign) float fullmoney;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *satrtime;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, assign) BOOL isUsed;
@end
