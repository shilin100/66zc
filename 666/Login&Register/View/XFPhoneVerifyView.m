//
//  XFPhoneVerifyView.m
//  666
//
//  Created by 123 on 2018/7/6.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFPhoneVerifyView.h"

@implementation XFPhoneVerifyView
{
    NSTimer * timer;
    NSString * reid;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView * grayCover = [UIView new];
        grayCover.backgroundColor = HEXCOLOR(@"#000000");
        grayCover.alpha = 0.5;
        [self addSubview:grayCover];
        [grayCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CGFloat width = 284;
        CGFloat height = 207;
        
        UIView * content = [UIView new];
        content.backgroundColor = HEXCOLOR(@"#DFE1E0");
        content.layer.cornerRadius = 5;
        content.clipsToBounds = YES;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        UIButton * closeBtn = [[UIButton alloc]init];
        [self addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(content.mas_top).with.offset(-12);
            make.right.equalTo(content.mas_right).with.offset(0);
            make.height.mas_equalTo(@21);
            make.width.mas_equalTo(@21);
            
        }];
        
        UILabel * msgLabel  = [UILabel new];
        msgLabel.text = @"当前帐号正在其他设备上登录,\n可通过手机验证进行登陆！";
        msgLabel.numberOfLines = 0;
        msgLabel.textColor = BlACKTEXT;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = XFont(12);
        [content addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(10);
            make.right.equalTo(content.mas_right).with.offset(-10);
            make.top.equalTo(content.mas_top).with.offset(10);
            make.height.mas_equalTo(@30);
            
        }];

        UIView * line = [UIView new];
        line.backgroundColor = MAINGREEN;
        [content addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@8);
            make.right.mas_equalTo(@-8);
            make.top.mas_equalTo(@47);
            make.height.mas_equalTo(@1);
        }];
        
        
        UITextField * phoneTextF = [UITextField new];
        phoneTextF.backgroundColor = WHITECOLOR;
        phoneTextF.placeholder = @"请输入您的手机号码";
        phoneTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        phoneTextF.leftViewMode = UITextFieldViewModeAlways;
        phoneTextF.textColor = HEXCOLOR(@"#333333");
        phoneTextF.font = XFont(11);
        [content addSubview:phoneTextF];
        self.phoneTextF = phoneTextF;
        [phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@27);
            make.right.mas_equalTo(@-27);
            make.top.equalTo(line.mas_bottom).offset(13);
            make.height.mas_equalTo(@31);
        }];
        [phoneTextF ZFAddBorderWithColor:nil Width:0];

        
        UIButton * verifyBtn = [[UIButton alloc]init];
        verifyBtn.backgroundColor = MAINGREEN;
        [verifyBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [verifyBtn setTitle:@"获取验证码(60s)" forState:UIControlStateNormal];
        verifyBtn.titleLabel.font = XFont(12);
        [content addSubview:verifyBtn];
        [verifyBtn addTarget:self action:@selector(verifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@97);
            make.right.mas_equalTo(@-27);
            make.top.equalTo(phoneTextF.mas_bottom).offset(10);
            make.height.mas_equalTo(@35);
        }];
        self.verifyBtn = verifyBtn;
        [verifyBtn ZFAddBorderWithColor:nil Width:0];

        
        UITextField * verifyTextF = [UITextField new];
        verifyTextF.backgroundColor = WHITECOLOR;
        verifyTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        verifyTextF.leftViewMode = UITextFieldViewModeAlways;
        verifyTextF.placeholder = @"请输入验证码";
        verifyTextF.textColor = HEXCOLOR(@"#333333");
        verifyTextF.font = XFont(11);
        [content addSubview:verifyTextF];
        self.verifyTextF = verifyTextF;
        [verifyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@27);
            make.right.equalTo(verifyBtn.mas_left).offset(-11);
            make.top.equalTo(phoneTextF.mas_bottom).offset(12);
            make.height.mas_equalTo(@31);
        }];
        [verifyTextF ZFAddBorderWithColor:nil Width:0];

        
        UIButton * submitBtn = [[UIButton alloc]init];
        submitBtn.backgroundColor = MAINGREEN;
        [submitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = XFont(15);
        [content addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@27);
            make.right.mas_equalTo(@-27);
            make.top.equalTo(verifyTextF.mas_bottom).offset(13);
            make.height.mas_equalTo(@35);
        }];
        self.submitBtn = submitBtn;
        [submitBtn ZFAddBorderWithColor:nil Width:0];

        
        [self.verifyTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.phoneTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.verifyBtn setBackgroundColor:GRAYCOLOR];
        self.verifyBtn.userInteractionEnabled = NO;
        [self.submitBtn setBackgroundColor:GRAYCOLOR];
        self.submitBtn.userInteractionEnabled = NO;

        
    }
    
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextF) {
        if ([RegularHelperUtil checkTelNumber:self.phoneTextF.text]) {
            [self.verifyBtn setBackgroundColor:MAINGREEN];
            [self.verifyBtn setTitle:@"获取验证码(60s)" forState:UIControlStateNormal];
            self.verifyBtn.userInteractionEnabled = YES;
            [timer invalidate];
            timer = nil;
        }else{
            [self.verifyBtn setBackgroundColor:GRAYCOLOR];
            self.verifyBtn.userInteractionEnabled = NO;
        }

    }
    if (textField == self.verifyTextF) {
        if (self.verifyTextF.text.length == 6) {
            [self.submitBtn setBackgroundColor:MAINGREEN];
            self.submitBtn.userInteractionEnabled = YES;
        }else{
            [self.submitBtn setBackgroundColor:GRAYCOLOR];
            self.submitBtn.userInteractionEnabled = NO;
        }
    }
}

