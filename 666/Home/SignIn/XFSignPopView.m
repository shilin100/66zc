//
//  XFSignPopView.m
//  666
//
//  Created by 123 on 2018/5/16.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSignPopView.h"
@interface XFSignPopView ()

@end

@implementation XFSignPopView


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

        CGFloat width = 200;
        
        UIView * content = [UIView new];
        content.backgroundColor = WHITECOLOR;
        content.layer.cornerRadius = 5;
        content.clipsToBounds = YES;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, width*0.7));
        }];
        
        UIImageView * topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_sign_in_success"]];
        topImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:topImg];
        [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(-8);
            make.right.equalTo(content.mas_right).with.offset(9);
            make.centerY.equalTo(content.mas_top).with.offset(-13);
            make.height.mas_equalTo(@(width*0.36));
        }];
        
        UIImageView * coinImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_gold"]];
        coinImg.contentMode = UIViewContentModeScaleAspectFit;
        [content addSubview:coinImg];
        [coinImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(content);
        }];
        
        UILabel * creditsLabel  = [UILabel new];
        creditsLabel.text = @"+1积分";
        creditsLabel.textColor = REDCOLOR;
        creditsLabel.textAlignment = NSTextAlignmentCenter;
        creditsLabel.font = XFont(14);
        [content addSubview:creditsLabel];
        [creditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(coinImg.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.centerX.equalTo(content);
        }];

        UILabel * signCountLabel  = [UILabel new];
        signCountLabel.textAlignment = NSTextAlignmentCenter;
        signCountLabel.textColor = BlACKTEXT;
        signCountLabel.font = XFont(8);
        [content addSubview:signCountLabel];
        [signCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(creditsLabel.mas_bottom).with.offset(0);
            make.left.equalTo(content.mas_left).with.offset(15);
            make.right.equalTo(content.mas_right).with.offset(-15);
            make.height.mas_equalTo(@10);
        }];
        self.signInCountLabel = signCountLabel;
        
        UIButton * enterBtn = [[UIButton alloc]init];
        enterBtn.backgroundColor = RGBCOLOR(237, 157, 64);
        enterBtn.titleLabel.font = XFont(12);
        [enterBtn setTitle:@"确认" forState:UIControlStateNormal];
        [enterBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [content addSubview:enterBtn];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(signCountLabel.mas_bottom).with.offset(12);
            make.left.equalTo(content.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(60, 25));
        }];
        [enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];

        UIButton * drawBtn = [[UIButton alloc]init];
        drawBtn.backgroundColor = RGBCOLOR(237, 157, 64);
        drawBtn.titleLabel.font = XFont(12);
        [drawBtn setTitle:@"去抽奖" forState:UIControlStateNormal];
        [drawBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [content addSubview:drawBtn];
        [drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(signCountLabel.mas_bottom).with.offset(12);
            make.right.equalTo(content.mas_right).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(60, 25));
        }];
        [drawBtn addTarget:self action:@selector(drawBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void)setModel:(XFSignInModel *)model{
    _model = model;
    NSString * totalStr = [NSString stringWithFormat:@"您已签到%@次,每累计3次可参加抽奖活动！",model.signtimes];
    NSString * str = model.signtimes;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    attributeString.color = BlACKTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:REDCOLOR, NSForegroundColorAttributeName, nil] range:rang];
    self.signInCountLabel.attributedText = attributeString;
}

- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

-(void)enterBtnAction{
    [self removeFromSuperview];
}

-(void)drawBtnAction{
    if (self.drawBlock) {
        self.drawBlock();
    }
    [self removeFromSuperview];
}


@end
