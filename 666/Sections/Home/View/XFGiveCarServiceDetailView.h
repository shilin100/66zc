//
//  XFGiveCarServiceDetailView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFGiveCarServiceModel;
@interface XFGiveCarServiceDetailView : UIView

@property (nonatomic, weak) UILabel *areaLabel2;
@property (nonatomic, weak) UILabel *addressLabel2;
@property (nonatomic, weak) UILabel *carTypeLabel2;
@property (nonatomic, weak) UILabel *timeLabel2;
@property (nonatomic, weak) UILabel *peopleLabel2;
@property (nonatomic, weak) UILabel *phoneLabel2;
@property (nonatomic, weak) UILabel *djLabel2;
@property (nonatomic, weak) UILabel *syMoneyLabel2;

@property (nonatomic,strong) XFGiveCarServiceModel *model;

@end
