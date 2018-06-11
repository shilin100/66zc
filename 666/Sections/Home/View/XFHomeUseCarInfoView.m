//
//  XFHomeUseCarInfoView.m
//  666
//
//  Created by xiaofan on 2017/10/12.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeUseCarInfoView.h"
#import "XFGetCarPriceModel.h"

@interface XFHomeUseCarInfoView ()
@property (nonatomic, weak) UILabel *addLbl;
@property (nonatomic, weak) UILabel *addLblDisabled;

@property (nonatomic, weak) UILabel *plateLbl;
@property (nonatomic, weak) UILabel *carNumLbl;
@property (nonatomic, weak) UILabel *colorLbl;
@property (nonatomic, weak) UILabel *typeLbl;
@property (nonatomic, weak) UILabel *priceLbl;
@property (nonatomic, weak) UIButton *selectHCPointBtnOne;
@property (nonatomic, weak) UIButton *selectServicePointBtnOne;

@property (nonatomic, weak) UILabel *addTitle;
@property (nonatomic, weak) UIView *dot;


@property (nonatomic, assign) BOOL ishideCarNum;


@end

@implementation XFHomeUseCarInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.ishideCarNum = NO;
        [self setupSubs];
        
    }
    
    return self;
}
#pragma mark - FUNC
- (void) setupSubs {
    // 取车地址Content
    UIView *upContent = [[UIView alloc] init];
    upContent.backgroundColor = WHITECOLOR;
    upContent.layer.cornerRadius = 4;
    upContent.clipsToBounds = YES;
    [self addSubview:upContent];
    
    [upContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(@(164*SCALE_HEIGHT));
    }];
    
    UIView *dot = [[UIView alloc] init];
    dot.backgroundColor = MAINGREEN;
    dot.layer.cornerRadius = 11*SCALE_HEIGHT;
    dot.clipsToBounds = YES;
    [upContent addSubview:dot];
    self.dot = dot;
    
    UILabel *addTitle = [[UILabel alloc] init];
    addTitle.text = @"取车点";
    addTitle.font = XFont(12);
    addTitle.textColor = HEXCOLOR(@"#999999");
    [upContent addSubview:addTitle];
    self.addTitle= addTitle;
    
    UILabel *addLbl = [[UILabel alloc] init];
    addLbl.font = XFont(12);
    addLbl.textColor = HEXCOLOR(@"#333333");
    [upContent addSubview:addLbl];
    self.addLbl = addLbl;
    self.addLblDisabled = addLbl;
    
    [dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20*SCALE_WIDTH);
        make.top.mas_equalTo(self.mas_top).offset(30*SCALE_WIDTH);
        make.size.mas_equalTo(CGSizeMake(22*SCALE_HEIGHT, 22*SCALE_HEIGHT));
        
    }];
    
    [addTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dot.mas_right).offset(15*SCALE_WIDTH);
        make.centerY.equalTo(dot.mas_centerY);
        make.width.mas_equalTo(@(72*SCALE_WIDTH));
    }];
    
    [addLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addTitle.mas_right).offset(20*SCALE_WIDTH);
        make.centerY.equalTo(addTitle.mas_centerY);
        make.right.equalTo(upContent.mas_right);
    }];
    
    //查看还车点和服务网点
    UIButton *selectHCPointBtnOne = [[UIButton alloc] init];
    [selectHCPointBtnOne setImage:IMAGENAME(@"tc_dingwei") forState:UIControlStateNormal];
    selectHCPointBtnOne.adjustsImageWhenHighlighted=NO;
    [upContent addSubview:selectHCPointBtnOne];

    
    [[selectHCPointBtnOne rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(XFHomeUseCarInfoView:didClickHCPBtn:)]) {
            [self.delegate XFHomeUseCarInfoView:self didClickHCPBtn:selectHCPointBtnOne];
        }
    }];
    self.selectHCPointBtnOne = selectHCPointBtnOne;
    [selectHCPointBtnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(50*SCALE_WIDTH);
        make.top.mas_equalTo(dot.mas_bottom).offset(60*SCALE_WIDTH);
        make.size.mas_equalTo(CGSizeMake(22*SCALE_HEIGHT, 22*SCALE_HEIGHT));
        
    }];
    
