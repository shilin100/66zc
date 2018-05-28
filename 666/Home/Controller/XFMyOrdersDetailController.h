//
//  XFMyOrdersDetailController.h
//  666
//
//  Created by TDC_MacMini on 2017/12/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMyOrderModel;
@class XFCar_endModel;

@interface XFMyOrdersDetailController : UIViewController

@property (nonatomic, strong) XFMyOrderModel *model;
@property (nonatomic, strong) XFCar_endModel *endModel;
@property (nonatomic, strong) NSString *typeStr;

@end
