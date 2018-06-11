//
//  XFMyOrderDetailCompletedView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/24.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrderDetailCompletedView.h"
#import "XFMyOrderModel.h"

@interface XFMyOrderDetailCompletedView() <UIScrollViewDelegate>

@end

@implementation XFMyOrderDetailCompletedView

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
        
        //消费总额
        UIView *totalMoneyContent = [[UIView alloc] init];
        totalMoneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:totalMoneyContent];
        totalMoneyContent.sd_layout
        .topEqualToView(contentScrollView)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *totalMoneyLabel1 = [[UILabel alloc] init];
        totalMoneyLabel1.text = @"消费总额";
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
        
        
        //起始位置
        UIView *startpositionContent = [[UIView alloc] init];
        startpositionContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:startpositionContent];
        startpositionContent.sd_layout
        .topSpaceToView(totalMoneyContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(210)
        .rightEqualToView(contentScrollView);
        
        UILabel *cphLabel1 = [[UILabel alloc] init];
        cphLabel1.text = @"车牌号";
        cphLabel1.textAlignment=NSTextAlignmentLeft;
        cphLabel1.font = XFont(14);
        cphLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:cphLabel1];
        cphLabel1.sd_layout
        .topEqualToView(startpositionContent)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(80)
        .heightIs(30);
        
        UILabel *cphLabel2 = [[UILabel alloc] init];
        //                cphLabel2.text = @"鄂A123456789";
        cphLabel2.textAlignment=NSTextAlignmentRight;
        cphLabel2.font = XFont(14);
        [startpositionContent addSubview:cphLabel2];
        self.cphLabel2=cphLabel2;
        cphLabel2.sd_layout
        .topEqualToView(startpositionContent)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(220);

        UILabel *startPoLabel1 = [[UILabel alloc] init];
        startPoLabel1.text = @"起始位置";
        startPoLabel1.textAlignment=NSTextAlignmentLeft;
        startPoLabel1.font = XFont(14);
        startPoLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:startPoLabel1];
        startPoLabel1.sd_layout
        .topSpaceToView(cphLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(80)
        .heightIs(30);

        UILabel *startPoLabel2 = [[UILabel alloc] init];
//        startPoLabel2.text = @"洪山区丁字桥南路";
        startPoLabel2.textAlignment=NSTextAlignmentRight;
        startPoLabel2.font = XFont(14);
        [startpositionContent addSubview:startPoLabel2];
        self.startPoLabel2=startPoLabel2;
        startPoLabel2.sd_layout
        .topSpaceToView(cphLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(220);

        UILabel *endPoLabel1 = [[UILabel alloc] init];
        endPoLabel1.text = @"结束位置";
        endPoLabel1.textAlignment=NSTextAlignmentLeft;
        endPoLabel1.font = XFont(14);
        endPoLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:endPoLabel1];
        endPoLabel1.sd_layout
        .topSpaceToView(startPoLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(80)
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
        .widthIs(220);



//        UILabel *stopTimeLabel1 = [[UILabel alloc] init];
//        stopTimeLabel1.text = @"停车等待时间";
//        stopTimeLabel1.textAlignment=NSTextAlignmentLeft;
//        stopTimeLabel1.font = XFont(14);
//        stopTimeLabel1.textColor = HEXCOLOR(@"999999");
//        [startpositionContent addSubview:stopTimeLabel1];
//        stopTimeLabel1.sd_layout
//        .topSpaceToView(totalTimeLabel1, 0)
//        .leftSpaceToView(startpositionContent, 10)
//        .widthIs(120)
//        .heightIs(30);
//
//        UILabel *stopTimeLabel2 = [[UILabel alloc] init];
////        stopTimeLabel2.text = @"123min";
//        stopTimeLabel2.textAlignment=NSTextAlignmentRight;
//        stopTimeLabel2.font = XFont(14);
//        [startpositionContent addSubview:stopTimeLabel2];
//        self.stopTimeLabel2=stopTimeLabel2;
//        stopTimeLabel2.sd_layout
//        .topSpaceToView(totalTimeLabel2, 0)
//        .rightSpaceToView(startpositionContent, 10)
//        .heightIs(30)
//        .widthIs(180);

        UILabel *totalMileLabel1 = [[UILabel alloc] init];
        totalMileLabel1.text = @"总行程";
        totalMileLabel1.textAlignment=NSTextAlignmentLeft;
        totalMileLabel1.font = XFont(14);
        totalMileLabel1.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:totalMileLabel1];
        totalMileLabel1.sd_layout
        .topSpaceToView(endPoLabel1, 0)
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
        .topSpaceToView(endPoLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);

        UILabel *startTimeLabel = [[UILabel alloc] init];
        startTimeLabel.text = @"开始时间";
        startTimeLabel.textAlignment=NSTextAlignmentLeft;
        startTimeLabel.font = XFont(14);
        startTimeLabel.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:startTimeLabel];
        startTimeLabel.sd_layout
        .topSpaceToView(totalMileLabel1, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *startTimeLabel2 = [[UILabel alloc] init];
        startTimeLabel2.textAlignment=NSTextAlignmentRight;
        startTimeLabel2.font = XFont(14);
        [startpositionContent addSubview:startTimeLabel2];
        self.startTimeLabel2=startTimeLabel2;
        startTimeLabel2.sd_layout
        .topSpaceToView(totalMileLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);

        
        UILabel *endTimeLabel = [[UILabel alloc] init];
        endTimeLabel.text = @"结束时间";
        endTimeLabel.textAlignment=NSTextAlignmentLeft;
        endTimeLabel.font = XFont(14);
        endTimeLabel.textColor = HEXCOLOR(@"999999");
        [startpositionContent addSubview:endTimeLabel];
        endTimeLabel.sd_layout
        .topSpaceToView(startTimeLabel, 0)
        .leftSpaceToView(startpositionContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *endTimeLabel2 = [[UILabel alloc] init];
        endTimeLabel2.textAlignment=NSTextAlignmentRight;
        endTimeLabel2.font = XFont(14);
        [startpositionContent addSubview:endTimeLabel2];
        self.endTimeLabel2=endTimeLabel2;
        endTimeLabel2.sd_layout
        .topSpaceToView(startTimeLabel2, 0)
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
        .topSpaceToView(endTimeLabel, 0)
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
        .topSpaceToView(endTimeLabel2, 0)
        .rightSpaceToView(startpositionContent, 10)
        .heightIs(30)
        .widthIs(180);

        
        //里程金额
        UIView *mileMoneyContent = [[UIView alloc] init];
        mileMoneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:mileMoneyContent];
        mileMoneyContent.sd_layout
        .topSpaceToView(startpositionContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(90)
        .rightEqualToView(contentScrollView);

        UILabel *bxMoLabel1 = [[UILabel alloc] init];
        bxMoLabel1.text = @"保险金额";
        bxMoLabel1.textAlignment=NSTextAlignmentLeft;
        bxMoLabel1.font = XFont(14);
        bxMoLabel1.textColor = HEXCOLOR(@"999999");
        [mileMoneyContent addSubview:bxMoLabel1];
        bxMoLabel1.sd_layout
        .topEqualToView(mileMoneyContent)
        .leftSpaceToView(mileMoneyContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *bxMoLabel2 = [[UILabel alloc] init];
        //        bxMoLabel2.text = @"10";
        bxMoLabel2.textAlignment=NSTextAlignmentRight;
        bxMoLabel2.font = XFont(14);
        [mileMoneyContent addSubview:bxMoLabel2];
        self.bxMoLabel2=bxMoLabel2;
        bxMoLabel2.sd_layout
        .topEqualToView(mileMoneyContent)
        .rightSpaceToView(mileMoneyContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        
        UILabel *mileMoLabel1 = [[UILabel alloc] init];
        mileMoLabel1.text = @"里程金额";
        mileMoLabel1.textAlignment=NSTextAlignmentLeft;
        mileMoLabel1.font = XFont(14);
        mileMoLabel1.textColor = HEXCOLOR(@"999999");
        [mileMoneyContent addSubview:mileMoLabel1];
        mileMoLabel1.sd_layout
        .topSpaceToView(bxMoLabel1, 0)
        .leftSpaceToView(mileMoneyContent, 10)
        .widthIs(120)
        .heightIs(30);

        UILabel *mileMoLabel2 = [[UILabel alloc] init];
//        mileMoLabel2.text = @"10";
        mileMoLabel2.textAlignment=NSTextAlignmentRight;
        mileMoLabel2.font = XFont(14);
        [mileMoneyContent addSubview:mileMoLabel2];
        self.mileMoLabel2=mileMoLabel2;
        mileMoLabel2.sd_layout
        .topSpaceToView(bxMoLabel2, 0)
        .rightSpaceToView(mileMoneyContent, 10)
        .heightIs(30)
        .widthIs(180);


        UILabel *stopMoLabel1 = [[UILabel alloc] init];
        stopMoLabel1.text = @"时间金额";
        stopMoLabel1.textAlignment=NSTextAlignmentLeft;
        stopMoLabel1.font = XFont(14);
        stopMoLabel1.textColor = HEXCOLOR(@"999999");
        [mileMoneyContent addSubview:stopMoLabel1];
        stopMoLabel1.sd_layout
        .topSpaceToView(mileMoLabel1, 0)
        .leftSpaceToView(mileMoneyContent, 10)
        .widthIs(120)
        .heightIs(30);

        UILabel *stopMoLabel2 = [[UILabel alloc] init];
//        stopMoLabel2.text = @"100";
        stopMoLabel2.textAlignment=NSTextAlignmentRight;
        stopMoLabel2.font = XFont(14);
        [mileMoneyContent addSubview:stopMoLabel2];
        self.stopMoLabel2=stopMoLabel2;
        stopMoLabel2.sd_layout
        .topSpaceToView(mileMoLabel2, 0)
        .rightSpaceToView(mileMoneyContent, 10)
        .heightIs(30)
        .widthIs(180);


        //优惠券
        UIView *ticketContent = [[UIView alloc] init];
        ticketContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:ticketContent];
        ticketContent.sd_layout
        .topSpaceToView(mileMoneyContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(60)
        .rightEqualToView(contentScrollView);

        UILabel *realPayLabel1 = [[UILabel alloc] init];
        realPayLabel1.text = @"实际支付金额";
        realPayLabel1.textAlignment=NSTextAlignmentLeft;
        realPayLabel1.font = XFont(14);
        realPayLabel1.textColor = HEXCOLOR(@"999999");
        [ticketContent addSubview:realPayLabel1];
        realPayLabel1.sd_layout
        .topEqualToView(ticketContent)
        .leftSpaceToView(ticketContent, 10)
        .widthIs(120)
        .heightIs(30);

        UILabel *realPayLabel2 = [[UILabel alloc] init];
//        realPayLabel2.text = @"100元";
        realPayLabel2.textAlignment=NSTextAlignmentRight;
        realPayLabel2.font = XFont(14);
        [ticketContent addSubview:realPayLabel2];
        self.realPayLabel2=realPayLabel2;
        realPayLabel2.sd_layout
        .topEqualToView(ticketContent)
        .rightSpaceToView(ticketContent, 10)
        .heightIs(30)
        .widthIs(180);
        
        
        UILabel *ticketLabel1 = [[UILabel alloc] init];
        ticketLabel1.text = @"使用优惠券支付金额";
        ticketLabel1.textAlignment=NSTextAlignmentLeft;
        ticketLabel1.font = XFont(14);
        ticketLabel1.textColor = HEXCOLOR(@"999999");
        [ticketContent addSubview:ticketLabel1];
        ticketLabel1.sd_layout
        .topSpaceToView(realPayLabel1, 0)
        .leftSpaceToView(ticketContent, 10)
        .widthIs(140)
        .heightIs(30);
        
        UILabel *ticketLabel2 = [[UILabel alloc] init];
        //        ticketLabel2.text = @"6元";
        ticketLabel2.textAlignment=NSTextAlignmentRight;
        ticketLabel2.font = XFont(14);
        [ticketContent addSubview:ticketLabel2];
        self.ticketLabel2=ticketLabel2;
        ticketLabel2.sd_layout
        .topSpaceToView(realPayLabel2, 0)
        .rightSpaceToView(ticketContent, 10)
        .heightIs(30)
        .widthIs(160);
        
        
        UIView *creditsContent = [[UIView alloc] init];
        creditsContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:creditsContent];
        creditsContent.sd_layout
        .topSpaceToView(ticketContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(30)
        .rightEqualToView(contentScrollView);
        
        UILabel *creditsLabel1 = [[UILabel alloc] init];
        creditsLabel1.text = @"可获取积分";
        creditsLabel1.textAlignment=NSTextAlignmentLeft;
        creditsLabel1.font = XFont(14);
        creditsLabel1.textColor = HEXCOLOR(@"999999");
        [creditsContent addSubview:creditsLabel1];
        creditsLabel1.sd_layout
        .topSpaceToView(creditsContent, 0)
        .leftSpaceToView(creditsContent, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *creditsLabel2 = [[UILabel alloc] init];
        creditsLabel2.textAlignment=NSTextAlignmentRight;
        creditsLabel2.textColor = MAINGREEN;
        creditsLabel2.font = XFont(14);
        [creditsContent addSubview:creditsLabel2];
        self.creditsLabel2=creditsLabel2;
        creditsLabel2.sd_layout
        .topSpaceToView(creditsContent, 0)
        .rightSpaceToView(creditsContent, 10)
        .heightIs(30)
        .widthIs(180);


        //支付方式
//        UIView *paystyleContent = [[UIView alloc] init];
//        paystyleContent.backgroundColor = WHITECOLOR;
//        [contentScrollView addSubview:paystyleContent];
//        paystyleContent.sd_layout
//        .topSpaceToView(ticketContent, 1)
//        .leftEqualToView(contentScrollView)
//        .heightIs(30)
//        .rightEqualToView(contentScrollView);
//
//        UILabel *paystyleLabel = [[UILabel alloc] init];
//        paystyleLabel.text = @"支付方式";
//        paystyleLabel.textAlignment=NSTextAlignmentLeft;
//        paystyleLabel.font = XFont(14);
//        paystyleLabel.textColor = HEXCOLOR(@"999999");
//        [paystyleContent addSubview:paystyleLabel];
//        paystyleLabel.sd_layout
//        .topEqualToView(paystyleContent)
//        .bottomEqualToView(paystyleContent)
//        .leftSpaceToView(paystyleContent, 10)
//        .widthIs(120)
//        .heightIs(30);
//
//        UILabel *paystyleLabe2 = [[UILabel alloc] init];
//        paystyleLabe2.text = @"支付宝";
//        paystyleLabe2.textAlignment=NSTextAlignmentRight;
//        paystyleLabe2.font = XFont(14);
//        [paystyleContent addSubview:paystyleLabe2];
//        paystyleLabe2.sd_layout
//        .topEqualToView(paystyleContent)
//        .bottomEqualToView(paystyleContent)
//        .rightSpaceToView(paystyleContent, 10)
//        .heightIs(30)
//        .widthIs(180);

        
        //我的行程
        UIView *mileContent = [[UIView alloc] init];
        mileContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:mileContent];
        mileContent.sd_layout
        .topSpaceToView(creditsContent, 20)
        .leftEqualToView(contentScrollView)
        .heightIs(70)
        .rightEqualToView(contentScrollView);
        
        
        UIButton *mileBtn = [[UIButton alloc] init];
        mileBtn.layer.cornerRadius=5;
        mileBtn.layer.borderColor=HEXCOLOR(@"999999").CGColor;
        mileBtn.layer.borderWidth=1;
        [mileBtn setTitle:@"我的行程" forState:UIControlStateNormal];
        [mileBtn setTitleColor:HEXCOLOR(@"999999") forState:UIControlStateNormal];
        mileBtn.titleLabel.font=XFont(14);
//        [mileBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        [mileContent addSubview:mileBtn];
        [[mileBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

            if (self.delegate && [self.delegate respondsToSelector:@selector(XFMyOrderDetailCompletedView:didClickTripBtn:)]) {
                [self.delegate XFMyOrderDetailCompletedView:self didClickTripBtn:mileBtn];
            }

        }];

        mileBtn.sd_layout
        .centerXEqualToView(mileContent)
        .topSpaceToView(mileContent, 20)
        .widthIs(80)
        .heightIs(30);

        [contentScrollView setupAutoContentSizeWithBottomView:mileContent bottomMargin:0];

        
    }
    return self;
}
-(void)setModel:(XFMyOrderModel *)model{
    _model = model;
    
    self.totalMoneyLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.money];
    self.cphLabel2.text = self.model.car_number.length>0?self.model.car_number:@"无";
    self.startPoLabel2.text = self.model.start_address;
    self.endPoLabel2.text = self.model.end_address;
    self.totalTimeLabel2.text = [NSString stringWithFormat:@"%@",self.model.sum_time];
//    self.stopTimeLabel2.text = [NSString stringWithFormat:@"%d分钟",self.model.stop_time];
    self.totalMileLabel2.text = [NSString stringWithFormat:@"%.2fkm",self.model.sumMiles];
    self.startTimeLabel2.text = self.model.start_time;
    self.endTimeLabel2.text = self.model.end_time;

    self.bxMoLabel2.text=self.model.starting.length>0?[NSString stringWithFormat:@"%@元",self.model.starting]:@"0元";
    self.mileMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.cost];
    self.stopMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.stop_cost];
    self.ticketLabel2.text = [NSString stringWithFormat:@"%@元",self.model.coupon];
    self.realPayLabel2.text = [NSString stringWithFormat:@"%@元",self.model.paycoupon];
    self.creditsLabel2.text = [NSString stringWithFormat:@"积分+%d",(int)self.model.paycoupon.integerValue/10];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self endEditing:YES];
}

@end