-(void)submitBtnAction{
    if (![RegularHelperUtil checkTelNumber:self.phoneTextF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请正确填写11位手机号"];
        return;
    }
    if (self.verifyTextF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入验证码"];
        return;

    }
    if (reid == nil) {
        [SVProgressHUD showErrorWithStatus:@"请获取验证码"];
        return;
    }
    
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:self.phoneTextF.text forKey:@"phone"];
    //    type    1 //z注册验证  2修改密码验证  3暂未知 4 解除登录限制验证
    [params setValue:@4 forKey:@"type"];
    [params setObject:self.verifyTextF.text forKey:@"verifyCode"];
    [params setObject:reid forKey:@"reid"];

    [XFTool ClearPostRequestWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/index/validate"] withDic:params Succeed:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            [SVProgressHUD dismissWithDelay:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeBtnAction];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        
    } andFaild:^(NSError *error) {
        
    }];

    
}
-(void)verifyBtnAction{
    if (![RegularHelperUtil checkTelNumber:self.phoneTextF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请正确填写11位手机号"];
        return;
    }
    
    [timer invalidate];
    timer = nil;
    __block int i = 1;
    [self.verifyBtn setBackgroundColor:GRAYCOLOR];
    self.verifyBtn.userInteractionEnabled = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        [self.verifyBtn setTitle:[NSString stringWithFormat:@"获取验证码(%ds)",60 - i] forState:UIControlStateNormal];
        i++;
        if (i > 60) {
            [self.verifyBtn setTitle:@"获取验证码(60s)" forState:UIControlStateNormal];
            [self.verifyBtn setBackgroundColor:MAINGREEN];
            self.verifyBtn.userInteractionEnabled = YES;
            [timer invalidate];
        }
    } repeats:YES];
    
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:self.phoneTextF.text forKey:@"phone"];
    [params setValue:@4 forKey:@"type"];

    [XFTool ClearPostRequestWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Index/GetCode?"] withDic:params Succeed:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) { //获取验证码成功
            reid = responseObject[@"reid"];
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1.2];

        }else{ // 获取验证码失败
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }

    } andFaild:^(NSError *error) {
        
    }];
}

-(void)closeBtnAction{

    [self removeFromSuperview];
}


+ (XFPhoneVerifyView*)show
{
    XFPhoneVerifyView * view = [[XFPhoneVerifyView alloc]init];
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:view];
    return view;
}
@end
