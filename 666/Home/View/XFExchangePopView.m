//
//  XFExchangePopView.m
//  666
//
//  Created by 123 on 2018/5/17.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFExchangePopView.h"

@implementation XFExchangePopView


-(instancetype)initWithTitle:(NSString*)title Msg:(NSString*)msg ExchangType:(ExchangeType)type{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView * grayCover = [UIView new];
        grayCover.backgroundColor = GRAYCOLOR;
        grayCover.alpha = 0.3;
        [self addSubview:grayCover];
        [grayCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CGFloat width = 200;
        CGFloat height = width*0.6 + (msg.length/10>2 ? (msg.length/10-2)*20 : 0);
        if (type == ExchangeSuccess) {
            height = width * 0.75 + (msg.length/10>2 ? (msg.length/10-2)*20 : 0);
        }
        
        UIView * content = [UIView new];
        content.backgroundColor = RGBCOLOR(245, 65, 59);
        content.layer.cornerRadius = 5;
        content.clipsToBounds = YES;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        UIImageView * topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_discount_body"]];
        topImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:topImg];
        [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(-18);
            make.right.equalTo(content.mas_right).with.offset(18);
            make.centerY.equalTo(content.mas_top).with.offset(-8);
            make.height.mas_equalTo(@(width*0.4));
        }];
        
        if (type == ExchangeSuccess) {
            UIImageView * awardImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_discount_head"]];
            awardImg.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:awardImg];
            [awardImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(content.mas_left).with.offset(40);
                make.right.equalTo(content.mas_right).with.offset(-40);
                make.bottom.equalTo(topImg.mas_top).with.offset(22);
                make.height.mas_equalTo(@(width*0.4));
            }];

        }
        
        UILabel * titleLabel  = [UILabel new];
        titleLabel.text = title;
        titleLabel.textColor = RGBCOLOR(246, 126, 15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"FZZYJW--GB1-0" size:16.f];
        [topImg addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@5);
            make.left.equalTo(topImg.mas_left).with.offset(20);
            make.right.equalTo(topImg.mas_right).with.offset(-20);
            make.bottom.mas_equalTo(@-10);
        }];

        
        UIButton * enterBtn = [[UIButton alloc]init];
        enterBtn.backgroundColor = RGBCOLOR(249, 197, 54);
        enterBtn.titleLabel.font = XFont(12);
        [enterBtn setTitle:@"确认" forState:UIControlStateNormal];
        [enterBtn setTitleColor:RGBCOLOR(158, 92, 17) forState:UIControlStateNormal];
        [content addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(content.mas_bottom).with.offset(-20);
            make.left.equalTo(content.mas_left).with.offset(40);
            make.right.equalTo(content.mas_right).with.offset(-40);
            make.height.mas_equalTo(@30);
        }];
        
        if (type == ExchangeSuccess) {
            [enterBtn setTitle:@"稍候再说" forState:UIControlStateNormal];
            enterBtn.backgroundColor = [UIColor clearColor];
            [enterBtn setTitleColor:RGBCOLOR(249, 197, 54) forState:UIControlStateNormal];
        }
        
        
        UILabel * msgLabel  = [UILabel new];
        msgLabel.text = msg;
        msgLabel.numberOfLines = 0;
        msgLabel.textColor = WHITECOLOR;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = XFont(14);
        [content addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@20);
            make.left.equalTo(content.mas_left).with.offset(20);
            make.right.equalTo(content.mas_right).with.offset(-20);
            make.bottom.equalTo(enterBtn.mas_top).with.offset(0);
        }];
        if (type == ExchangeSuccess) {
            UIButton * checkBtn = [[UIButton alloc]init];
            checkBtn.backgroundColor = RGBCOLOR(249, 197, 54);
            checkBtn.titleLabel.font = XFont(12);
            [checkBtn setTitle:@"立即查看" forState:UIControlStateNormal];
            [checkBtn setTitleColor:RGBCOLOR(158, 92, 17) forState:UIControlStateNormal];
            [content addSubview:checkBtn];
            [checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(enterBtn.mas_top);
                make.left.equalTo(content.mas_left).with.offset(40);
                make.right.equalTo(content.mas_right).with.offset(-40);
                make.height.mas_equalTo(@30);
            }];

            [msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(checkBtn.mas_top).with.offset(0);
                make.top.mas_equalTo(@20);
                make.left.equalTo(content.mas_left).with.offset(20);
                make.right.equalTo(content.mas_right).with.offset(-20);
            }];
        }

    }
    return self;

    

}

- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

-(void)enterBtnAction{
    [self removeFromSuperview];
}

-(void)checkBtnAction{
    if (self.exchangeCheckBlock) {
        self.exchangeCheckBlock();
    }

    [self removeFromSuperview];
}

@end
