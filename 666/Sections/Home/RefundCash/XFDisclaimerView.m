//
//  XFDisclaimerView.m
//  666
//
//  Created by 123 on 2018/6/23.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFDisclaimerView.h"

@implementation XFDisclaimerView

-(instancetype)init{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView * grayCover = [UIView new];
        grayCover.backgroundColor = GRAYCOLOR;
        grayCover.alpha = 0.3;
        [self addSubview:grayCover];
        [grayCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CGFloat width = 244;
        
        UIView * content = [UIView new];
        content.backgroundColor = WHITECOLOR;
//        content.layer.cornerRadius = 5;
//        content.clipsToBounds = YES;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, 276));
        }];
        
        
        UILabel * titleLabel  = [UILabel new];
        titleLabel.text = @"免责说明";
        titleLabel.textColor = BlACKTEXT;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = XFont(14);
        [content addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_top).with.offset(4);
            make.height.mas_equalTo(@30);
            make.left.equalTo(content.mas_left).with.offset(15);
            make.right.equalTo(content.mas_right).with.offset(-15);
        }];

        UIView * line = [UIView new];
        line.backgroundColor = MAINGREEN;

        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(@2);
            make.left.equalTo(content.mas_left);
            make.right.equalTo(content.mas_right);
        }];

        
        UILabel * creditsLabel  = [UILabel new];
        creditsLabel.text = @"    尊敬的用户：您好！首先感谢您对六六租车的支持，该免责说明用于用户在六六租车平台结束用车服务申请退还押金时，为了避免退款失败等问题，请用户确保个人信息以及支付宝对应账号填写无误再提交押金提现申请，平台将以用户填写的支付宝账号作为押金退款渠道。若出现由于用户个人资料填写问题导致押金退还至他人帐号的情况，此间所产生的一切后果均由用户个人承担。";
        creditsLabel.textColor = BlACKTEXT;
        creditsLabel.textAlignment = NSTextAlignmentCenter;
        creditsLabel.numberOfLines = 0;
        creditsLabel.font = XFont(12);
        [content addSubview:creditsLabel];
        [creditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(0);
            make.height.mas_equalTo(@156);
            make.left.equalTo(content.mas_left).with.offset(15);
            make.right.equalTo(content.mas_right).with.offset(-15);
        }];

        
        UIButton * enterBtn = [[UIButton alloc]init];
        enterBtn.backgroundColor = MAINGREEN;
        enterBtn.titleLabel.font = XFont(14);
        [enterBtn setTitle:@"确认" forState:UIControlStateNormal];
        [enterBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [content addSubview:enterBtn];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(0);
            make.right.equalTo(content.mas_right).with.offset(-0);
            make.height.mas_equalTo(@35);
            make.bottom.equalTo(content.mas_bottom).with.offset(0);
        }];
        [enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * logoLabel  = [UILabel new];
        logoLabel.text = @"六六租车";
        logoLabel.textColor = BlACKTEXT;
        logoLabel.textAlignment = NSTextAlignmentRight;
        logoLabel.font = XFont(12);
        [content addSubview:logoLabel];
        [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(enterBtn.mas_top).with.offset(-10);
            make.height.mas_equalTo(@30);
            make.left.equalTo(content.mas_left).with.offset(15);
            make.right.equalTo(content.mas_right).with.offset(-15);
        }];

    }
    return self;
}


+ (void)show
{
    XFDisclaimerView * view = [[XFDisclaimerView alloc]init];
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:view];
}
-(void)enterBtnAction{
    [self removeFromSuperview];
}

@end
