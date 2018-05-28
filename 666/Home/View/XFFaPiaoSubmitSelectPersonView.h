//
//  XFFaPiaoSubmitSelectPersonView.h
//  666
//
//  Created by TDC_MacMini on 2017/12/9.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFFaPiaoSubmitSelectPersonView;
@protocol XFFaPiaoSubmitSelectPersonViewDelegate<NSObject>

@optional

- (void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickCompanyBtn:(UIButton *)button;
- (void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickPersonBtn:(UIButton *)button;

- (void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickAreaBtn:(UIButton *)button;

- (void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickCommitBtn:(UIButton *)button;

@end

@interface XFFaPiaoSubmitSelectPersonView : UIView

@property (nonatomic, strong) UILabel *totalMoneyLabel2;
@property (nonatomic, strong) UIButton *personTTBtn;
@property (nonatomic, strong) UIButton *companyTTBtn;
@property (nonatomic, strong) UITextField *fpMoneyTF;
@property (nonatomic, strong) UITextField *moreInfoTF;
@property (nonatomic, strong) UITextField *receivePersonTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *areaLbl;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UILabel *fpnrLabel2;


@property (nonatomic, weak) id<XFFaPiaoSubmitSelectPersonViewDelegate> delegate;

@end
