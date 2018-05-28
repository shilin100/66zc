//
//  XFFaPiaoSubmitSelectPersonView.m
//  666
//
//  Created by TDC_MacMini on 2017/12/9.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFFaPiaoSubmitSelectPersonView.h"

@interface XFFaPiaoSubmitSelectPersonView() <UIScrollViewDelegate>

@end


@implementation XFFaPiaoSubmitSelectPersonView

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
        
        UILabel *fpxqLabel = [[UILabel alloc] init];
        fpxqLabel.text = @"发票详情";
        fpxqLabel.font = XFont(13);
        fpxqLabel.textColor = BLACKCOLOR;
        [contentScrollView addSubview:fpxqLabel];
        fpxqLabel.sd_layout
        .topSpaceToView(contentScrollView, 0)
        .leftSpaceToView(contentScrollView, 10)
        .heightIs(30)
        .widthIs(80);
        
        //抬头类型
        UIView *ttTypeContent = [[UIView alloc] init];
        ttTypeContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:ttTypeContent];
        ttTypeContent.sd_layout
        .topSpaceToView(fpxqLabel, 0)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *ttTypeLabel = [[UILabel alloc] init];
        ttTypeLabel.text = @"抬头类型";
        ttTypeLabel.font = XFont(13);
        ttTypeLabel.textColor = HEXCOLOR(@"999999");
        [ttTypeContent addSubview:ttTypeLabel];
        ttTypeLabel.sd_layout
        .topEqualToView(ttTypeContent)
        .bottomEqualToView(ttTypeContent)
        .leftSpaceToView(ttTypeContent, 10)
        .widthIs(80);
        
        UIButton *companyTTBtn = [[UIButton alloc] init];
        companyTTBtn.titleLabel.font = XFont(13);
        companyTTBtn.selected=YES;
        [companyTTBtn setTitle:@"企业抬头" forState:UIControlStateNormal];
        [companyTTBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [companyTTBtn setImage:IMAGENAME(@"xingbie-meixuanzhong") forState:UIControlStateNormal];
        [companyTTBtn setImage:IMAGENAME(@"xingbie-xuanzhong") forState:UIControlStateSelected];
        [ttTypeContent addSubview:companyTTBtn];
        self.companyTTBtn = companyTTBtn;
        companyTTBtn.sd_layout
        .topEqualToView(ttTypeContent)
        .leftSpaceToView(ttTypeLabel, 5)
        .bottomEqualToView(ttTypeContent)
        .widthIs(80);
        
        
        UIButton *personTTBtn = [[UIButton alloc] init];
        personTTBtn.titleLabel.font = XFont(13);
        [personTTBtn setTitle:@"个人/非企业单位" forState:UIControlStateNormal];
        [personTTBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [personTTBtn setImage:IMAGENAME(@"xingbie-meixuanzhong") forState:UIControlStateNormal];
        [personTTBtn setImage:IMAGENAME(@"xingbie-xuanzhong") forState:UIControlStateSelected];
        [ttTypeContent addSubview:personTTBtn];
        self.personTTBtn = personTTBtn;
        personTTBtn.sd_layout
        .topEqualToView(ttTypeContent)
        .leftSpaceToView(companyTTBtn, 10)
        .rightSpaceToView(ttTypeContent, 10)
        .bottomEqualToView(ttTypeContent);
        
        [[companyTTBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
//            if (companyTTBtn.selected) {
//                return ;
//            }
//            companyTTBtn.selected = !companyTTBtn.selected;
//            personTTBtn.selected = !companyTTBtn.selected;
            
            NSLog(@"选择公司2");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFFaPiaoSubmitSelectPersonView:didClickCompanyBtn:)]) {
                [self.delegate XFFaPiaoSubmitSelectPersonView:self didClickCompanyBtn:companyTTBtn];
            }
            
        }];
            
        
        
        [[personTTBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
//            if (personTTBtn.selected) {
//                return ;
//            }
//            personTTBtn.selected = !personTTBtn.selected;
//            companyTTBtn.selected = !personTTBtn.selected;
            
            NSLog(@"选择个人2");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFFaPiaoSubmitSelectPersonView:didClickPersonBtn:)]) {
                [self.delegate XFFaPiaoSubmitSelectPersonView:self didClickPersonBtn:personTTBtn];
            }
            
        }];
        
        
        
        //发票内容
        UIView *fpnrContent = [[UIView alloc] init];
        fpnrContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:fpnrContent];
        fpnrContent.sd_layout
        .topSpaceToView(ttTypeContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *fpnrLabel = [[UILabel alloc] init];
        fpnrLabel.text = @"发票内容";
        fpnrLabel.font = XFont(13);
        fpnrLabel.textColor = HEXCOLOR(@"999999");
        [fpnrContent addSubview:fpnrLabel];
        fpnrLabel.sd_layout
        .topEqualToView(fpnrContent)
        .bottomEqualToView(fpnrContent)
        .leftSpaceToView(fpnrContent, 10)
        .widthIs(80);
        
        UILabel *fpnrLabel2 = [[UILabel alloc] init];
        fpnrLabel2.text = @"共享汽车";
        fpnrLabel2.font = XFont(13);
        fpnrLabel2.textColor = BLACKCOLOR;
        [fpnrContent addSubview:fpnrLabel2];
        self.fpnrLabel2=fpnrLabel2;
        fpnrLabel2.sd_layout
        .topEqualToView(fpnrContent)
        .bottomEqualToView(fpnrContent)
        .leftSpaceToView(fpnrLabel, 5)
        .rightSpaceToView(fpnrContent, 10);
        
        
        //发票金额
        UIView *fpMoneyContent = [[UIView alloc] init];
        fpMoneyContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:fpMoneyContent];
        fpMoneyContent.sd_layout
        .topSpaceToView(fpnrContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *fpMoneyLabel = [[UILabel alloc] init];
        fpMoneyLabel.text = @"开票金额";
        fpMoneyLabel.font = XFont(13);
        fpMoneyLabel.textColor = HEXCOLOR(@"999999");
        [fpMoneyContent addSubview:fpMoneyLabel];
        fpMoneyLabel.sd_layout
        .topEqualToView(fpMoneyContent)
        .bottomEqualToView(fpMoneyContent)
        .leftSpaceToView(fpMoneyContent, 10)
        .widthIs(80);
        
        UITextField *fpMoneyTF = [[UITextField alloc] init];
        fpMoneyTF.font = XFont(13);
        fpMoneyTF.keyboardType=UIKeyboardTypeNumberPad;
        fpMoneyTF.placeholder = @"请输入开票金额(>=300元)";
        [fpMoneyContent addSubview:fpMoneyTF];
        self.fpMoneyTF = fpMoneyTF;
        fpMoneyTF.sd_layout
        .topEqualToView(fpMoneyContent)
        .bottomEqualToView(fpMoneyContent)
        .leftSpaceToView(fpMoneyLabel, 5)
        .rightSpaceToView(fpMoneyContent, 10);
        
        
        //更多信息
        UIView *moreInfoContent = [[UIView alloc] init];
        moreInfoContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:moreInfoContent];
        moreInfoContent.sd_layout
        .topSpaceToView(fpMoneyContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *moreInfoLabel = [[UILabel alloc] init];
        moreInfoLabel.text = @"更多信息";
        moreInfoLabel.font = XFont(13);
        moreInfoLabel.textColor = HEXCOLOR(@"999999");
        [moreInfoContent addSubview:moreInfoLabel];
        moreInfoLabel.sd_layout
        .topEqualToView(moreInfoContent)
        .bottomEqualToView(moreInfoContent)
        .leftSpaceToView(moreInfoContent, 10)
        .widthIs(80);
        
        UITextField *moreInfoTF = [[UITextField alloc] init];
        moreInfoTF.font = XFont(13);
        moreInfoTF.placeholder = @"填备注";
        [moreInfoContent addSubview:moreInfoTF];
        self.moreInfoTF = moreInfoTF;
        moreInfoTF.sd_layout
        .topEqualToView(moreInfoContent)
        .bottomEqualToView(moreInfoContent)
        .leftSpaceToView(moreInfoLabel, 5)
        .rightSpaceToView(moreInfoContent, 10);
        
        
        //收件信息
        UILabel *receiveInfoLabel = [[UILabel alloc] init];
        receiveInfoLabel.text = @"收件信息";
        receiveInfoLabel.font = XFont(13);
        receiveInfoLabel.textColor = BLACKCOLOR;
        [contentScrollView addSubview:receiveInfoLabel];
        receiveInfoLabel.sd_layout
        .topSpaceToView(moreInfoContent, 0)
        .leftSpaceToView(contentScrollView, 10)
        .heightIs(30)
        .widthIs(80);
        
        
        //收件人
        UIView *receivePersonContent = [[UIView alloc] init];
        receivePersonContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:receivePersonContent];
        receivePersonContent.sd_layout
        .topSpaceToView(receiveInfoLabel, 0)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *receivePersonLabel = [[UILabel alloc] init];
        receivePersonLabel.text = @"收件人";
        receivePersonLabel.font = XFont(13);
        receivePersonLabel.textColor = HEXCOLOR(@"999999");
        [receivePersonContent addSubview:receivePersonLabel];
        receivePersonLabel.sd_layout
        .topEqualToView(receivePersonContent)
        .bottomEqualToView(receivePersonContent)
        .leftSpaceToView(receivePersonContent, 10)
        .widthIs(80);
        
        UITextField *receivePersonTF = [[UITextField alloc] init];
        receivePersonTF.font = XFont(13);
        receivePersonTF.placeholder = @"填写收件人";
        [receivePersonContent addSubview:receivePersonTF];
        self.receivePersonTF = receivePersonTF;
        receivePersonTF.sd_layout
        .topEqualToView(receivePersonContent)
        .bottomEqualToView(receivePersonContent)
        .leftSpaceToView(receivePersonLabel, 5)
        .rightSpaceToView(receivePersonContent, 10);
        
        
        //联系电话
        UIView *phoneContent = [[UIView alloc] init];
        phoneContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:phoneContent];
        phoneContent.sd_layout
        .topSpaceToView(receivePersonContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.text = @"联系电话";
        phoneLabel.font = XFont(13);
        phoneLabel.textColor = HEXCOLOR(@"999999");
        [phoneContent addSubview:phoneLabel];
        phoneLabel.sd_layout
        .topEqualToView(phoneContent)
        .bottomEqualToView(phoneContent)
        .leftSpaceToView(phoneContent, 10)
        .widthIs(80);
        
        UITextField *phoneTF = [[UITextField alloc] init];
        phoneTF.font = XFont(13);
        phoneTF.placeholder = @"填写联系电话";
        phoneTF.keyboardType=UIKeyboardTypeNumberPad;
        [phoneContent addSubview:phoneTF];
        self.phoneTF = phoneTF;
        phoneTF.sd_layout
        .topEqualToView(phoneContent)
        .bottomEqualToView(phoneContent)
        .leftSpaceToView(phoneLabel, 5)
        .rightSpaceToView(phoneContent, 10);
        
        
        //所在地区
        UIView *areaContent = [[UIView alloc] init];
        areaContent.backgroundColor = WHITECOLOR;
        [contentScrollView addSubview:areaContent];
        areaContent.sd_layout
        .topSpaceToView(phoneContent, 1)
        .leftEqualToView(contentScrollView)
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        
        UILabel *areaTitle = [[UILabel alloc] init];
        areaTitle.font = XFont(13);
        areaTitle.textColor = HEXCOLOR(@"999999");
        areaTitle.text = @"所在地区";
        [areaContent addSubview:areaTitle];
        areaTitle.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaContent, 10)
        .bottomEqualToView(areaContent)
        .widthIs(80);
        
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
        areaLbl.textColor = BLACKCOLOR;
        areaLbl.text = @"请选择所在地区";
        [areaContent addSubview:areaLbl];
        self.areaLbl = areaLbl;
        areaLbl.sd_layout
        .topEqualToView(areaContent)
        .leftSpaceToView(areaTitle, 5)
        .bottomEqualToView(areaContent)
        .rightSpaceToView(areaArrow, 0);
        
        UIButton *areaBtn = [[UIButton alloc] init];
        areaBtn.backgroundColor = CLEARCOLOR;
        [areaContent addSubview:areaBtn];
        self.areaBtn = areaBtn;
        [[areaBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"选择地区");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFFaPiaoSubmitSelectPersonView:didClickAreaBtn:)]) {
                [self.delegate XFFaPiaoSubmitSelectPersonView:self didClickAreaBtn:areaBtn];
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
        .heightIs(44)
        .rightEqualToView(contentScrollView);
        
        UILabel *addressTitle = [[UILabel alloc] init];
        addressTitle.font = XFont(13);
        addressTitle.textColor = HEXCOLOR(@"999999");
        addressTitle.text = @"详细地址";
        [addressContent addSubview:addressTitle];
        addressTitle.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressContent, 10)
        .bottomEqualToView(addressContent)
        .widthIs(80);
        
        
        UITextField *addressTF = [[UITextField alloc] init];
        addressTF.font = XFont(13);
        addressTF.placeholder = @"填写详细地址";
        [addressContent addSubview:addressTF];
        self.addressTF = addressTF;
        addressTF.sd_layout
        .topEqualToView(addressContent)
        .leftSpaceToView(addressTitle, 5)
        .bottomEqualToView(addressContent)
        .rightSpaceToView(addressContent, 10);
        
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFFaPiaoSubmitSelectPersonView:didClickCommitBtn:)]) {
                [self.delegate XFFaPiaoSubmitSelectPersonView:self didClickCommitBtn:commitBtn];
            }
            
        }];
        
        commitBtn.sd_layout
        .centerXEqualToView(contentScrollView)
        .topSpaceToView(addressContent, 30)
        .widthIs(270)
        .heightIs(40);
        
        [contentScrollView setupAutoContentSizeWithBottomView:commitBtn bottomMargin:20];
        
    }
    
    return self;
    
}

@end
