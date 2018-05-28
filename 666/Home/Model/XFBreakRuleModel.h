//
//  XFBreakRuleModel.h
//  666
//
//  Created by xiaofan on 2017/11/1.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFBreakRuleModel : NSObject

@property (nonatomic, assign) float time;
@property (nonatomic, copy) NSString *breakRule_id;
@property (nonatomic, assign) float distance;
@property (nonatomic, copy) NSString *start_address;
@property (nonatomic, assign) float sum_time;
@property (nonatomic, copy) NSString *car_content;
@property (nonatomic, copy) NSString *end_address;
@property (nonatomic, copy) NSString *pay_money;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *order_time;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *punish_status;
@property (nonatomic, copy) NSString *punish_score;



@end
