//
//  XFPhoneVerifyView.h
//  666
//
//  Created by 123 on 2018/7/6.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFPhoneVerifyView : UIView

@property(nonatomic,weak)UITextField * phoneTextF;
@property(nonatomic,weak)UITextField * verifyTextF;
@property(nonatomic,weak)UIButton * verifyBtn;
@property(nonatomic,weak)UIButton * submitBtn;


+(XFPhoneVerifyView *)show;

@end
