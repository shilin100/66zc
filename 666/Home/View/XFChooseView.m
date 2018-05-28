//
//  XFChooseView.m
//  666
//
//  Created by xiaofan on 2017/11/6.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFChooseView.h"

@interface XFChooseView ()
/**内容*/
@property (nonatomic, weak) UIView *contentView;
@end

@implementation XFChooseView
-(instancetype)initWithTopTitles:(NSArray<NSString *> *)topTitles bottomTitles:(NSArray<NSString *> *)bottomTitles{
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
            make.height.mas_equalTo(@150.5);
            make.width.mas_equalTo(@250);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        // 中间分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = GRAYCOLOR;
        [contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(@0.5);
            make.centerY.equalTo(contentView.mas_centerY);
        }];
        
      
        // 上部分图片
        UIImageView *topIcon = [[UIImageView alloc] init];
        topIcon.contentMode = UIViewContentModeCenter;
        topIcon.image = IMAGENAME(@"yanjin-tubiao");
        [contentView addSubview:topIcon];
        self.topImgV = topIcon;

        [topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top);
            make.left.equalTo(contentView.mas_left);
            make.bottom.equalTo(line.mas_top);
            make.width.mas_equalTo(@65);
        }];
        
        // 上部分标题
        UILabel *topTitleLbl = [[UILabel alloc] init];
        topTitleLbl.font = XFont(14);
        topTitleLbl.text = topTitles[0];
        topTitleLbl.textColor = HEXCOLOR(@"#333333");
        [contentView addSubview:topTitleLbl];
        // 上部分介绍
        UILabel *topDetailLbl = [[UILabel alloc] init];
        topDetailLbl.text = topTitles[1];
        topDetailLbl.font = XFont(13);
        topDetailLbl.textColor = HEXCOLOR(@"#666666");
        [contentView addSubview:topDetailLbl];
        
        [topTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top).offset(18);
            make.left.equalTo(topIcon.mas_right);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(@((75-36)*0.5));
        }];
        [topDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topTitleLbl.mas_left);
            make.bottom.equalTo(line.mas_top).offset(-18);
            make.right.equalTo(topTitleLbl.mas_right);
            make.height.mas_equalTo(@((75-36)*0.5));
        }];
        
        // 下部分图片
        UIImageView *bottomIcon = [[UIImageView alloc] init];
        bottomIcon.contentMode = UIViewContentModeCenter;
        bottomIcon.image = IMAGENAME(@"yanjin-tubiao");
        [contentView addSubview:bottomIcon];
        self.bottomImgV = bottomIcon;
        
        [bottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(contentView.mas_left);
            make.bottom.equalTo(contentView.mas_bottom);
            make.width.mas_equalTo(@65);
        }];
        
        // 下部分标题
        UILabel *bottomTitleLbl = [[UILabel alloc] init];
        bottomTitleLbl.text = bottomTitles[0];
        bottomTitleLbl.font = XFont(14);
        bottomTitleLbl.textColor = HEXCOLOR(@"#333333");
        [contentView addSubview:bottomTitleLbl];
        // 下部分介绍
        UILabel *bottomDetailLbl = [[UILabel alloc] init];
        bottomDetailLbl.text = bottomTitles[1];
        bottomDetailLbl.font = XFont(13);
        bottomDetailLbl.textColor = HEXCOLOR(@"#666666");
        [contentView addSubview:bottomDetailLbl];
        
        [bottomTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomIcon.mas_top).offset(18);
            make.left.equalTo(bottomIcon.mas_right);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(@((75-36)*0.5));
        }];
        [bottomDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomTitleLbl.mas_left);
            make.bottom.equalTo(contentView.mas_bottom).offset(-18);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(@((75-36)*0.5));
        }];
        
        // 关闭按钮
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:IMAGENAME(@"guanbi") forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [self removeFromSuperview];
            [self hide];
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right);
            make.bottom.equalTo(contentView.mas_top).offset(-5);
            make.height.width.mas_equalTo(@40);
        }];
        
        // 上部分按钮
        UIButton *topItemBtn = [[UIButton alloc] init];
        topItemBtn.backgroundColor = CLEARCOLOR;
        [contentView addSubview:topItemBtn];
        [[topItemBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.topBlock) {
                [self hide];
                self.topBlock();
            }
        }];
        [topItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top);
            make.left.equalTo(contentView.mas_left);
            make.bottom.equalTo(line.mas_top);
            make.right.equalTo(contentView.mas_right);
        }];
        // 下部分按钮
        UIButton *bottomItemBtn = [[UIButton alloc] init];
        bottomItemBtn.backgroundColor = CLEARCOLOR;
        [contentView addSubview:bottomItemBtn];
        [[bottomItemBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.bottomBlock) {
                [self hide];
                self.bottomBlock();
            }
        }];
        [bottomItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.equalTo(contentView.mas_left);
            make.bottom.equalTo(contentView.mas_bottom);
            make.right.equalTo(contentView.mas_right);
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
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

@end
