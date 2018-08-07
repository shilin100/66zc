//
//  SVProgressHUD+XFDismiss.m
//  666
//
//  Created by 123 on 2018/7/4.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "SVProgressHUD+XFDismiss.h"

@implementation SVProgressHUD (XFDismiss)

+ (void)dissmissAfter:(CGFloat)time{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
