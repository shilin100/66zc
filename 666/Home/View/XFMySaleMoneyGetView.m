//
//  XFMySaleMoneyGetView.m
//  666
//
//  Created by TDC_MacMini on 2017/12/7.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMySaleMoneyGetView.h"

@interface XFMySaleMoneyGetView() <UIScrollViewDelegate>

@end

@implementation XFMySaleMoneyGetView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // scrollView
        UIScrollView *contentScrollView = [[UIScrollView alloc] init];
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.backgroundColor = HEXCOLOR(@"#eeeeee");
        [self addSubview:contentScrollView];
        contentScrollView.delegate = self;
        contentScrollView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .bottomEqualToView(self)
        .rightEqualToView(self);
        
        //支付方式
        UILabel *payTypeLabel = [[UILabel alloc] init];
        payTypeLabel.text = @"提现账户";
        payTypeLabel.textColor = BLACKCOLOR;
        payTypeLabel.textAlignment=NSTextAlignmentLeft;
        payTypeLabel.font = XFont(14);
        [contentScrollView addSubview:payTypeLabel];
        payTypeLabel.sd_layout
        .topSpaceToView(contentScrollView, 0)
        .leftSpaceToView(contentScrollView, 10)
        .heightIs(44)
        .widthIs(120);
        
        
        UIView *payTypeContent = [[UIView alloc] init];
        payTypeContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:payTypeContent];
        payTypeContent.sd_layout
        .topSpaceToView(payTypeLabel, 0)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UIImageView *zfbImv=[[UIImageView alloc] init];
        zfbImv.image=IMAGENAME(@"zhifubao");
        zfbImv.contentMode = UIViewContentModeLeft;
        [payTypeContent addSubview:zfbImv];
        zfbImv.sd_layout
        .topEqualToView(payTypeContent)
        .bottomEqualToView(payTypeContent)
        .leftSpaceToView(payTypeContent, 10)
        .widthIs(27);
        
        UILabel *zfbLabel = [[UILabel alloc] init];
        zfbLabel.text = @"支付宝";
        zfbLabel.textAlignment=NSTextAlignmentLeft;
        zfbLabel.font = XFont(14);
        [payTypeContent addSubview:zfbLabel];
        zfbLabel.sd_layout
        .topEqualToView(payTypeContent)
        .bottomEqualToView(payTypeContent)
        .leftSpaceToView(zfbImv, 0)
        .widthIs(120);
        
        UIButton *zfbBtn = [[UIButton alloc] init];
        [zfbBtn setImage:IMAGENAME(@"xingbie-xuanzhong") forState:UIControlStateNormal];
        [payTypeContent addSubview:zfbBtn];
        zfbBtn.sd_layout
        .topEqualToView(payTypeContent)
        .bottomEqualToView(payTypeContent)
        .widthIs(43)
        .rightSpaceToView(payTypeContent, 10);
        
        
        //提现金额
        UIView *moneyContent = [[UIView alloc] init];
        moneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:moneyContent];
        moneyContent.sd_layout
        .topSpaceToView(payTypeContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *moneyLabel1 = [[UILabel alloc] init];
        moneyLabel1.text = @"申请金额";
        moneyLabel1.textAlignment=NSTextAlignmentLeft;
        moneyLabel1.font = XFont(14);
        moneyLabel1.textColor = BLACKCOLOR;
        [moneyContent addSubview:moneyLabel1];
        moneyLabel1.sd_layout
        .topEqualToView(moneyContent)
        .bottomEqualToView(moneyContent)
        .leftSpaceToView(moneyContent, 10)
        .widthIs(80);
        
        
        UITextField *moneyTF = [[UITextField alloc] init];
        moneyTF.keyboardType=UIKeyboardTypeNumberPad;
        moneyTF.font = XFont(14);
        moneyTF.textColor = RGBCOLORe(51);
        moneyTF.placeholder = @"请输入提现金额";
        [moneyContent addSubview:moneyTF];
        self.moneyTF = moneyTF;
        moneyTF.sd_layout
        .topEqualToView(moneyContent)
        .bottomEqualToView(moneyContent)
        .leftSpaceToView(moneyLabel1, 10)
        .widthIs(150);
        
        //余额额度
        UIView *accountContent = [[UIView alloc] init];
        accountContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:accountContent];
        accountContent.sd_layout
        .topSpaceToView(moneyContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(88)
        .rightEqualToView(contentScrollView);
        
        UILabel *yeLabel1 = [[UILabel alloc] init];
        yeLabel1.text = @"账户余额";
        yeLabel1.textAlignment=NSTextAlignmentLeft;
        yeLabel1.font = XFont(14);
        yeLabel1.textColor = BLACKCOLOR;
        [accountContent addSubview:yeLabel1];
        yeLabel1.sd_layout
        .topEqualToView(accountContent)
        .leftSpaceToView(accountContent, 10)
        .heightIs(44)
        .widthIs(80);
        
      
        UILabel *yeLabel2 = [[UILabel alloc] init];
//        yeLabel2.text = @"0.00元";
        yeLabel2.textAlignment=NSTextAlignmentRight;
        yeLabel2.font = XFont(14);
        yeLabel2.textColor = HEXCOLOR(@"999999");
        [accountContent addSubview:yeLabel2];
        self.yeLabel2=yeLabel2;
        yeLabel2.sd_layout
        .topEqualToView(accountContent)
        .rightSpaceToView(accountContent, 10)
        .heightIs(44)
        .widthIs(120);
        
        
        UILabel *eduLabel1 = [[UILabel alloc] init];
        eduLabel1.text = @"可提现额度";
        eduLabel1.textAlignment=NSTextAlignmentLeft;
        eduLabel1.font = XFont(14);
        eduLabel1.textColor = BLACKCOLOR;
        [accountContent addSubview:eduLabel1];
        eduLabel1.sd_layout
        .topSpaceToView(yeLabel1, 0)
        .leftSpaceToView(accountContent, 10)
        .heightIs(44)
        .widthIs(80);
        
        
        UILabel *eduLabel2 = [[UILabel alloc] init];
//        eduLabel2.text = @"0.00元";
        eduLabel2.textAlignment=NSTextAlignmentRight;
        eduLabel2.font = XFont(14);
        eduLabel2.textColor = HEXCOLOR(@"999999");
        [accountContent addSubview:eduLabel2];
        self.eduLabel2=eduLabel2;
        eduLabel2.sd_layout
        .topSpaceToView(yeLabel2, 0)
        .rightSpaceToView(accountContent, 10)
        .heightIs(44)
        .widthIs(120);
        
        
        
        UIButton *commitBtn = [[UIButton alloc] init];
        commitBtn.backgroundColor=MAINGREEN;
        commitBtn.layer.cornerRadius=20;
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        commitBtn.titleLabel.font=XFont(14);
        [contentScrollView addSubview:commitBtn];
        self.commitBtn=commitBtn;
        [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFMySaleMoneyGetView:didClickCommitBtn:)]) {
                [self.delegate XFMySaleMoneyGetView:self didClickCommitBtn:commitBtn];
            }
            
        }];
        
        commitBtn.sd_layout
        .centerXEqualToView(contentScrollView)
        .topSpaceToView(accountContent, 30)
        .widthIs(270)
        .heightIs(40);
        
        [contentScrollView setupAutoContentSizeWithBottomView:commitBtn bottomMargin:20];
        
    }
    
    return self;
}



@end
