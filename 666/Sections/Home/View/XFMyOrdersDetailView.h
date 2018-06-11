//
//  XFMyOrdersDetailView.h
//  666
//
//  Created by TDC_MacMini on 2017/12/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMyOrdersDetailView;
@protocol XFMyOrdersDetailViewDelegate<NSObject>

@optional

- (void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickTicketBtn:(UIButton *)button;
- (void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickWxBtn:(UIButton *)button;
- (void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickZfbBtn:(UIButton *)button;
- (void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickPayBtn:(UIButton *)button;

@end



@interface XFMyOrdersDetailView : UIView

@property (nonatomic, weak) UILabel *totalMoneyLabel2;
@property (nonatomic, weak) UILabel *cphLabel2;
@property (nonatomic, weak) UILabel *startPoLabel2;
@property (nonatomic, weak) UILabel *endPoLabel2;
@property (nonatomic, weak) UILabel *totalTimeLabel2;
//@property (nonatomic, weak) UILabel *stopTimeLabel2;
@property (nonatomic, weak) UILabel *totalMileLabel2;
@property (nonatomic, weak) UILabel *bxMoLabel2;
@property (nonatomic, weak) UILabel *mileMoLabel2;
@property (nonatomic, weak) UILabel *stopMoLabel2;
@property (nonatomic, weak) UILabel *realPayMoLabel2;
@property (nonatomic, weak) UILabel *startTimeLabel2;
@property (nonatomic, weak) UILabel *endTimeLabel2;
@property (nonatomic, weak) UILabel *creditsLabel2;


@property (nonatomic, weak) UILabel *ticketLabel2;
@property (nonatomic, strong) UIButton *wxBtn;
@property (nonatomic, strong) UIButton *zfbBtn;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, weak) id<XFMyOrdersDetailViewDelegate> delegate;

@end
