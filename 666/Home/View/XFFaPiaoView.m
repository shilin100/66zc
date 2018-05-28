//
//  XFFaPiaoView.m
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFFaPiaoView.h"

@interface XFFaPiaoView() <UIScrollViewDelegate>


@end

@implementation XFFaPiaoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // bgview
        UIImageView *bgImv = [[UIImageView alloc] init];
        bgImv.image=IMAGENAME(@"beijing");
        bgImv.contentMode=UIViewContentModeScaleAspectFill;
        bgImv.clipsToBounds=YES;
        [self addSubview:bgImv];
        bgImv.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        UIView *view1=[[UIView alloc] init];
        view1.backgroundColor=CLEARCOLOR;
        [bgImv addSubview:view1];
        view1.sd_layout
        .centerYEqualToView(bgImv)
        .leftEqualToView(self)
        .widthIs(SCREENW/3)
        .heightIs(50);
        
        UILabel *yjMoneyLabel2 = [[UILabel alloc] init];
        yjMoneyLabel2.text = @"800";
        yjMoneyLabel2.textAlignment=NSTextAlignmentCenter;
        yjMoneyLabel2.font = XFont(18.5);
        yjMoneyLabel2.textColor = WHITECOLOR;
        [view1 addSubview:yjMoneyLabel2];
        self.yjMoneyLabel2=yjMoneyLabel2;
        yjMoneyLabel2.sd_layout
        .topSpaceToView(view1, 0)
        .rightEqualToView(view1)
        .leftEqualToView(view1)
        .heightIs(25);
        
        UILabel *yjMoneyLabel1 = [[UILabel alloc] init];
        yjMoneyLabel1.text = @"消费总额";
        yjMoneyLabel1.textAlignment=NSTextAlignmentCenter;
        yjMoneyLabel1.font = XFont(12);
        yjMoneyLabel1.textColor = WHITECOLOR;
        [view1 addSubview:yjMoneyLabel1];
        yjMoneyLabel1.sd_layout
        .topSpaceToView(yjMoneyLabel2, 0)
        .rightEqualToView(view1)
        .leftEqualToView(view1)
        .heightIs(25);
        
        UIView *line1=[[UIView alloc] init];
        line1.backgroundColor=WHITECOLOR;
        [bgImv addSubview:line1];
        line1.sd_layout
        .centerYEqualToView(bgImv)
        .leftSpaceToView(view1, 0)
        .widthIs(1)
        .heightIs(30);
        
        UIView *view2=[[UIView alloc] init];
        view2.backgroundColor=CLEARCOLOR;
        [bgImv addSubview:view2];
        view2.sd_layout
        .centerYEqualToView(bgImv)
        .leftSpaceToView(line1, 0)
        .widthIs(view1.width)
        .heightIs(50);

        UILabel *ykMoneyLabel2 = [[UILabel alloc] init];
        ykMoneyLabel2.text = @"300";
        ykMoneyLabel2.textAlignment=NSTextAlignmentCenter;
        ykMoneyLabel2.font = XFont(18.5);
        ykMoneyLabel2.textColor = WHITECOLOR;
        [view2 addSubview:ykMoneyLabel2];
        self.ykMoneyLabel2=ykMoneyLabel2;
        ykMoneyLabel2.sd_layout
        .topSpaceToView(view2, 0)
        .rightEqualToView(view2)
        .leftEqualToView(view2)
        .heightIs(25);

        UILabel *ykMoneyLabel1 = [[UILabel alloc] init];
        ykMoneyLabel1.text = @"已开金额";
        ykMoneyLabel1.textAlignment=NSTextAlignmentCenter;
        ykMoneyLabel1.font = XFont(12);
        ykMoneyLabel1.textColor = WHITECOLOR;
        [view2 addSubview:ykMoneyLabel1];
        ykMoneyLabel1.sd_layout
        .topSpaceToView(ykMoneyLabel2, 0)
        .rightEqualToView(view2)
        .leftEqualToView(view2)
        .heightIs(25);

        UIView *line2=[[UIView alloc] init];
        line2.backgroundColor=WHITECOLOR;
        [bgImv addSubview:line2];
        line2.sd_layout
        .centerYEqualToView(bgImv)
        .leftSpaceToView(view2, 0)
        .widthIs(1)
        .heightIs(30);
        
        UIView *view3=[[UIView alloc] init];
        view3.backgroundColor=CLEARCOLOR;
        [bgImv addSubview:view3];
        view3.sd_layout
        .centerYEqualToView(bgImv)
        .leftSpaceToView(line2, 0)
        .widthIs(view2.width)
        .heightIs(50);
        
        UILabel *syMoneyLabel2 = [[UILabel alloc] init];
        syMoneyLabel2.text = @"500";
        syMoneyLabel2.textAlignment=NSTextAlignmentCenter;
        syMoneyLabel2.font = XFont(18.5);
        syMoneyLabel2.textColor = WHITECOLOR;
        [view3 addSubview:syMoneyLabel2];
        self.syMoneyLabel2=syMoneyLabel2;
        syMoneyLabel2.sd_layout
        .topSpaceToView(view3, 0)
        .rightEqualToView(view3)
        .leftEqualToView(view3)
        .heightIs(25);
        
        UILabel *syMoneyLabel1 = [[UILabel alloc] init];
        syMoneyLabel1.text = @"剩余金额";
        syMoneyLabel1.textAlignment=NSTextAlignmentCenter;
        syMoneyLabel1.font = XFont(12);
        syMoneyLabel1.textColor = WHITECOLOR;
        [view3 addSubview:syMoneyLabel1];
        syMoneyLabel1.sd_layout
        .topSpaceToView(syMoneyLabel2, 0)
        .rightEqualToView(view3)
        .leftEqualToView(view3)
        .heightIs(25);
    
        
    }
    return self;
}









//-(void)setModel:(XFMyOrderModel *)model{
//    _model = model;
//
//    self.totalMoneyLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.money];
//    self.startPoLabel2.text = self.model.start_address;
//    self.endPoLabel2.text = self.model.end_address;
//    self.totalTimeLabel2.text = [NSString stringWithFormat:@"%d分钟",self.model.sum_time];
//    self.stopTimeLabel2.text = [NSString stringWithFormat:@"%d分钟",self.model.stop_time];
//    self.totalMileLabel2.text = [NSString stringWithFormat:@"%.2fkm",self.model.sumMiles];
//    self.bxMoLabel2.text=[NSString stringWithFormat:@"%@元",self.model.starting];
//    self.mileMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.cost];
//    self.stopMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.stop_cost];
//    self.ticketLabel2.text = [NSString stringWithFormat:@"-%@元",self.model.coupon];
//
//}

@end
        
        
        
        
        
        
        
        
        
