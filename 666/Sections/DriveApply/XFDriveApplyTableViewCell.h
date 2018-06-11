//
//  XFDriveApplyTableViewCell.h
//  666
//
//  Created by 123 on 2018/5/2.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFDriverApplyModel.h"
#import "XFApplyOrderModel.h"
typedef void(^ApplyCellBlock)(id model);

@interface XFDriveApplyTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imv;
@property (nonatomic,strong) UILabel *jiaolianLabel;
@property (nonatomic,strong) UILabel *areaLabel2;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *schoolLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,strong) UIView *rowLine;

@property (nonatomic,strong) UIButton *applyBtn;
@property (nonatomic,strong) UIView *grayBg;


@property(nonatomic,strong)XFDriverApplyModel * model;
@property(nonatomic,strong)XFApplyOrderModel * orderModel;
@property (nonatomic, copy) ApplyCellBlock applyCellBlock;

@end
