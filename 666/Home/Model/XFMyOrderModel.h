//
//  XFMyOrderModel.h
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMyOrderModel : NSObject
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, assign) float cost;
@property (nonatomic, assign) float money;
@property (nonatomic, assign) int cou_type;
@property (nonatomic, assign) float sumMiles;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) int stop_time;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) float stop_cost;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *end_address;
//@property (nonatomic, assign) float sum_time;
@property (nonatomic, copy) NSString *sum_time;
@property (nonatomic, assign) int iscoupon;
@property (nonatomic, copy) NSString *start_address;
@property (nonatomic, copy) NSString *coupon_id;
@property (nonatomic, assign) int status;
@property (nonatomic , copy) NSString              * start_time;
@property (nonatomic , copy) NSString              * coupon;
@property (nonatomic , copy) NSString              * end_time;

@property (nonatomic, copy) NSString *car_mark;
@property (nonatomic, copy) NSString *car_number;
@property (nonatomic, copy) NSString *is_oil;
@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *three_h;
@property (nonatomic, copy) NSString *km;
@property (nonatomic, copy) NSString *starting;
@property (nonatomic, copy) NSString *paycoupon;
@property (nonatomic, copy) NSString *brand;

@end
