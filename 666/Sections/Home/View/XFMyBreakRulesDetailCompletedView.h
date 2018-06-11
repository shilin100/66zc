//
//  XFMyBreakRulesDetailCompletedView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFBreakRuleModel;
@interface XFMyBreakRulesDetailCompletedView : UIView


@property (nonatomic, weak) UILabel *totalMoneyLabel2;
@property (nonatomic, weak) UILabel *koufenLabel2;
@property (nonatomic, weak) UIImageView *imv;
@property (nonatomic, weak) UILabel *fdInfoLabel2;
@property (nonatomic, weak) UILabel *startPoLabel2;
@property (nonatomic, weak) UILabel *endPoLabel2;
@property (nonatomic, weak) UILabel *totalTimeLabel2;
@property (nonatomic, weak) UILabel *stopTimeLabel2;
@property (nonatomic, weak) UILabel *totalMileLabel2;

@property (nonatomic, strong) XFBreakRuleModel *model;



@end
