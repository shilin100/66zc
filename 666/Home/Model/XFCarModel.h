//
//  XFHomeCarModel.h
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XFCarModel : NSObject
@property (nonatomic, copy) NSString *cid;
/**车辆id*/
//@property (nonatomic, copy) NSString *car_id;
@property (nonatomic, assign) int state;
@property (nonatomic, copy) NSString *tell;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longtitude;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *car_number;

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *angle;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *use_type;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int userstatus;

@end
