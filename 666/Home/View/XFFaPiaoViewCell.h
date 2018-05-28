//
//  XFFaPiaoViewCell.h
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFFaPiaoModel;
@interface XFFaPiaoViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)XFFaPiaoModel *model;


@end
