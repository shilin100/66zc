//
//  XLAlertView.h
//  自定义alertView
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertButtonTypeCancel = 100,
    AlertButtonTypeSure,
} AlertButtonType;

typedef void(^AlertResult)(AlertButtonType type);

@interface XFAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showAlertView;

@end
