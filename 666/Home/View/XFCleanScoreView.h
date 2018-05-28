//
//  XFCleanScoreView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XFCleanScoreView;
@protocol XFCleanScoreViewDelegate<NSObject>

@optional

- (void)XFCleanScoreView:(XFCleanScoreView *)contentView didClickPlusBtn:(UIButton *)button;
- (void)XFCleanScoreView:(XFCleanScoreView *)contentView didClickCommitBtn:(UIButton *)button;

@end


@class XFBreakRuleModel;
@interface XFCleanScoreView : UIView

@property (nonatomic, weak) UILabel *totalMoneyLabel2;
@property (nonatomic, weak) UILabel *koufenLabel2;
@property (nonatomic, weak) UILabel *fdInfoLabel2;
@property (nonatomic, weak) UIImageView *imv;
@property (nonatomic, weak) UILabel *startPoLabel2;
@property (nonatomic, weak) UILabel *endPoLabel2;
@property (nonatomic, weak) UILabel *totalTimeLabel2;
@property (nonatomic, weak) UILabel *stopTimeLabel2;
@property (nonatomic, weak) UILabel *totalMileLabel2;
@property (nonatomic, weak) UIButton *plusBtn;


@property (nonatomic, strong) XFBreakRuleModel *model;
@property (nonatomic, weak) id<XFCleanScoreViewDelegate> delegate;

@end
