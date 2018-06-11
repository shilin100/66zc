//
//  XFMyOrderDetailCompletedView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/24.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMyOrderDetailCompletedView;
@protocol XFMyOrderDetailCompletedViewDelegate<NSObject>

@optional

- (void)XFMyOrderDetailCompletedView:(XFMyOrderDetailCompletedView *)contentView didClickTripBtn:(UIButton *)button;

@end


@class XFMyOrderModel;
@interface XFMyOrderDetailCompletedView : UIView


@property (nonatomic, weak) UILabel *totalMoneyLabel2;
@property (nonatomic, weak) UILabel *cphLabel2;
@property (nonatomic, weak) UILabel *startPoLabel2;
@property (nonatomic, weak) UILabel *endPoLabel2;
@property (nonatomic, weak) UILabel *totalTimeLabel2;
@property (nonatomic, weak) UILabel *stopTimeLabel2;
@property (nonatomic, weak) UILabel *totalMileLabel2;
@property (nonatomic, weak) UILabel *startTimeLabel2;
@property (nonatomic, weak) UILabel *endTimeLabel2;
@property (nonatomic, weak) UILabel *bxMoLabel2;
@property (nonatomic, weak) UILabel *mileMoLabel2;
@property (nonatomic, weak) UILabel *stopMoLabel2;
@property (nonatomic, weak) UILabel *ticketLabel2;
@property (nonatomic, weak) UILabel *realPayLabel2;
@property (nonatomic, weak) UILabel *creditsLabel2;




@property (nonatomic, strong) XFMyOrderModel *model;
@property (nonatomic, weak) id<XFMyOrderDetailCompletedViewDelegate> delegate;


@end
