//
//  XFUserInfoScroolView.m
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUserInfoScroolView.h"
#import "UILabel+XFExtension.h"
#import "XFUserInfoModel.h"
#import "XFRecommendIconViewController.h"

@interface XFUserInfoScroolView() <UIScrollViewDelegate,UITextFieldDelegate>
/***/
@property (nonatomic, weak) UIButton *sexSelectedBtn;
@end

@implementation XFUserInfoScroolView

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
        
        // 头像
        UIView *iconContent = [[UIView alloc] init];
        iconContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:iconContent];
        iconContent.sd_layout
        .topEqualToView(contentScrollView)
        .leftEqualToView(contentScrollView)
        .heightIs(120*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *iconTitle = [[UILabel alloc] init];
        iconTitle.text = @"头像";
        iconTitle.font = XFont(13);
        iconTitle.textColor = HEXCOLOR(@"333333");
        [iconContent addSubview:iconTitle];
         iconTitle.sd_layout
        .topEqualToView(iconContent)
        .leftSpaceToView(iconContent, 20*SCALE_WIDTH)
        .bottomEqualToView(iconContent)
        .widthIs(100*SCALE_WIDTH);
        [iconTitle changeAlignmentRightandLeft];
        
        UIButton *iconBtn = [[UIButton alloc] init];
        [iconBtn setBackgroundImage:IMAGENAME(@"morentouxiang") forState:UIControlStateNormal];
        iconBtn.layer.cornerRadius = 45*SCALE_HEIGHT;
        iconBtn.clipsToBounds = YES;
        iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [iconContent addSubview:iconBtn];
        [[iconBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickIconBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickIconBtn:iconBtn];
            }
        }];
        self.iconBtn = iconBtn;
        iconBtn.sd_layout
        .rightSpaceToView(iconContent, 20*SCALE_WIDTH)
        .heightIs(90*SCALE_HEIGHT)
        .widthEqualToHeight()
        .centerYEqualToView(iconContent);
        
        UIImageView *cameraImg = [[UIImageView alloc] init];
        cameraImg.image = IMAGENAME(@"xiangji");
        cameraImg.contentMode = UIViewContentModeCenter;
        [iconContent addSubview:cameraImg];
        cameraImg.sd_layout
        .bottomSpaceToView(iconContent, 10*SCALE_HEIGHT)
        .leftSpaceToView(iconContent, SCREENW-115*SCALE_WIDTH)
        .heightIs(36*SCALE_HEIGHT)
        .widthEqualToHeight();
        

        // 姓名
        UIView *nameContent = [[UIView alloc] init];
        nameContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:nameContent];
        nameContent.sd_layout
        .topSpaceToView(iconContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *nameTitle = [[UILabel alloc] init];
        nameTitle.font = XFont(13);
        nameTitle.textColor = HEXCOLOR(@"#333333");
        nameTitle.text = @"姓名";
        [nameContent addSubview:nameTitle];
        
        nameTitle.sd_layout
        .topEqualToView(nameContent)
        .leftSpaceToView(nameContent, 20*SCALE_WIDTH)
        .bottomEqualToView(nameContent)
        .widthIs(100*SCALE_WIDTH);
        [nameTitle changeAlignmentRightandLeft];
        
        UITextField *nameTF = [[UITextField alloc] init];
        nameTF.placeholder = @"请输入您的姓名";
        nameTF.textColor = HEXCOLOR(@"#333333");
        nameTF.font = XFont(13);
//        nameTF.userInteractionEnabled = NO;
        [nameContent addSubview:nameTF];
        self.nameTF = nameTF;
        nameTF.sd_layout
        .topEqualToView(nameContent)
        .leftSpaceToView(nameTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(nameContent);
        
/*
        // 性别
        UIView *sexContent = [[UIView alloc] init];
        sexContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:sexContent];
        sexContent.sd_layout
        .topSpaceToView(nameContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *sexTitle = [[UILabel alloc] init];
        sexTitle.text = @"性别";
        sexTitle.font = XFont(13);
        sexTitle.textColor = RGBCOLORe(51);
        [sexContent addSubview:sexTitle];
        sexTitle.sd_layout
        .topEqualToView(sexContent)
        .leftSpaceToView(sexContent, 20*SCALE_WIDTH)
        .bottomEqualToView(sexContent)
        .widthIs(100*SCALE_WIDTH);
        [sexTitle changeAlignmentRightandLeft];
        
        UILabel *sexLbl = [[UILabel alloc] init];
        sexLbl.text = @"男";
        sexLbl.font = XFont(13);
        sexLbl.textColor = RGBCOLORe(51);
        [sexContent addSubview:sexLbl];
        self.sexLbl = sexLbl;
        sexLbl.sd_layout
        .topEqualToView(sexContent)
        .leftSpaceToView(sexTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(sexContent)
        .rightEqualToView(sexContent);
        
        
        UIButton *sexWomanBtn = [[UIButton alloc] init];
        //        sexWomanBtn.hidden = YES;
        sexWomanBtn.titleLabel.font = XFont(13);
        [sexWomanBtn setTitle:@" 女" forState:UIControlStateNormal];
        [sexWomanBtn setTitleColor:RGBCOLORe(51) forState:UIControlStateNormal];
        [sexWomanBtn setImage:IMAGENAME(@"xingbie-meixuanzhong") forState:UIControlStateNormal];
        [sexWomanBtn setImage:IMAGENAME(@"xingbie-xuanzhong") forState:UIControlStateSelected];
        [sexContent addSubview:sexWomanBtn];
        self.sexWomanBtn = sexWomanBtn;
        sexWomanBtn.sd_layout
        .topEqualToView(sexContent)
        .rightSpaceToView(sexContent, 30*SCALE_WIDTH)
        .bottomEqualToView(sexContent)
        .widthIs(90*SCALE_WIDTH);
        
        
        UIButton *sexManBtn = [[UIButton alloc] init];
//        sexManBtn.hidden = YES;
        sexManBtn.titleLabel.font = XFont(13);
        [sexManBtn setTitle:@" 男" forState:UIControlStateNormal];
        [sexManBtn setTitleColor:RGBCOLORe(51) forState:UIControlStateNormal];
        [sexManBtn setImage:IMAGENAME(@"xingbie-meixuanzhong") forState:UIControlStateNormal];
        [sexManBtn setImage:IMAGENAME(@"xingbie-xuanzhong") forState:UIControlStateSelected];
        [sexContent addSubview:sexManBtn];
        self.sexManBtn = sexManBtn;
        sexManBtn.sd_layout
        .topEqualToView(sexContent)
        .rightSpaceToView(sexWomanBtn, 30*SCALE_WIDTH)
        .bottomEqualToView(sexContent)
        .widthIs(90*SCALE_WIDTH);
        
        
        [[sexManBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (sexManBtn.selected) {
                return ;
            }
            sexManBtn.selected = !sexManBtn.selected;
            sexWomanBtn.selected = !sexManBtn.selected;
            sexLbl.text = sexManBtn.selected ? @"男":@"女";
        }];
        
        [[sexWomanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (sexWomanBtn.selected) {
                return ;
            }
            sexWomanBtn.selected = !sexWomanBtn.selected;
            sexManBtn.selected = !sexWomanBtn.selected;
            
            sexLbl.text = sexManBtn.selected ? @"男":@"女";
        }];
        
        

        // 手机号
        UIView *phoneContent = [[UIView alloc] init];
        phoneContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:phoneContent];
        phoneContent.sd_layout
        .topSpaceToView(sexContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *phoneTitle = [[UILabel alloc] init];
        phoneTitle.font = XFont(13);
        phoneTitle.textColor = RGBCOLORe(51);
        phoneTitle.text = @"手机号";
        [phoneContent addSubview:phoneTitle];
        phoneTitle.sd_layout
        .topEqualToView(phoneContent)
        .leftSpaceToView(phoneContent, 20*SCALE_WIDTH)
        .bottomEqualToView(phoneContent)
        .widthIs(100*SCALE_WIDTH);
        [phoneTitle changeAlignmentRightandLeft];
        
        UITextField *phoneTF = [[UITextField alloc] init];
        phoneTF.keyboardType=UIKeyboardTypeNumberPad;
        phoneTF.font = XFont(13);
        phoneTF.userInteractionEnabled = NO;
        phoneTF.textColor = RGBCOLORe(51);
        phoneTF.placeholder = @"请输入您的手机号";
        [phoneContent addSubview:phoneTF];
        self.phoneTF = phoneTF;
        phoneTF.sd_layout
        .topEqualToView(phoneContent)
        .leftSpaceToView(phoneTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(phoneContent)
        .rightEqualToView(phoneContent);

        // 现居地
        UIView *areaContent = [[UIView alloc] init];
        areaContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:areaContent];
        areaContent.sd_layout
        .topSpaceToView(phoneContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *areaTitle = [[UILabel alloc] init];
        areaTitle.font = XFont(13);
        areaTitle.textColor = RGBCOLORe(51);
        areaTitle.text = @"现居住地";
        [areaContent addSubview:areaTitle];
        areaTitle.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaContent, 20*SCALE_WIDTH)
        .bottomEqualToView(areaContent)
        .widthIs(130*SCALE_WIDTH);
        [areaTitle changeAlignmentRightandLeft];
        
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
        areaLbl.font = XFont(13);
        areaLbl.textColor = RGBCOLORe(51);
//        areaLbl.text = @"请选择居住地";
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
            [self endEditing:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickAreaBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickAreaBtn:areaBtn];
            }
        }];
        areaBtn.sd_layout
        .topEqualToView(areaContent)
        .leftEqualToView(areaLbl)
        .bottomEqualToView(areaContent)
        .rightEqualToView(areaContent);
        

        // 详细地址
        UIView *addressContent = [[UIView alloc] init];
        addressContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:addressContent];
        addressContent.sd_layout
        .topSpaceToView(areaContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *addressTitle = [[UILabel alloc] init];
        addressTitle.font = XFont(13);
        addressTitle.textColor = RGBCOLORe(51);
        addressTitle.text = @"详细地址";
        [addressContent addSubview:addressTitle];
        addressTitle.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressContent, 20*SCALE_WIDTH)
        .bottomEqualToView(addressContent)
        .widthIs(130*SCALE_WIDTH);
        [addressTitle changeAlignmentRightandLeft];
        
        UITextField *addressTF = [[UITextField alloc] init];
        addressTF.font = XFont(13);
        addressTF.textColor = RGBCOLORe(51);
        addressTF.placeholder = @"请输入详细地址";
        [addressContent addSubview:addressTF];
        self.addressTF = addressTF;
        addressTF.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(addressContent)
        .rightEqualToView(addressContent);

        // 亲友关系
        UIView *friendContent = [[UIView alloc] init];
        friendContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:friendContent];
        friendContent.sd_layout
        .topSpaceToView(addressContent, 10*SCALE_HEIGHT)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *friendTitle = [[UILabel alloc] init];
        friendTitle.font = XFont(13);
        friendTitle.textColor = RGBCOLORe(51);
        friendTitle.text = @"亲友关系";
        [friendContent addSubview:friendTitle];
        friendTitle.sd_layout
        .topEqualToView(friendContent)
        .leftSpaceToView(friendContent, 20*SCALE_WIDTH)
        .bottomEqualToView(friendContent)
        .widthIs(130*SCALE_WIDTH);
        [friendTitle changeAlignmentRightandLeft];
        
        UIImageView *friendArrow = [[UIImageView alloc] init];
        friendArrow.image = IMAGENAME(@"arrow_right");
        friendArrow.contentMode = UIViewContentModeCenter;
        [friendContent addSubview:friendArrow];
        
        friendArrow.sd_layout
        .topEqualToView(friendContent)
        .rightEqualToView(friendContent)
        .bottomEqualToView(friendContent)
        .widthIs(56*SCALE_WIDTH);
        
        UILabel *friendLbl = [[UILabel alloc] init];
        friendLbl.font = XFont(13);
        friendLbl.textColor = RGBCOLORe(51);
//        friendLbl.text = @"请选择亲友关系";
        [friendContent addSubview:friendLbl];
        self.friendLbl = friendLbl;
        friendLbl.sd_layout
        .topEqualToView(friendContent)
        .leftSpaceToView(friendTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(friendContent)
        .rightSpaceToView(friendArrow, 0);
        
        UIButton *friendBtn = [[UIButton alloc] init];
        friendBtn.backgroundColor = CLEARCOLOR;
        [friendContent addSubview:friendBtn];
        self.friendBtn = friendBtn;
        [[friendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self endEditing:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickFriendBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickFriendBtn:friendBtn];
            }
        }];
        friendBtn.sd_layout
        .topEqualToView(friendContent)
        .leftEqualToView(friendLbl)
        .bottomEqualToView(friendContent)
        .rightEqualToView(friendContent);
*/

        // 支付宝
        UIView *alipayContent = [[UIView alloc] init];
        alipayContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:alipayContent];
        alipayContent.sd_layout
        .topSpaceToView(nameContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *alipayTitle = [[UILabel alloc] init];
        alipayTitle.font = XFont(13);
        alipayTitle.textColor = RGBCOLORe(51);
        alipayTitle.text = @"用户支付宝账号";
        [alipayContent addSubview:alipayTitle];
        alipayTitle.sd_layout
        .topEqualToView(alipayContent)
        .leftSpaceToView(alipayContent, 20*SCALE_WIDTH)
        .bottomEqualToView(alipayContent)
        .widthIs(170*SCALE_WIDTH);
        [alipayTitle changeAlignmentRightandLeft];
        
        UITextField *alipayTF = [[UITextField alloc] init];
//        alipayTF.keyboardType=UIKeyboardTypeNumberPad;
        alipayTF.font = XFont(13);
        alipayTF.textColor = RGBCOLORe(51);
        alipayTF.placeholder=@"请输入支付宝号";
        [alipayContent addSubview:alipayTF];
        self.alipayTF = alipayTF;
        alipayTF.sd_layout
        .topEqualToView(alipayContent)
        .leftSpaceToView(alipayTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(alipayContent)
        .rightEqualToView(alipayContent);
     
        // 亲友电话
        UIView *friendNumContent = [[UIView alloc] init];
        friendNumContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:friendNumContent];
        friendNumContent.sd_layout
        .topSpaceToView(alipayContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(71*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);
        
        UILabel *friendNumTitle = [[UILabel alloc] init];
        friendNumTitle.font = XFont(13);
        friendNumTitle.textColor = RGBCOLORe(51);
        friendNumTitle.text = @"亲友手机号";
        [friendNumContent addSubview:friendNumTitle];
        friendNumTitle.sd_layout
        .topEqualToView(friendNumContent)
        .leftSpaceToView(friendNumContent, 20*SCALE_WIDTH)
        .bottomEqualToView(friendNumContent)
        .widthIs(130*SCALE_WIDTH);
        [friendNumTitle changeAlignmentRightandLeft];
        
        UITextField *friendNumTF = [[UITextField alloc] init];
        friendNumTF.keyboardType=UIKeyboardTypeNumberPad;
        friendNumTF.font = XFont(13);
        friendNumTF.textColor = RGBCOLORe(51);
        friendNumTF.placeholder=@"请输入亲友手机号";
        [friendNumContent addSubview:friendNumTF];
        self.friendNumTF = friendNumTF;
        friendNumTF.sd_layout
        .topEqualToView(friendNumContent)
        .leftSpaceToView(friendNumTitle, 44*SCALE_WIDTH)
        .bottomEqualToView(friendNumContent)
        .rightEqualToView(friendNumContent);


        // 驾驶证
        UIView *carCardContent = [[UIView alloc] init];
        carCardContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:carCardContent];
        self.carCardContent = carCardContent;
        carCardContent.sd_layout
        .topSpaceToView(friendNumContent, 1)
        .leftEqualToView(contentScrollView)
        .rightEqualToView(contentScrollView)
        .heightIs(50*SCALE_HEIGHT);

        UILabel *carCardTitle = [[UILabel alloc] init];
        carCardTitle.font = XFont(13);
        carCardTitle.textColor = RGBCOLORe(51);
        carCardTitle.text = @"档案编号";
        [carCardContent addSubview:carCardTitle];
        self.carCardTitle = carCardTitle;
        carCardTitle.sd_layout
        .topSpaceToView(carCardContent, 0)
        .leftSpaceToView(carCardContent, 20*SCALE_WIDTH)
        .bottomEqualToView(carCardContent)
        .widthIs(120*SCALE_WIDTH);
        [carCardTitle changeAlignmentRightandLeft];
        
        
        // 输入驾驶证号
        UITextField *carCardTF  = [[UITextField alloc] init];
        carCardTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        carCardTF.delegate=self;
        carCardTF.font = XFont(13);
        carCardTF.placeholder = @"请输入驾驶证档案编号";
        carCardTF.textColor = HEXCOLOR(@"#333333");
        [carCardContent addSubview:carCardTF];
        self.carCardTF = carCardTF;
        
        carCardTF.sd_layout
        .topEqualToView(carCardTitle)
        .leftSpaceToView(carCardTitle, 10)
        .bottomEqualToView(carCardTitle)
        .rightSpaceToView(carCardContent, 1);
        
//        [carCardContent setupAutoHeightWithBottomViewsArray:carCardContent.subviews bottomMargin:20*SCALE_HEIGHT];
//        [carCardContent setupAutoHeightWithBottomView:carCardImg bottomMargin:20*SCALE_HEIGHT];

        
        // 驾驶证图片
        UIView *carCardImgContent = [[UIView alloc] init];
        carCardImgContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:carCardImgContent];
        self.carCardImgContent = carCardImgContent;
        carCardImgContent.sd_layout
        .topSpaceToView(carCardContent, 1)
        .leftEqualToView(contentScrollView)
        .rightEqualToView(contentScrollView)
        .heightIs(280*SCALE_HEIGHT);
        
        UILabel *carCardImgTitle = [[UILabel alloc] init];
        carCardImgTitle.font = XFont(13);
        carCardImgTitle.textColor = RGBCOLORe(51);
        self.carCardImgTitle = carCardImgTitle;
        NSString * carCardImgStr = @"上传本人手持驾照图片(确保证件清晰无误才能通过审核)";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:carCardImgStr];
        NSRange rang = [carCardImgStr rangeOfString:@"(确保证件清晰无误才能通过审核)"];
        //设置标签文字属性
        [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:GRAYCOLOR, NSForegroundColorAttributeName,XFont(11),NSFontAttributeName, nil] range:rang];
        carCardImgTitle.attributedText = attributeString;

        [carCardImgContent addSubview:carCardImgTitle];
