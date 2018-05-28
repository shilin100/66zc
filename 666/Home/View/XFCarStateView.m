//
//  XFCarStateView.m
//  666
//
//  Created by 123 on 2018/5/7.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFCarStateView.h"

@implementation XFCarStateView




+(XFCarStateView*)initWithColor:(UIColor*)color title:(NSString*)title{
    XFCarStateView * view = [[XFCarStateView alloc]init];
    
    UIView* circle = [[UIView alloc]init];
    circle.backgroundColor = color;
    [view addSubview:circle];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.font = XFont(12);
    label.textColor = HEXCOLOR(@"#545454");
    [view addSubview:label];
    
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*SCALE_WIDTH);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    circle.layer.cornerRadius = 6;
    circle.layer.masksToBounds = YES;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circle.mas_right).with.offset(5);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
    }];

    
    return view;
}

@end
