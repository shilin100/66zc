//
//  XFGiveCarServiceDetailView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceDetailView.h"
#import "XFGiveCarServiceModel.h"

@interface XFGiveCarServiceDetailView() <UIScrollViewDelegate>

@end

@implementation XFGiveCarServiceDetailView

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
        
        //选择地区
        UIView *areaContent = [[UIView alloc] init];
        areaContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:areaContent];
        areaContent.sd_layout
        .topEqualToView(contentScrollView)
        .leftEqualToView(contentScrollView)
        .heightIs(120)
        .rightEqualToView(contentScrollView);
        
        UILabel *areaLabel1 = [[UILabel alloc] init];
        areaLabel1.text = @"选择地区";
        areaLabel1.textAlignment=NSTextAlignmentLeft;
        areaLabel1.font = XFont(14);
        areaLabel1.textColor = HEXCOLOR(@"999999");
        [areaContent addSubview:areaLabel1];
        areaLabel1.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *areaLabel2 = [[UILabel alloc] init];
//        areaLabel2.text = @"武汉市洪山区";
        areaLabel2.textAlignment=NSTextAlignmentRight;
        areaLabel2.font = XFont(14);
        [areaContent addSubview:areaLabel2];
        self.areaLabel2=areaLabel2;
        areaLabel2.sd_layout
        .topEqualToView(areaContent)
        .rightSpaceToView(areaContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        UILabel *addressLabel1 = [[UILabel alloc] init];
        addressLabel1.text = @"取车地址";
        addressLabel1.textAlignment=NSTextAlignmentLeft;
        addressLabel1.font = XFont(14);
        addressLabel1.textColor = HEXCOLOR(@"999999");
        [areaContent addSubview:addressLabel1];
        addressLabel1.sd_layout
        .topSpaceToView(areaLabel1, 0)
        .leftSpaceToView(areaContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *addressLabel2 = [[UILabel alloc] init];
//        addressLabel2.text = @"光谷广场资本大厦";
        addressLabel2.textAlignment=NSTextAlignmentRight;
        addressLabel2.font = XFont(14);
        [areaContent addSubview:addressLabel2];
        self.addressLabel2=addressLabel2;
        addressLabel2.sd_layout
        .topSpaceToView(areaLabel2, 0)
        .rightSpaceToView(areaContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        UILabel *carTypeLabel1 = [[UILabel alloc] init];
        carTypeLabel1.text = @"期望车型";
        carTypeLabel1.textAlignment=NSTextAlignmentLeft;
        carTypeLabel1.font = XFont(14);
        carTypeLabel1.textColor = HEXCOLOR(@"999999");
        [areaContent addSubview:carTypeLabel1];
        carTypeLabel1.sd_layout
        .topSpaceToView(addressLabel1, 0)
        .leftSpaceToView(areaContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *carTypeLabel2 = [[UILabel alloc] init];
//        carTypeLabel2.text = @"宝马";
        carTypeLabel2.textAlignment=NSTextAlignmentRight;
        carTypeLabel2.font = XFont(14);
        [areaContent addSubview:carTypeLabel2];
        self.carTypeLabel2=carTypeLabel2;
        carTypeLabel2.sd_layout
        .topSpaceToView(addressLabel2, 0)
        .rightSpaceToView(areaContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        UILabel *timeLabel1 = [[UILabel alloc] init];
        timeLabel1.text = @"用车时间";
        timeLabel1.textAlignment=NSTextAlignmentLeft;
        timeLabel1.font = XFont(14);
        timeLabel1.textColor = HEXCOLOR(@"999999");
        [areaContent addSubview:timeLabel1];
        timeLabel1.sd_layout
        .topSpaceToView(carTypeLabel1, 0)
        .leftSpaceToView(areaContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *timeLabel2 = [[UILabel alloc] init];
//        timeLabel2.text = @"2017.11.02 12:12";
        timeLabel2.textAlignment=NSTextAlignmentRight;
        timeLabel2.font = XFont(14);
        [areaContent addSubview:timeLabel2];
        self.timeLabel2=timeLabel2;
        timeLabel2.sd_layout
        .topSpaceToView(carTypeLabel2, 0)
        .rightSpaceToView(areaContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        
        //联系人
        UIView *peopleContent = [[UIView alloc] init];
        peopleContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:peopleContent];
        peopleContent.sd_layout
        .topSpaceToView(areaContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(60)
        .rightEqualToView(contentScrollView);
        
        UILabel *peopleLabel1 = [[UILabel alloc] init];
        peopleLabel1.text = @"联系人";
        peopleLabel1.textAlignment=NSTextAlignmentLeft;
        peopleLabel1.font = XFont(14);
        peopleLabel1.textColor = HEXCOLOR(@"999999");
        [peopleContent addSubview:peopleLabel1];
        peopleLabel1.sd_layout
        .topEqualToView(peopleContent)
        .leftSpaceToView(peopleContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *peopleLabel2 = [[UILabel alloc] init];
//        peopleLabel2.text = @"张三李四";
        peopleLabel2.textAlignment=NSTextAlignmentRight;
        peopleLabel2.font = XFont(14);
        [peopleContent addSubview:peopleLabel2];
        self.peopleLabel2=peopleLabel2;
        peopleLabel2.sd_layout
        .topEqualToView(peopleContent)
        .rightSpaceToView(peopleContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        UILabel *phoneLabel1 = [[UILabel alloc] init];
        phoneLabel1.text = @"联系电话";
        phoneLabel1.textAlignment=NSTextAlignmentLeft;
        phoneLabel1.font = XFont(14);
        phoneLabel1.textColor = HEXCOLOR(@"999999");
        [peopleContent addSubview:phoneLabel1];
        phoneLabel1.sd_layout
        .topSpaceToView(peopleLabel1, 0)
        .leftSpaceToView(peopleContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *phoneLabel2 = [[UILabel alloc] init];
//        phoneLabel2.text = @"15112455214";
        phoneLabel2.textAlignment=NSTextAlignmentRight;
        phoneLabel2.font = XFont(14);
        [peopleContent addSubview:phoneLabel2];
        self.phoneLabel2=phoneLabel2;
        phoneLabel2.sd_layout
        .topSpaceToView(peopleLabel2, 0)
        .rightSpaceToView(peopleContent, 10)
        .widthIs(180)
        .heightIs(30);
        
       
        //定金
        UIView *moneyContent = [[UIView alloc] init];
        moneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:moneyContent];
        moneyContent.sd_layout
        .topSpaceToView(peopleContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(60)
        .rightEqualToView(contentScrollView);
        
        UILabel *djLabel1 = [[UILabel alloc] init];
        djLabel1.text = @"定金";
        djLabel1.textAlignment=NSTextAlignmentLeft;
        djLabel1.font = XFont(14);
        djLabel1.textColor = HEXCOLOR(@"999999");
        [moneyContent addSubview:djLabel1];
        djLabel1.sd_layout
        .topEqualToView(moneyContent)
        .leftSpaceToView(moneyContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *djLabel2 = [[UILabel alloc] init];
//        djLabel2.text = @"￥30.00";
        djLabel2.textAlignment=NSTextAlignmentRight;
        djLabel2.font = XFont(14);
        [moneyContent addSubview:djLabel2];
        self.djLabel2=djLabel2;
        djLabel2.sd_layout
        .topEqualToView(moneyContent)
        .rightSpaceToView(moneyContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        UILabel *syMoneyLabel1 = [[UILabel alloc] init];
        syMoneyLabel1.text = @"剩余金额";
        syMoneyLabel1.textAlignment=NSTextAlignmentLeft;
        syMoneyLabel1.font = XFont(14);
        syMoneyLabel1.textColor = HEXCOLOR(@"999999");
        [moneyContent addSubview:syMoneyLabel1];
        syMoneyLabel1.sd_layout
        .topSpaceToView(djLabel1, 0)
        .leftSpaceToView(moneyContent, 10)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *syMoneyLabel2 = [[UILabel alloc] init];
//        syMoneyLabel2.text = @"￥20.00";
        syMoneyLabel2.textColor=REDCOLOR;
        syMoneyLabel2.textAlignment=NSTextAlignmentRight;
        syMoneyLabel2.font = XFont(14);
        [moneyContent addSubview:syMoneyLabel2];
        self.syMoneyLabel2=syMoneyLabel2;
        syMoneyLabel2.sd_layout
        .topSpaceToView(djLabel2, 0)
        .rightSpaceToView(moneyContent, 10)
        .widthIs(180)
        .heightIs(30);
        
        
    }
    return self;
}

-(void)setModel:(XFGiveCarServiceModel *)model
{
    _model=model;
    self.areaLabel2.text = self.model.area;
    self.addressLabel2.text = self.model.address;
    self.carTypeLabel2.text = self.model.hope_car;
    self.timeLabel2.text = self.model.use_time;
    self.peopleLabel2.text = self.model.name;
    self.phoneLabel2.text = self.model.tel;
    self.djLabel2.text = [NSString stringWithFormat:@"￥%@",self.model.pay_money];
    self.syMoneyLabel2.text = [NSString stringWithFormat:@"￥%@",self.model.get_money];


}

@end