//        self.carCardTitle = carCardImgTitle;
        carCardImgTitle.sd_layout
        .topSpaceToView(carCardImgContent, 1)
        .leftSpaceToView(carCardImgContent, 20*SCALE_WIDTH)
        .heightIs(44*SCALE_WIDTH)
        .rightSpaceToView(carCardImgContent, 20*SCALE_WIDTH);
//        [carCardImgTitle changeAlignmentRightandLeft];
        
        UIImageView *carCardImg = [[UIImageView alloc] init];
        carCardImg.contentMode = UIViewContentModeScaleAspectFill;
        carCardImg.clipsToBounds = YES;
        [carCardImgContent addSubview:carCardImg];
        carCardImg.image = IMAGENAME(@"driver_card");
        self.carCardImg = carCardImg;
        
        carCardImg.sd_layout
        .topSpaceToView(carCardTitle, 0)
        .leftSpaceToView(carCardImgContent, 20*SCALE_WIDTH)
        .widthIs(290*SCALE_WIDTH)
        .heightIs(210*SCALE_WIDTH);
        
        
        UIButton *carCardBtn = [[UIButton alloc] init];
        [carCardBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        carCardBtn.imageView.contentMode = UIViewContentModeCenter;
        [carCardImgContent addSubview:carCardBtn];
        self.carCardBtn = carCardBtn;
        
        
        
        [[carCardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self endEditing:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickCarCardBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickCarCardBtn:carCardBtn];
            }
        }];
        carCardBtn.sd_layout
        .topSpaceToView(carCardTitle, 0)
        .leftSpaceToView(carCardImgContent, 20*SCALE_WIDTH)
        .widthIs(290*SCALE_WIDTH)
        .heightIs(210*SCALE_WIDTH);

        
        // 输入身份证号
        UIView *cardContent = [[UIView alloc] init];
        cardContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:cardContent];
        self.cardContent = cardContent;
        cardContent.sd_layout
        .topSpaceToView(carCardImgContent, 1)
        .leftEqualToView(contentScrollView)
        .rightEqualToView(contentScrollView)
        .heightIs(50*SCALE_HEIGHT);
        
        UILabel *cardTitle = [[UILabel alloc] init];
        cardTitle.font = XFont(13);
        cardTitle.textColor = RGBCOLORe(51);
        cardTitle.text = @"身份证号";
        [cardContent addSubview:cardTitle];
        self.cardTitle = cardTitle;
        cardTitle.sd_layout
        .topSpaceToView(cardContent, 0)
        .leftSpaceToView(cardContent, 20*SCALE_WIDTH)
        .bottomEqualToView(cardContent)
        .widthIs(120*SCALE_WIDTH);
        [cardTitle changeAlignmentRightandLeft];
        
        UITextField *cardTF  = [[UITextField alloc] init];
        cardTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        cardTF.delegate=self;
        cardTF.font = XFont(13);
        cardTF.placeholder = @"请输入个人身份证号";
        cardTF.textColor = HEXCOLOR(@"#333333");
        [cardContent addSubview:cardTF];
        self.cardTF = cardTF;
        
        cardTF.sd_layout
        .topEqualToView(cardTitle)
        .leftSpaceToView(cardTitle, 10)
        .bottomEqualToView(cardTitle)
        .rightSpaceToView(cardContent, 1);

        
        // 身份证图片上传
        UIView *cardImgContent = [[UIView alloc] init];
        cardImgContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:cardImgContent];
