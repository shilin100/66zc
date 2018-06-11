//
//  XFWXPayReqModel.h
//  666
//
//  Created by xiaofan on 2017/10/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XFWXPayReqModel : NSObject
@property (nonatomic, copy) NSString *mch_id;
@property (nonatomic, copy) NSString *result_code;
@property (nonatomic, copy) NSString *trade_type;
@property (nonatomic, copy) NSString *return_code;
@property (nonatomic, copy) NSString *nonce_str;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *return_msg;
@property (nonatomic, copy) NSString *wxpackage;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *prepay_id;
@end
