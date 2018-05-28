//
//  XFUseTicketController.h
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFUseTicketModel;
typedef void(^selectedTicketBlock)(XFUseTicketModel *ticketModel);



@interface XFUseTicketController : UIViewController
@property (nonatomic, assign) float orderMoney;
@property (weak, nonatomic) IBOutlet UIButton *useTicketBtn;
@property (nonatomic, copy) selectedTicketBlock ticketBlock;
@property (nonatomic, assign) BOOL isUnuse;
@end