//        self.cardContent = cardContent;
        cardImgContent.sd_layout
        .topSpaceToView(cardContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(270*SCALE_HEIGHT)
        .rightEqualToView(contentScrollView);

        UILabel *cardImgTitle = [[UILabel alloc] init];
        cardImgTitle.font = XFont(13);
        cardImgTitle.textColor = RGBCOLORe(51);
        self.cardImgTitle = cardImgTitle;
        NSString * cardImgStr = @"上传手持身份证正反照(确保证件清晰无误才能通过审核)";
        NSMutableAttributedString *cardAttributeString = [[NSMutableAttributedString alloc] initWithString:cardImgStr];
        NSRange range = [cardImgStr rangeOfString:@"(确保证件清晰无误才能通过审核)"];
        //设置标签文字属性
        [cardAttributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:GRAYCOLOR, NSForegroundColorAttributeName,XFont(11),NSFontAttributeName, nil] range:range];
        cardImgTitle.attributedText = cardAttributeString;

        [cardImgContent addSubview:cardImgTitle];
//        self.cardTitle = cardTitle;
        cardImgTitle.sd_layout
        .topSpaceToView(cardImgContent, 1)
        .leftSpaceToView(cardImgContent, 20*SCALE_WIDTH)
        .heightIs(44*SCALE_HEIGHT)
        .rightSpaceToView(cardImgContent, 20*SCALE_WIDTH);
