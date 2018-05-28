//
//  XFMyBreakRulesDetailCompletedView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyBreakRulesDetailCompletedView.h"
#import "XFBreakRuleModel.h"

@interface XFMyBreakRulesDetailCompletedView() <UIScrollViewDelegate>

@end

@implementation XFMyBreakRulesDetailCompletedView

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
        
        //罚单总额
        UIView *totalMoneyContent = [[UIView alloc] init];
        totalMoneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:totalMoneyContent];
        totalMoneyContent.sd_layout
        .topEqualToView(contentScrollView)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *totalMoneyLabel1 = [[UILabel alloc] init];
        totalMoneyLabel1.text = @"罚单总额";
        totalMoneyLabel1.textAlignment=NSTextAlignmentLeft;
        totalMoneyLabel1.font = XFont(14);
        totalMoneyLabel1.textColor = HEXCOLOR(@"999999");
        [totalMoneyContent addSubview:totalMoneyLabel1];
        totalMoneyLabel1.sd_layout
        .topEqualToView(totalMoneyContent)
        .leftSpaceToView(totalMoneyContent, 10)
        .bottomEqualToView(totalMoneyContent)
        .widthIs(120);
        
        UILabel *totalMoneyLabel2 = [[UILabel alloc] init];
        //        totalMoneyLabel2.text = @"0.01";
        totalMoneyLabel2.textAlignment=NSTextAlignmentRight;
        totalMoneyLabel2.font = XFont(14);
        [totalMoneyContent addSubview:totalMoneyLabel2];
        self.totalMoneyLabel2=totalMoneyLabel2;
        totalMoneyLabel2.sd_layout
        .topEqualToView(totalMoneyContent)
        .rightSpaceToView(totalMoneyContent, 10)
        .bottomEqualToView(totalMoneyContent)
        .widthIs(180);
        
        //驾照扣分
        UIView *koufenContent = [[UIView alloc] init];
        koufenContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:koufenContent];
        koufenContent.sd_layout
        .topSpaceToView(totalMoneyContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *koufenLabel1 = [[UILabel alloc] init];
        koufenLabel1.text = @"驾照扣分";
        koufenLabel1.textAlignment=NSTextAlignmentLeft;
        koufenLabel1.font = XFont(14);
        koufenLabel1.textColor = HEXCOLOR(@"999999");
        [koufenContent addSubview:koufenLabel1];
        koufenLabel1.sd_layout
        .topEqualToView(koufenContent)
        .leftSpaceToView(koufenContent, 10)
        .bottomEqualToView(koufenContent)
        .widthIs(120);
        
        UILabel *koufenLabel2 = [[UILabel alloc] init];
        //        koufenLabel2.text = @"0.01";
        koufenLabel2.textAlignment=NSTextAlignmentRight;
        koufenLabel2.font = XFont(14);
        [koufenContent addSubview:koufenLabel2];
        self.koufenLabel2=koufenLabel2;
        koufenLabel2.sd_layout
        .topEqualToView(koufenContent)
        .rightSpaceToView(koufenContent, 10)
        .bottomEqualToView(koufenContent)
        .widthIs(180);
        
        //罚单信息
        UIView *fadanContent = [[UIView alloc] init];
        fadanContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:fadanContent];
        fadanContent.sd_layout
        .topSpaceToView(koufenContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(110)
        .rightEqualToView(contentScrollView);
        
        UILabel *fdInfoLabel1 = [[UILabel alloc] init];
        fdInfoLabel1.text = @"罚单信息";
        fdInfoLabel1.textAlignment=NSTextAlignmentLeft;
        fdInfoLabel1.font = XFont(14);
        fdInfoLabel1.textColor = HEXCOLOR(@"999999");
        [fadanContent addSubview:fdInfoLabel1];
        fdInfoLabel1.sd_layout
        .topEqualToView(fadanContent)
        .leftSpaceToView(fadanContent, 10)
        .heightIs(30)
        .widthIs(120);
        
        UIImageView *imv=[[UIImageView alloc] init];
        [fadanContent addSubview:imv];
        self.imv=imv;
        imv.sd_layout
        .topSpaceToView(fdInfoLabel1, 0)
        .leftSpaceToView(fadanContent, 10)
        .heightIs(70)
        .widthEqualToHeight();
        
        UILabel *fdInfoLabel2 = [[UILabel alloc] init];
        //        fdInfoLabel2.text = @"0.01";
        fdInfoLabel2.numberOfLines=2;
        fdInfoLabel2.textAlignment=NSTextAlignmentRight;
        fdInfoLabel2.font = XFont(14);
        [fadanContent addSubview:fdInfoLabel2];
        self.fdInfoLabel2=fdInfoLabel2;
        fdInfoLabel2.sd_layout
        .centerYEqualToView(fadanContent)
        .rightSpaceToView(fadanContent, 10)
        .heightIs(60)
        .widthIs(180);
        
        //起始位置
        UIView *startpositionContent = [[UIView alloc] init];
        startpositionContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:startpositionContent];
        startpositionContent.sd_layout
        .topSpaceToView(fadanContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(150)
        .rightEqualToView(contentScrollView);
        
        UILabel *startPoLabel1 = [[UILabel alloc] init];
        startPoLabel1.text = @"起始位置";
        startPoLabel1.textAlignment=NSTextAlignmentLeft;
        startPoLabel1.font = XFont(14);
        startPoLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:startPoLabel1];
        startPoLabel1.sd_layout
        .topEqualToView(startpositionContent)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *startPoLabel2 = [[UILabel alloc] init];
        //        startPoLabel2.text = @"洪山区丁字桥南路";
        startPoLabel2.textAlignment=NSTextAlignmentRight;
        startPoLabel2.font = XFont(14);
        [startpositionContent addSubview:startPoLabel2];
        self.startPoLabel2=startPoLabel2;
        startPoLabel2.sd_layout
        .topEqualToView(startpositionContent)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        UILabel *endPoLabel1 = [[UILabel alloc] init];
        endPoLabel1.text = @"结束位置";
        endPoLabel1.textAlignment=NSTextAlignmentLeft;
        endPoLabel1.font = XFont(14);
        endPoLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:endPoLabel1];
        endPoLabel1.sd_layout
        .topSpaceToView(startPoLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *endPoLabel2 = [[UILabel alloc] init];
        //        endPoLabel2.text = @"洪山区丁字桥南路";
        endPoLabel2.textAlignment=NSTextAlignmentRight;
        endPoLabel2.font = XFont(14);
        [startpositionContent addSubview:endPoLabel2];
        self.endPoLabel2=endPoLabel2;
        endPoLabel2.sd_layout
        .topSpaceToView(startPoLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        
        UILabel *totalTimeLabel1 = [[UILabel alloc] init];
        totalTimeLabel1.text = @"总使用时间";
        totalTimeLabel1.textAlignment=NSTextAlignmentLeft;
        totalTimeLabel1.font = XFont(14);
        totalTimeLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:totalTimeLabel1];
        totalTimeLabel1.sd_layout
        .topSpaceToView(endPoLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *totalTimeLabel2 = [[UILabel alloc] init];
        //        totalTimeLabel2.text = @"2555min";
        totalTimeLabel2.textAlignment=NSTextAlignmentRight;
        totalTimeLabel2.font = XFont(14);
        [startpositionContent addSubview:totalTimeLabel2];
        self.totalTimeLabel2=totalTimeLabel2;
        totalTimeLabel2.sd_layout
        .topSpaceToView(endPoLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        UILabel *stopTimeLabel1 = [[UILabel alloc] init];
        stopTimeLabel1.text = @"停车等待时间";
        stopTimeLabel1.textAlignment=NSTextAlignmentLeft;
        stopTimeLabel1.font = XFont(14);
        stopTimeLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:stopTimeLabel1];
        stopTimeLabel1.sd_layout
        .topSpaceToView(totalTimeLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *stopTimeLabel2 = [[UILabel alloc] init];
        //        stopTimeLabel2.text = @"123min";
        stopTimeLabel2.textAlignment=NSTextAlignmentRight;
        stopTimeLabel2.font = XFont(14);
        [startpositionContent addSubview:stopTimeLabel2];
        self.stopTimeLabel2=stopTimeLabel2;
        stopTimeLabel2.sd_layout
        .topSpaceToView(totalTimeLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        UILabel *totalMileLabel1 = [[UILabel alloc] init];
        totalMileLabel1.text = @"总行程";
        totalMileLabel1.textAlignment=NSTextAlignmentLeft;
        totalMileLabel1.font = XFont(14);
        totalMileLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:totalMileLabel1];
        totalMileLabel1.sd_layout
        .topSpaceToView(stopTimeLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *totalMileLabel2 = [[UILabel alloc] init];
        //        totalMileLabel2.text = @"666km";
        totalMileLabel2.textAlignment=NSTextAlignmentRight;
        totalMileLabel2.font = XFont(14);
        [startpositionContent addSubview:totalMileLabel2];
        self.totalMileLabel2=totalMileLabel2;
        totalMileLabel2.sd_layout
        .topSpaceToView(stopTimeLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);
        
    }
    return self;
}

-(void)setModel:(XFBreakRuleModel *)model
{
    _model = model;
    
    self.totalMoneyLabel2.text = [NSString stringWithFormat:@"%@元",self.model.pay_money];
    self.koufenLabel2.text = [NSString stringWithFormat:@"%@分",self.model.punish_score];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
    self.fdInfoLabel2.text = self.model.car_content;
    self.startPoLabel2.text = self.model.start_address;
    self.endPoLabel2.text = self.model.end_address;
    self.totalTimeLabel2.text = [NSString stringWithFormat:@"%.0f分钟",model.sum_time];
    self.stopTimeLabel2.text = [NSString stringWithFormat:@"%.0f分钟",model.time];
    self.totalMileLabel2.text = [NSString stringWithFormat:@"%.2fkm",model.distance];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self endEditing:YES];
}

@end
