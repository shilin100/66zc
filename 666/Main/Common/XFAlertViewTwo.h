//
//  XFAlertViewTwo.h
//  666
//
//  Created by TDC_MacMini on 2017/12/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertTwoButtonTypeCancel = 100,
    AlertTwoButtonTypeSure,
} AlertTwoButtonType;

typedef void(^AlertTwoResult)(AlertTwoButtonType type);


@interface XFAlertViewTwo : UIView

@property (nonatomic,copy) AlertTwoResult resultIndex;

- (instancetype)initWithCount:(NSString *)count message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showAlertView;

@end