//        [cardTitle changeAlignmentRightandLeft];




        UIImageView *cardFrontImg = [[UIImageView alloc] init];
        cardFrontImg.clipsToBounds = YES;
        cardFrontImg.contentMode = UIViewContentModeScaleAspectFill;
        [cardImgContent addSubview:cardFrontImg];
        cardFrontImg.image = IMAGENAME(@"default_identify");
        self.cardFrontImg = cardFrontImg;

        cardFrontImg.sd_layout
        .topSpaceToView(cardImgTitle, 0)
        .leftSpaceToView(cardImgContent, 20*SCALE_WIDTH)
        .widthIs((SCREENW - 60*SCALE_WIDTH)*0.5)
        .heightIs(210*SCALE_WIDTH);

        UIButton *cardBtn = [[UIButton alloc] init];
        [cardBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        [cardImgContent addSubview:cardBtn];
        self.cardBtn = cardBtn;
        [[cardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self endEditing:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickCardBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickCardBtn:cardBtn];
            }
        }];
        cardBtn.sd_layout
        .topSpaceToView(cardImgTitle, 0)
        .leftSpaceToView(cardImgContent, 20*SCALE_WIDTH)
        .widthIs((SCREENW - 60*SCALE_WIDTH)*0.5)
        .heightIs(210*SCALE_WIDTH);

        
        
        UIImageView *cardBackImg = [[UIImageView alloc] init];
        cardBackImg.clipsToBounds = YES;
        cardBackImg.contentMode = UIViewContentModeScaleAspectFill;
        [cardImgContent addSubview:cardBackImg];
        cardBackImg.image = IMAGENAME(@"default_identify_fan");
        self.cardBackImg = cardBackImg;

        cardBackImg.sd_layout
        .topSpaceToView(cardImgTitle, 0)
        .rightSpaceToView(cardImgContent, 20*SCALE_WIDTH)
        .widthIs((SCREENW - 60*SCALE_WIDTH)*0.5)
        .heightIs(210*SCALE_WIDTH);
        
        
        
