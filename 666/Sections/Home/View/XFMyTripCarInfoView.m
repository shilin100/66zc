//
//  XFMyTripCarInfoView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyTripCarInfoView.h"
#import "XFMyOrderModel.h"

@interface XFMyTripCarInfoView ()

@property (nonatomic, weak) UILabel *plateLbl;
@property (nonatomic, weak) UILabel *carNumLbl;
@property (nonatomic, weak) UILabel *colorLbl;
@property (nonatomic, weak) UILabel *typeLbl;
@property (nonatomic, weak) UILabel *priceLbl;


@end




@implementation XFMyTripCarInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        [self setupSubs];
        
    }
    return self;
}
#pragma mark - FUNC
- (void) setupSubs {
    
    UIView *infoContent = [[UIView alloc] init];
    infoContent.backgroundColor = WHITECOLOR;
    infoContent.layer.cornerRadius = 4;
    infoContent.clipsToBounds = YES;
    [self addSubview:infoContent];
    
    [infoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
    UIImageView *bottomBG = [[UIImageView alloc] init];
    bottomBG.image = IMAGENAME(@"dibu");
    bottomBG.contentMode = UIViewContentModeScaleToFill;
    bottomBG.clipsToBounds = YES;
    [infoContent addSubview:bottomBG];
    
    [bottomBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoContent.mas_bottom);
        make.left.equalTo(infoContent.mas_left);
        make.right.equalTo(infoContent.mas_right);
        make.height.mas_equalTo(@(80*SCALE_HEIGHT));
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = IMAGENAME(@"logo");
    icon.contentMode = UIViewContentModeCenter;
    [infoContent addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoContent.mas_top).offset(40*SCALE_HEIGHT);
        make.centerX.equalTo(infoContent.mas_centerX);
        make.height.mas_equalTo(@(96*SCALE_HEIGHT));
        make.width.mas_equalTo(@(112*SCALE_WIDTH));
    }];
    

    UILabel *placeLa1 = [[UILabel alloc] init];
    placeLa1.backgroundColor=[UIColor clearColor];
    [infoContent addSubview:placeLa1];
    [placeLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(52*SCALE_HEIGHT);
        make.left.equalTo(infoContent.mas_left);
    }];
    
    UILabel *plateLbl = [[UILabel alloc] init];
    //    plateLbl.backgroundColor=[UIColor redColor];
    plateLbl.font = XFont(12);
    plateLbl.textColor = HEXCOLOR(@"#999999");
    plateLbl.textAlignment = NSTextAlignmentCenter;
    [infoContent addSubview:plateLbl];
    self.plateLbl = plateLbl;
    [plateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(52*SCALE_HEIGHT);
        make.left.equalTo(placeLa1.mas_right);
        
    }];
    
    UILabel *carNumLbl = [[UILabel alloc] init];
    //    carNumLbl.backgroundColor=[UIColor greenColor];
    carNumLbl.font = XFont(12);
    carNumLbl.textColor = HEXCOLOR(@"#999999");
    carNumLbl.textAlignment = NSTextAlignmentCenter;
    [infoContent addSubview:carNumLbl];
    self.carNumLbl = carNumLbl;
    [carNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plateLbl.mas_top);
        make.left.equalTo(plateLbl.mas_right).offset(5);
    }];
    
    UILabel *colorLbl = [[UILabel alloc] init];
    //    colorLbl.backgroundColor=[UIColor blueColor];
    colorLbl.font = XFont(12);
    colorLbl.textColor = HEXCOLOR(@"#999999");
    colorLbl.textAlignment = NSTextAlignmentCenter;
    [infoContent addSubview:colorLbl];
    self.colorLbl = colorLbl;
    [colorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plateLbl.mas_top);
        make.left.equalTo(carNumLbl.mas_right).offset(5);
        
    }];
    
    UILabel *typeLbl = [[UILabel alloc] init];
    //    typeLbl.backgroundColor=[UIColor redColor];
    typeLbl.font = XFont(12);
    typeLbl.textColor = HEXCOLOR(@"#999999");
    typeLbl.textAlignment = NSTextAlignmentCenter;
    [infoContent addSubview:typeLbl];
    self.typeLbl = typeLbl;
    [typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plateLbl.mas_top);
        make.left.equalTo(colorLbl.mas_right).offset(5);
    }];
    
    UILabel *placeLa2 = [[UILabel alloc] init];
    placeLa2.backgroundColor=[UIColor clearColor];
    [infoContent addSubview:placeLa2];
    [placeLa2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(52*SCALE_HEIGHT);
        make.right.equalTo(infoContent.mas_right);
        make.left.equalTo(typeLbl.mas_right);
        make.width.mas_equalTo(placeLa1.mas_width);
    }];
    
    
    UILabel *priceLbl = [[UILabel alloc] init];
    priceLbl.font = XFont(12);
    priceLbl.textColor = HEXCOLOR(@"#999999");
    priceLbl.textAlignment = NSTextAlignmentCenter;
    [infoContent addSubview:priceLbl];
    self.priceLbl = priceLbl;
    
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plateLbl.mas_bottom).offset(26*SCALE_HEIGHT);
        make.left.equalTo(infoContent.mas_left);
        make.right.equalTo(infoContent.mas_right);
    }];
    
    
}


-(void)setCarModel:(XFMyOrderModel *)carModel{
    
    _carModel = carModel;

    self.plateLbl.text = carModel.brand;
    self.carNumLbl.text = carModel.car_number;

    if([carModel.color isEqualToString:@"1"])
    {
        self.colorLbl.text = @"金色";
    }
    else if ([carModel.color isEqualToString:@"2"])
    {
        self.colorLbl.text = @"灰色";
    }
    else if ([carModel.color isEqualToString:@"3"])
    {
        self.colorLbl.text = @"黑色";
    }
    else if ([carModel.color isEqualToString:@"4"])
    {
        self.colorLbl.text = @"白色";
    }
    else if ([carModel.color isEqualToString:@"5"])
    {
        self.colorLbl.text = @"红色";
    }
    else if ([carModel.color isEqualToString:@"6"])
    {
        self.colorLbl.text = @"银色";
    }
    else if ([carModel.color isEqualToString:@"7"])
    {
        self.colorLbl.text = @"其它";
    }
    else
    {
        self.colorLbl.text = @"无";
    }

    if([carModel.is_oil isEqualToString:@"1"])
    {
        self.typeLbl.text = @"油车";
    }
    else
    {
        self.typeLbl.text = @"电车";
    }
    
    //    时长费0.01元／小时+里程费1.00元／公里
    NSString *str1=carModel.three_h;
    NSString *str2=carModel.km;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时长费%@元／小时+里程费%@元／公里",str1,str2]];
    [attString setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(3, str1.length+1)];
    [attString setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(11+str1.length, str2.length+1)];
    self.priceLbl.attributedText = attString;
}


@end
