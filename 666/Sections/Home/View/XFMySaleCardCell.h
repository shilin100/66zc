//
//  XFMySaleCardCell.h
//  666
//
//  Created by 123 on 2018/5/16.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFCardBagModel.h"
typedef void(^MySaleCardCellBlock)(id model);

@interface XFMySaleCardCell : UITableViewCell
@property (nonatomic, strong) XFCardBagModel *cardModel;
@property (nonatomic, copy) MySaleCardCellBlock mySaleCardCellBlock;

@end
