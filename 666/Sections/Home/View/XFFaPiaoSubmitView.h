//
//  XFFaPiaoSubmitView.h
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFFaPiaoSubmitView;
@protocol XFFaPiaoSubmitViewDelegate<NSObject>

@optional

- (void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickCompanyBtn:(UIButton *)button;
- (void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickPersonBtn:(UIButton *)button;

- (void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickAreaBtn:(UIButton *)button;

- (void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickCommitBtn:(UIButton *)button;

@end

@interface XFFaPiaoSubmitView : UIView

@property (nonatomic, strong) UILabel *totalMoneyLabel2;
@property (nonatomic, strong) UIButton *personTTBtn;
@property (nonatomic, strong) UIButton *companyTTBtn;
@property (nonatomic, strong) UITextField *fpttTF;
@property (nonatomic, strong) UITextField *sbhTF;
@property (nonatomic, strong) UITextField *fpMoneyTF;
@property (nonatomic, strong) UITextField *moreInfoTF;
@property (nonatomic, strong) UITextField *receivePersonTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *areaLbl;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UILabel *fpnrLabel2;


@property (nonatomic, weak) id<XFFaPiaoSubmitViewDelegate> delegate;



@end
