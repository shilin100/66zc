//
//  XFMyTicketCell.h
//  666
//
//  Created by xiaofan on 2017/10/18.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFCardBagModel.h"

@class XFUseTicketModel;
@interface XFMyTicketCell : UITableViewCell
@property (nonatomic, strong) XFUseTicketModel *ticketModel;
@property (nonatomic, strong) XFCardBagModel *cardModel;

@end