//    UIButton *selectHCPointBtnTwo = [[UIButton alloc] init];
//    [selectHCPointBtnTwo setTitle:@"查看还车点" forState:UIControlStateNormal];
//    [selectHCPointBtnTwo setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//    selectHCPointBtnTwo.titleLabel.font=XFont(12);
//    [upContent addSubview:selectHCPointBtnTwo];
//
//    [[selectHCPointBtnTwo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(XFHomeUseCarInfoView:didClickHCPBtn:)]) {
//            [self.delegate XFHomeUseCarInfoView:self didClickHCPBtn:selectHCPointBtnTwo];
//        }
//    }];
//    self.selectHCPointBtnTwo = selectHCPointBtnTwo;
//    [selectHCPointBtnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
//
//       make.left.equalTo(selectHCPointBtnOne.mas_right).offset(5*SCALE_WIDTH);
//        make.centerY.equalTo(selectHCPointBtnOne.mas_centerY);
//        make.width.mas_equalTo(@(160*SCALE_WIDTH));
//
//    }];
    
    
    UIButton *selectServicePointBtnTwo = [[UIButton alloc] init];
    [selectServicePointBtnTwo setTitle:@"查看服务网点" forState:UIControlStateNormal];
    [selectServicePointBtnTwo setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    selectServicePointBtnTwo.titleLabel.font=XFont(12);
    [upContent addSubview:selectServicePointBtnTwo];
    
    [[selectServicePointBtnTwo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(XFHomeUseCarInfoView:didClickServicePBtn:)]) {
            [self.delegate XFHomeUseCarInfoView:self didClickServicePBtn:selectServicePointBtnTwo];
        }
    }];
    self.selectServicePointBtnTwo = selectServicePointBtnTwo;
    [selectServicePointBtnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-50*SCALE_WIDTH);
        make.centerY.equalTo(selectHCPointBtnOne.mas_centerY);
//        make.width.mas_equalTo(@(160*SCALE_WIDTH));
        make.left.mas_equalTo(self.mas_left).offset(50*SCALE_WIDTH);
        
        
    }];
    
//    UIButton *selectServicePointBtnOne = [[UIButton alloc] init];
//    [selectServicePointBtnOne setImage:IMAGENAME(@"tc_dingwei") forState:UIControlStateNormal];
//    selectServicePointBtnOne.adjustsImageWhenHighlighted=NO;
//    [upContent addSubview:selectServicePointBtnOne];
//    
//    [[selectServicePointBtnOne rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(XFHomeUseCarInfoView:didClickServicePBtn:)]) {
//            [self.delegate XFHomeUseCarInfoView:self didClickServicePBtn:selectServicePointBtnOne];
//        }
//    }];
//    self.selectServicePointBtnOne = selectServicePointBtnOne;
//    [selectServicePointBtnOne mas_makeConstraints:^(MASConstraintMaker *make) {
//        
// make.right.equalTo(selectServicePointBtnTwo.mas_left).offset(-5*SCALE_WIDTH);
//        make.centerY.equalTo(selectHCPointBtnOne.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(22*SCALE_HEIGHT, 22*SCALE_HEIGHT));
//        
//    }];
//    
    
    
    UIView *infoContent = [[UIView alloc] init];
    infoContent.backgroundColor = WHITECOLOR;
    infoContent.layer.cornerRadius = 4;
    infoContent.clipsToBounds = YES;
    [self addSubview:infoContent];
    
    [infoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upContent.mas_bottom).offset(10*SCALE_HEIGHT);
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
    
//    NSMutableArray *arr=[NSMutableArray arrayWithObjects:plateLbl,carNumLbl,colorLbl,typeLbl, nil];
//    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:20 tailSpacing:20];
//    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(icon.mas_bottom).offset(52*SCALE_HEIGHT);
//
//    }];
    
    
    