//        [cardContent setupAutoHeightWithBottomViewsArray:cardContent.subviews bottomMargin:20*SCALE_HEIGHT];
//        [cardContent setupAutoHeightWithBottomView:cardBackImg bottomMargin:20*SCALE_HEIGHT];
        
        
        
        // 保存
        UIButton *saveBtn = [[UIButton alloc] init];
        [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
        [saveBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        saveBtn.titleLabel.font = XFont(14);
        saveBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
        saveBtn.clipsToBounds = YES;
        saveBtn.backgroundColor = MAINGREEN;
        [contentScrollView addSubview:saveBtn];
        self.saveBtn = saveBtn;
//        [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [[saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self endEditing:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFUserInfoScroolView:didClickSaveBtn:)]) {
                [self.delegate XFUserInfoScroolView:self didClickSaveBtn:saveBtn];
            }
        }];
        
        saveBtn.sd_layout
        .topSpaceToView(cardImgContent, 50*SCALE_HEIGHT)
        .leftSpaceToView(contentScrollView, 50*SCALE_WIDTH)
        .heightIs(80*SCALE_HEIGHT)
        .rightSpaceToView(contentScrollView, 50*SCALE_WIDTH);
        
        [contentScrollView setupAutoContentSizeWithBottomView:saveBtn bottomMargin:38*SCALE_HEIGHT];
        
    }
    return self;
}
- (void)setUserModel:(XFUserInfoModel *)userModel{
    _userModel = userModel;
    
    // icon
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.img] forState:UIControlStateNormal placeholderImage:IMAGENAME(@"morentouxiang")];
    // 姓名
    self.nameTF.text = userModel.username;
    // 手机号
    self.phoneTF.text = userModel.phone;
    // 性别
    self.sexLbl.text = userModel.sex;
    if ([userModel.sex isEqualToString:@"男"]) {
        self.sexManBtn.selected = YES;
    }else{
        self.sexWomanBtn.selected = YES;
    }
    // 区域
    self.areaLbl.text = userModel.area;
    // 地址
    self.addressTF.text = userModel.address;
    //亲友关系
    self.friendLbl.text = userModel.friend;
    // 亲友电话
    self.friendNumTF.text = userModel.friend_phone;
    // 支付宝
    self.alipayTF.text = userModel.paynumber;
    // 驾照
