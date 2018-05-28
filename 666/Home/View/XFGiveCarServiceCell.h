//
//  XFGiveCarServiceCell.h
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XFGiveCarServiceCell;
@protocol XFGiveCarServiceCellDelegate<NSObject>

@optional

- (void)XFGiveCarServiceCell:(XFGiveCarServiceCell *)cell didClickUseBtn:(UIButton *)button;
@end




@class XFGiveCarServiceModel;
@interface XFGiveCarServiceCell : UITableViewCell

@property (nonatomic,strong) UIButton *stateBtn;
@property (nonatomic,strong) UIButton *confirmUseCarBtn;
@property (nonatomic,strong) UILabel *nameLabel2;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *timeLabel2;
@property (nonatomic,strong) UILabel *addressLabel2;

@property (nonatomic,strong) XFGiveCarServiceModel *model;
@property (nonatomic, weak) id<XFGiveCarServiceCellDelegate> delegate;


@end