//    UILabel *priceLbl = [[UILabel alloc] init];
//    priceLbl.font = XFont(12);
//    priceLbl.textColor = HEXCOLOR(@"#999999");
//    priceLbl.textAlignment = NSTextAlignmentCenter;
//    [infoContent addSubview:priceLbl];
//    self.priceLbl = priceLbl;
//
//    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(plateLbl.mas_bottom).offset(16*SCALE_HEIGHT);
//        make.left.equalTo(infoContent.mas_left);
//        make.right.equalTo(infoContent.mas_right);
//    }];
    
    NSString * oneStr = @"车辆计费规则详情";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",oneStr]];
    //在某个范围内增加下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:MAINGREEN  range:NSMakeRange(0, [str length])];

    
    UIButton *costDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [costDetailBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    costDetailBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    costDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [costDetailBtn setAttributedTitle:str forState:UIControlStateNormal];

    costDetailBtn.titleLabel.font = XFont(14);
    [infoContent addSubview:costDetailBtn];
    self.costDetailBtn = costDetailBtn;
    [costDetailBtn addTarget:self action:@selector(costDetailBtnAction) forControlEvents:UIControlEventTouchUpInside];

    [costDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plateLbl.mas_bottom).offset(16*SCALE_HEIGHT);
        make.left.equalTo(infoContent.mas_left);
        make.right.equalTo(infoContent.mas_right);
    }];

    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [submitBtn setTitle:@"立即用车" forState:UIControlStateNormal];
    submitBtn.backgroundColor = MAINGREEN;
    submitBtn.titleLabel.font = XFont(14);
    submitBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    submitBtn.clipsToBounds = YES;
    [infoContent addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoContent.mas_bottom).offset(-52*SCALE_HEIGHT);
        make.left.equalTo(infoContent.mas_left).offset(40*SCALE_WIDTH);
        make.right.equalTo(infoContent.mas_right).offset(-40*SCALE_WIDTH);
        make.height.mas_equalTo(@(80*SCALE_HEIGHT));
    }];
}
- (void) submitBtnClick {
    if (self.submitBlock) {
        self.submitBlock();
    }
}

-(void)costDetailBtnAction{
    if (self.costDetailBlock) {
        self.costDetailBlock();
    }

}

-(void)setCarPriceModel:(XFGetCarPriceModel *)carPriceModel{
    _carPriceModel = carPriceModel;
    
    
    self.plateLbl.text = carPriceModel.brand;
    self.carNumLbl.text = _ishideCarNum ? @"鄂A******" : carPriceModel.car_number;
    self.colorLbl.text = carPriceModel.color;

    if([carPriceModel.is_oil isEqualToString:@"1"])
    {
        self.typeLbl.text = @"油车";
    }
    else
    {
        self.typeLbl.text = @"电车";
    }
//    时长费0.01元／小时+里程费1.00元／公里
    NSString *str1=carPriceModel.three_h;
    NSString *str2=carPriceModel.km;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时长费%@元／小时+里程费%@元／公里",str1,str2]];
    [attString setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(3, str1.length+1)];
    [attString setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(11+str1.length, str2.length+1)];
    self.priceLbl.attributedText = attString;

}
- (void)setAddress:(NSString *)address{
    _address = address;
    
    self.addLbl.text = address;
}

-(void)setSubMitBtnDisable:(BOOL)ishideCarNum{
//    self.submitBtn.userInteractionEnabled = NO;
//    self.submitBtn.backgroundColor = GRAYCOLOR;
    self.dot.backgroundColor = WHITECOLOR;
    self.dot.layer.cornerRadius = 0;
    self.dot.clipsToBounds = NO;
    
//    UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trishi"]];
//    img.contentMode = UIViewContentModeScaleAspectFit;
//    [self.dot addSubview:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    self.addTitle.text = @"";
    self.addTitle.textColor = BLACKCOLOR;
    self.addLbl.text = @"⚠️ 提示:车辆使用中，请选其他车辆进行预约";
    self.addLbl.textColor = BLACKCOLOR;
    [self.addLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        
    }];
    self.addLbl.textAlignment = NSTextAlignmentCenter;
    self.addLbl = nil;
    
    [self.submitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
    if (ishideCarNum) {
        self.ishideCarNum = YES;
    }else{
        self.ishideCarNum = NO;
    }
}

@end