//    self.carCardTF.hidden = userModel.driver_number.length > 0 ? NO : YES;
    self.carCardTF.text = userModel.driver_number;
    if (userModel.car_card.length > 0) {
        [self.carCardImg sd_setImageWithURL:[NSURL URLWithString:userModel.car_card] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.carCardImg.sd_layout
            .heightIs(210*SCALE_HEIGHT);
        }];
    }
    // 身份证
//    self.cardTF.hidden = userModel.id_card.length > 0 ? NO : YES;
    self.cardTF.text = userModel.id_card;
    NSArray *cardUrls = [userModel.card componentsSeparatedByString:@","];
    if (cardUrls.count == 2) {
        [self.cardFrontImg sd_setImageWithURL:[NSURL URLWithString:cardUrls[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.cardFrontImg.sd_layout
            .heightIs(210*SCALE_HEIGHT);
        }];
        [self.cardBackImg sd_setImageWithURL:[NSURL URLWithString:cardUrls[1]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.cardBackImg.sd_layout
            .heightIs(210*SCALE_HEIGHT);
        }];
    }
    
//    UIImageView *img = [[UIImageView alloc] init];
//    img.image = IMAGENAME(@"icon_temp");
//    [self.carCardContent addSubview:img];
//    
//    img.sd_layout
//    .topSpaceToView(self.carCardTitle, 0)
//    .leftSpaceToView(self.carCardContent, 20*SCALE_WIDTH)
//    .heightIs(210*SCALE_HEIGHT)
//    .widthIs(290*SCALE_HEIGHT);
//    
//    [self.carCardContent setupAutoHeightWithBottomViewsArray:self.carCardContent.subviews bottomMargin:20*SCALE_HEIGHT];
    
    if (userModel.status == 2) {
        if (userModel.username.length == 0) {
            
            [self addNotify:@"(填写有误,请重新提交)" inContent:self.nameTF.superview];
        }
        if (userModel.paynumber.length == 0) {
            
            [self addNotify:@"(填写有误,请重新提交)" inContent:self.alipayTF.superview];
        }
        if (userModel.friend_phone.length == 0) {
            
            [self addNotify:@"(填写有误,请重新提交)" inContent:self.friendNumTF.superview];
        }
        if (userModel.driver_number.length == 0) {
            
            [self addNotify:@"(填写有误,请重新提交)" inContent:self.carCardTF.superview];
        }
        if (userModel.id_card.length == 0) {
            
            [self addNotify:@"(填写有误,请重新提交)" inContent:self.cardTF.superview];
        }

        if (userModel.car_card.length == 0) {
            self.carCardImgTitle.attributedText = nil;
            self.carCardImgTitle.text = @"上传本人手持驾照图片";
            
            UILabel * label = [self getNotifyLabel:@"(照片模糊无法通过审核,请重新提交)" inContent:self.carCardImgTitle.superview];
            label.sd_layout
            .centerYEqualToView(self.carCardImgTitle)
            .rightSpaceToView(self.carCardImgTitle.superview, 5)
            .heightIs(10)
            .widthIs(170);

        }
        
        if (userModel.card.length == 0) {
            self.cardImgTitle.attributedText = nil;
            self.cardImgTitle.text = @"上传手持身份证正反照";
            
            UILabel * label = [self getNotifyLabel:@"(照片模糊无法通过审核,请重新提交)" inContent:self.cardImgTitle.superview];
            label.sd_layout
            .centerYEqualToView(self.cardImgTitle)
            .rightSpaceToView(self.cardImgTitle.superview, 5)
            .heightIs(10)
            .widthIs(170);
            
        }

    }

}

