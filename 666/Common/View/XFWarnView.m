//
//  XFWarnView.m
//  666
//
//  Created by 123 on 2018/5/16.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFWarnView.h"

@implementation XFWarnView

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
            make.size.mas_equalTo(CGSizeMake(width, width*0.6));
        }];
        
        UIImageView * coinImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_unhappy"]];
        coinImg.contentMode = UIViewContentModeScaleAspectFit;
        [content addSubview:coinImg];
        [coinImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerX.equalTo(content);
        }];
        self.coinImg = coinImg;
        
        UILabel * creditsLabel  = [UILabel new];
        creditsLabel.text = @"";
        creditsLabel.textColor = BlACKTEXT;
        creditsLabel.textAlignment = NSTextAlignmentCenter;
        creditsLabel.font = XFont(14);
        [content addSubview:creditsLabel];
        [creditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(coinImg.mas_bottom).with.offset(0);
            make.height.mas_equalTo(@30);
            make.left.equalTo(content.mas_left).with.offset(15);
            make.right.equalTo(content.mas_right).with.offset(-15);
        }];
        self.titleLabel = creditsLabel;
        
        UIButton * enterBtn = [[UIButton alloc]init];
        enterBtn.backgroundColor = MAINGREEN;
        enterBtn.titleLabel.font = XFont(14);
        [enterBtn setTitle:@"确认" forState:UIControlStateNormal];
        [enterBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [content addSubview:enterBtn];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(0);
            make.right.equalTo(content.mas_right).with.offset(-0);
            make.height.mas_equalTo(@44);
            make.bottom.equalTo(content.mas_bottom).with.offset(0);
        }];
        [enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

-(void)showWithoutImg{
    [self.coinImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@60);
    }];
    self.titleLabel.numberOfLines = 0;
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

}

-(void)enterBtnAction{
    [self removeFromSuperview];
}


@end
