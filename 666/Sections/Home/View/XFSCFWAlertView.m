//
//  XFSCFWAlertView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/28.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSCFWAlertView.h"

@interface XFSCFWAlertView ()
/**内容*/
@property (nonatomic, weak) UIView *contentView;
@end

@implementation XFSCFWAlertView
- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        // 内容contentView
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = WHITECOLOR;
        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@235.5);
            make.width.mas_equalTo(@260);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        
        // 标题
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(14);
        titleLbl.text = title;
        titleLbl.numberOfLines=2;
        titleLbl.textColor = HEXCOLOR(@"#666666");
        titleLbl.textAlignment=NSTextAlignmentCenter;
        [contentView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top).offset(15);
            make.left.equalTo(contentView.mas_left).offset(15);
            make.right.equalTo(contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@60);
        }];
        
        UILabel *dpLbl = [[UILabel alloc] init];
        dpLbl.font = XFont(13);
        dpLbl.text = @"点评";
        dpLbl.textColor = HEXCOLOR(@"#666666");
        [contentView addSubview:dpLbl];
        [dpLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).offset(5);
            make.left.equalTo(contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        
        UITextView *textView=[[UITextView alloc] init];
//        textView.text=@"请对本次服务进行点评";
        textView.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]CGColor];
        textView.layer.borderWidth = 1.0;
        [textView.layer setMasksToBounds:YES];

        textView.font=XFont(13);
        textView.textColor = HEXCOLOR(@"#666666");
        [contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).offset(5);
            make.left.equalTo(dpLbl.mas_right);
            make.right.equalTo(contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@100);
        }];
        
        
        //横线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(@0.5);
            make.top.equalTo(textView.mas_bottom).offset(15);
        }];
        
        //竖线
        UIView *verLine = [[UIView alloc] init];
        verLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [contentView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(contentView.mas_centerX);
            make.top.equalTo(line.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0.5, 40));
            
        }];
        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        cancelBtn.backgroundColor=[UIColor redColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
        cancelBtn.titleLabel.font= XFont(14);
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(contentView.mas_left);
            make.size.mas_equalTo(CGSizeMake(130, 40));
            
        }];
        
        
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        sureBtn.backgroundColor=[UIColor greenColor];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:MAINGREEN forState:UIControlStateNormal];
        sureBtn.titleLabel.font= XFont(14);
        [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(line.mas_bottom);
            make.right.equalTo(contentView.mas_right);
            make.size.mas_equalTo(CGSizeMake(130, 40));
        }];
        
    
    }
    return self;
}

-(void)show{
    CGAffineTransform scale = CGAffineTransformMakeScale(0.5,0.5);
    [self.contentView setTransform:scale];
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void) hide {
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform scale = CGAffineTransformMakeScale(0.7,0.7);
        [self.contentView setTransform:scale];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.1];
        self.contentView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)cancelBtnAction:(UIButton *)button
{
    [self hide];
}

-(void)sureBtnAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(XFSCFWAlertView:didClickSureBtn:)]) {
        [self.delegate XFSCFWAlertView:self didClickSureBtn:button];
    }
    
    if (self.sureBlock) {
        [self hide];
        self.sureBlock();
    }
    
    
}


@end