-(void)addNotify:(NSString*)notify inContent:(UIView*)content{
    UILabel * label = [UILabel new];
    label.font = XFont(9);
    label.textColor = HEXCOLOR(@"#F03C3C");
    label.text = notify;
    label.textAlignment = NSTextAlignmentRight;
    [content addSubview:label];

    label.sd_layout
    .bottomSpaceToView(content, 5)
    .rightSpaceToView(content, 5)
    .heightIs(10)
    .widthIs(100);
    
}

-(UILabel*)getNotifyLabel:(NSString*)notify inContent:(UIView*)content{
    UILabel * label = [UILabel new];
    label.font = XFont(9);
    label.textColor = HEXCOLOR(@"#F03C3C");
    label.text = notify;
    label.textAlignment = NSTextAlignmentRight;
    [content addSubview:label];
    
    return label;
}



-(void)setEnableEdit:(BOOL)enableEdit{
    _enableEdit = enableEdit;
    
//    self.iconBtn.userInteractionEnabled = enableEdit;
    self.nameTF.userInteractionEnabled = enableEdit;
    self.phoneTF.userInteractionEnabled = enableEdit;
    self.areaBtn.userInteractionEnabled = enableEdit;
    self.addressTF.userInteractionEnabled = enableEdit;
    self.friendBtn.userInteractionEnabled = enableEdit;
    self.friendNumTF.userInteractionEnabled = enableEdit;
    self.alipayTF.userInteractionEnabled = enableEdit;
    self.sexManBtn.userInteractionEnabled = enableEdit;
    self.sexWomanBtn.userInteractionEnabled = enableEdit;
    self.carCardTF.userInteractionEnabled = enableEdit;
    self.cardTF.userInteractionEnabled = enableEdit;
    
    /*
    if (self.carCardTF.text.length > 0 || enableEdit) {
        self.carCardTF.hidden = NO;
    }else if(!(self.carCardTF.text.length > 0) && !enableEdit){
        self.carCardTF.hidden = YES;
    }
    
    if (self.cardTF.text.length > 0 || enableEdit) {
        self.cardTF.hidden = NO;
    }else if(!(self.cardTF.text.length > 0) && !enableEdit){
        self.cardTF.hidden = YES;
    }
    */
//    if (enableEdit) {
//        self.carCardTF.hidden = NO;
//    }else{
//        if (self.carCardTF.text.length > 0) {
//            self.carCardTF.hidden = NO;
//        }else{
//            self.carCardTF.hidden = YES;
//        }
//    }
    
//    if (enableEdit) {
//        self.cardTF.hidden = NO;
//    }else{
//        if (self.cardTF.text.length > 0) {
//            self.cardTF.hidden = NO;
//        }else{
//            self.cardTF.hidden = YES;
//        }
//
//    }
    
    self.sexManBtn.hidden = !enableEdit;
    self.sexWomanBtn.hidden = !enableEdit;
    self.carCardBtn.hidden = !enableEdit;
    self.cardBtn.hidden = !enableEdit;

    
    if (enableEdit) {
        self.saveBtn.hidden = NO;
        self.saveBtn.userInteractionEnabled = YES;
    }else{
        self.saveBtn.hidden = YES;
        self.saveBtn.userInteractionEnabled = NO;
        self.carCardImgTitle.text = @"手持驾照图片";
        self.cardImgTitle.text = @"手持身份证正反照";

    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self endEditing:YES];
}
@end
