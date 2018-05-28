//
//  XFGiveCarServiceYCView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceYCView.h"
#import <IQKeyboardManager.h>

@interface XFGiveCarServiceYCView() <UIScrollViewDelegate,UITextFieldDelegate>

@end

@implementation XFGiveCarServiceYCView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // scrollView
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

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
        .heightIs(40)
        .rightEqualToView(contentScrollView);
        
        
        UILabel *areaTitle = [[UILabel alloc] init];
        areaTitle.font = XFont(14);
//        areaTitle.textColor = HEXCOLOR(@"999999");
        areaTitle.textColor = BLACKCOLOR;
        areaTitle.text = @"选择地区";
        [areaContent addSubview:areaTitle];
        areaTitle.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaContent, 10)
        .bottomEqualToView(areaContent)
        .widthIs(60);

        UIImageView *areaArrow = [[UIImageView alloc] init];
        areaArrow.image = IMAGENAME(@"arrow_right");
        areaArrow.contentMode = UIViewContentModeCenter;
        [areaContent addSubview:areaArrow];

        areaArrow.sd_layout
        .topEqualToView(areaContent)
        .rightEqualToView(areaContent)
        .bottomEqualToView(areaContent)
        .widthIs(56*SCALE_WIDTH);

        UILabel *areaLbl = [[UILabel alloc] init];
        areaLbl.font = XFont(14);
        areaLbl.textColor = RGBCOLORe(51);
        areaLbl.text = @"请选择区域";
        [areaContent addSubview:areaLbl];
        self.areaLbl = areaLbl;
        areaLbl.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(areaContent)
        .rightSpaceToView(areaArrow, 0);

        UIButton *areaBtn = [[UIButton alloc] init];
        areaBtn.backgroundColor = CLEARCOLOR;
        [areaContent addSubview:areaBtn];
        self.areaBtn = areaBtn;
        [[areaBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"选择地区");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFGiveCarServiceYCView:didClickAreaBtn:)]) {
                [self.delegate XFGiveCarServiceYCView:self didClickAreaBtn:areaBtn];
            }
        

        }];
        areaBtn.sd_layout
        .topEqualToView(areaContent)
        .leftEqualToView(areaLbl)
        .bottomEqualToView(areaContent)
        .rightEqualToView(areaContent);


        // 取车地址
        UIView *addressContent = [[UIView alloc] init];
        addressContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:addressContent];
        addressContent.sd_layout
        .topSpaceToView(areaContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(40)
        .rightEqualToView(contentScrollView);

        UILabel *addressTitle = [[UILabel alloc] init];
        addressTitle.font = XFont(14);
        addressTitle.textColor = BLACKCOLOR;
        addressTitle.text = @"取车地址";
        [addressContent addSubview:addressTitle];
        addressTitle.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressContent, 10)
        .bottomEqualToView(addressContent)
        .widthIs(60);
    

        UITextField *addressTF = [[UITextField alloc] init];
        addressTF.delegate=self;
        addressTF.font = XFont(14);
        addressTF.textColor = RGBCOLORe(51);
        addressTF.placeholder = @"请填写取车详细地址";
        [addressContent addSubview:addressTF];
        self.addressTF = addressTF;
        addressTF.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(addressContent)
        .rightEqualToView(addressContent);

        // 期望车型
        UIView *carTypeContent = [[UIView alloc] init];
        carTypeContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:carTypeContent];
        carTypeContent.sd_layout
        .topSpaceToView(addressContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(40)
        .rightEqualToView(contentScrollView);
        
        UILabel *carTypeTitle = [[UILabel alloc] init];
        carTypeTitle.font = XFont(14);
        carTypeTitle.textColor = BLACKCOLOR;
        carTypeTitle.text = @"期望车型";
        [carTypeContent addSubview:carTypeTitle];
        carTypeTitle.sd_layout
        .topEqualToView(carTypeContent)
        .leftSpaceToView(carTypeContent, 10)
        .bottomEqualToView(carTypeContent)
        .widthIs(60);
        
        UIImageView *carTypeArrow = [[UIImageView alloc] init];
        carTypeArrow.image = IMAGENAME(@"arrow_right");
        carTypeArrow.contentMode = UIViewContentModeCenter;
        [carTypeContent addSubview:carTypeArrow];
        
        carTypeArrow.sd_layout
        .topEqualToView(carTypeContent)
        .rightEqualToView(carTypeContent)
        .bottomEqualToView(carTypeContent)
        .widthIs(56*SCALE_WIDTH);
        
        UILabel *carTypeLbl = [[UILabel alloc] init];
        carTypeLbl.font = XFont(14);
        carTypeLbl.textColor = RGBCOLORe(51);
        carTypeLbl.text = @"请选择车型";
        [carTypeContent addSubview:carTypeLbl];
        self.carTypeLbl = carTypeLbl;
        carTypeLbl.sd_layout
        .topEqualToView(carTypeContent)
        .leftSpaceToView(carTypeTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(carTypeContent)
        .rightSpaceToView(carTypeArrow, 0);

        UIButton *carBrandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        carBrandBtn.backgroundColor = CLEARCOLOR;
        [carTypeContent addSubview:carBrandBtn];
        self.carBrandBtn = carBrandBtn;
        [[carBrandBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"选择地区");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFGiveCarServiceYCView:didClickCarBrandBtn:)]) {
                [self.delegate XFGiveCarServiceYCView:self didClickCarBrandBtn:carBrandBtn];
            }
            
            
        }];
        carBrandBtn.sd_layout
        .topEqualToView(carTypeContent)
        .leftSpaceToView(carTypeTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(carTypeContent)
        .rightEqualToView(carTypeContent);

        
//        UITextField *carTypeTF = [[UITextField alloc] init];
//        carTypeTF.delegate=self;
//        carTypeTF.font = XFont(14);
//        carTypeTF.textColor = RGBCOLORe(51);
//        carTypeTF.placeholder = @"请填写您期望的车型";
//        [carTypeContent addSubview:carTypeTF];
//        self.carTypeTF = carTypeTF;
//        carTypeTF.sd_layout
//        .topEqualToView(carTypeContent)
//        .leftSpaceToView(carTypeTitle, 44*SCALE_WIDTH)
//        .bottomEqualToView(carTypeContent)
//        .rightEqualToView(carTypeContent);
        
        
        //时间
        UIView *timeContent = [[UIView alloc] init];
        timeContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:timeContent];
        timeContent.sd_layout
        .topSpaceToView(carTypeContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(40)
        .rightEqualToView(contentScrollView);
        
        
        UILabel *timeTitle = [[UILabel alloc] init];
        timeTitle.font = XFont(14);
        timeTitle.textColor = BLACKCOLOR;
        timeTitle.text = @"用车时间";
        [timeContent addSubview:timeTitle];
        timeTitle.sd_layout
        .topEqualToView(timeContent)
        .leftSpaceToView(timeContent, 10)
        .bottomEqualToView(timeContent)
        .widthIs(60);
        
        UIImageView *timeArrow = [[UIImageView alloc] init];
        timeArrow.image = IMAGENAME(@"arrow_right");
        timeArrow.contentMode = UIViewContentModeCenter;
        [timeContent addSubview:timeArrow];
        
        timeArrow.sd_layout
        .topEqualToView(timeContent)
        .rightEqualToView(timeContent)
        .bottomEqualToView(timeContent)
        .widthIs(56*SCALE_WIDTH);
        
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.font = XFont(14);
        timeLbl.textColor = RGBCOLORe(51);
        timeLbl.text = @"请选择用车时间";
        [timeContent addSubview:timeLbl];
        self.timeLbl = timeLbl;
        timeLbl.sd_layout
        .topEqualToView(timeContent)
        .leftSpaceToView(timeTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(timeContent)
        .rightSpaceToView(timeArrow, 0);
        
        UIButton *timeBtn = [[UIButton alloc] init];
        timeBtn.backgroundColor = CLEARCOLOR;
        [timeContent addSubview:timeBtn];
        self.timeBtn = timeBtn;
        [[timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"选择时间");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFGiveCarServiceYCView:didClickTimeBtn:)]) {
                [self.delegate XFGiveCarServiceYCView:self didClickTimeBtn:timeBtn];
            }
            
            
        }];
        timeBtn.sd_layout
        .topEqualToView(timeContent)
        .leftEqualToView(timeLbl)
        .bottomEqualToView(timeContent)
        .rightEqualToView(timeContent);
        
        
        //联系人
        UIView *peopleContent = [[UIView alloc] init];
        peopleContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:peopleContent];
        peopleContent.sd_layout
        .topSpaceToView(timeContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(40)
        .rightEqualToView(contentScrollView);
        
        UILabel *peopleLabel1 = [[UILabel alloc] init];
        peopleLabel1.text = @"联系人";
        peopleLabel1.textAlignment=NSTextAlignmentLeft;
        peopleLabel1.font = XFont(14);
        peopleLabel1.textColor = BLACKCOLOR;
        [peopleContent addSubview:peopleLabel1];
        peopleLabel1.sd_layout
        .topEqualToView(peopleContent)
        .bottomEqualToView(peopleContent)
        .leftSpaceToView(peopleContent, 10)
        .widthIs(60);
        
        
        UITextField *peopleTF = [[UITextField alloc] init];
        peopleTF.delegate=self;
        peopleTF.font = XFont(14);
        peopleTF.textColor = RGBCOLORe(51);
        peopleTF.placeholder = @"请填写联系人姓名";
        [peopleContent addSubview:peopleTF];
        self.peopleTF = peopleTF;
        peopleTF.sd_layout
        .topEqualToView(peopleContent)
        .bottomEqualToView(peopleContent)
        .leftSpaceToView(peopleLabel1, 44*SCALE_WIDTH)
        .widthIs(150);
        
        
        //联系电话
        UIView *phoneContent = [[UIView alloc] init];
        phoneContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:phoneContent];
        phoneContent.sd_layout
        .topSpaceToView(peopleContent, 5)
        .leftEqualToView(contentScrollView)
        .heightIs(40)
        .rightEqualToView(contentScrollView);
        
        UILabel *phoneLabel1 = [[UILabel alloc] init];
        phoneLabel1.text = @"联系电话";
        phoneLabel1.textAlignment=NSTextAlignmentLeft;
        phoneLabel1.font = XFont(14);
        phoneLabel1.textColor = BLACKCOLOR;
        [phoneContent addSubview:phoneLabel1];
        phoneLabel1.sd_layout
        .topEqualToView(phoneContent)
        .bottomEqualToView(phoneContent)
        .leftSpaceToView(phoneContent, 10)
        .widthIs(60);
        
        
        UITextField *phoneTF = [[UITextField alloc] init];
        phoneTF.delegate=self;
        phoneTF.font = XFont(14);
        phoneTF.textColor = RGBCOLORe(51);
        phoneTF.placeholder = @"请填写联系人手机号";
        [phoneContent addSubview:phoneTF];
        self.phoneTF = phoneTF;
        phoneTF.sd_layout
        .topEqualToView(phoneContent)
        .bottomEqualToView(phoneContent)
        .leftSpaceToView(phoneLabel1, 44*SCALE_WIDTH)
        .widthIs(150);
        
        
        
        UIButton *commitBtn = [[UIButton alloc] init];
        commitBtn.backgroundColor=MAINGREEN;
        commitBtn.layer.cornerRadius=20;
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        commitBtn.titleLabel.font=XFont(14);
        [contentScrollView addSubview:commitBtn];
        self.commitBtn=commitBtn;
        [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"提交");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFGiveCarServiceYCView:didClickCommitBtn:)]) {
                [self.delegate XFGiveCarServiceYCView:self didClickCommitBtn:commitBtn];
            }
            
        }];
        
        commitBtn.sd_layout
        .centerXEqualToView(contentScrollView)
        .topSpaceToView(phoneContent, 60)
        .widthIs(270)
        .heightIs(40);
 
        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
