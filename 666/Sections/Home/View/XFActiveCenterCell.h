//
//  XFActiveCenterCell.h
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFActiveListModel.h"

@interface XFActiveCenterCell : UITableViewCell

@property (nonatomic, weak) UIImageView *imv;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * overdueLabel;
@property (nonatomic, weak) XFActiveListModel * model;



@end
