//
//  XFUseTicketCell.h
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFUseTicketModel;
@interface XFUseTicketCell : UITableViewCell
/**<#desc#>*/
@property (nonatomic, strong) XFUseTicketModel *model;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *ruleLbl;
@property (nonatomic, strong) UILabel *moneyLbl;

@end
