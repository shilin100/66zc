//
//  XFPrizeListCell.h
//  666
//
//  Created by 123 on 2018/5/14.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFPrizeListModel.h"

@interface XFPrizeListCell : UICollectionViewCell
@property(nonatomic,strong)XFPrizeListModel * model;
@property(nonatomic,weak)UIImageView * icon;
@property(nonatomic,weak)UILabel * titleLabel;

@end
