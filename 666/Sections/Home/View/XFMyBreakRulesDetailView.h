//
//  XFMyBreakRulesDetailView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMyBreakRulesDetailView;
@protocol XFMyBreakRulesDetailViewDelegate<NSObject>

@optional

- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickWxBtn:(UIButton *)button;
- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickZfbBtn:(UIButton *)button;
- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickCommitBtn:(UIButton *)button;

@end

@class XFBreakRuleModel;
@interface XFMyBreakRulesDetailView : UIView

@property (nonatomic, weak) UILabel *totalMoneyLabel2;
@property (nonatomic, weak) UILabel *koufenLabel2;
@property (nonatomic, weak) UIImageView *imv;
@property (nonatomic, weak) UILabel *fdInfoLabel2;
@property (nonatomic, weak) UILabel *startPoLabel2;
@property (nonatomic, weak) UILabel *endPoLabel2;
@property (nonatomic, weak) UILabel *totalTimeLabel2;
@property (nonatomic, weak) UILabel *stopTimeLabel2;
@property (nonatomic, weak) UILabel *totalMileLabel2;
@property (nonatomic, weak) UIButton *wxBtn;
@property (nonatomic, weak) UIButton *zfbBtn;
@property (nonatomic, weak) UIButton *commitBtn;


@property (nonatomic, strong) XFBreakRuleModel *model;
@property (nonatomic, weak) id<XFMyBreakRulesDetailViewDelegate> delegate;


@end
