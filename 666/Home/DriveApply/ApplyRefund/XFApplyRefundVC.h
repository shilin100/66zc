//
//  XFApplyRefundVC.h
//  666
//
//  Created by 123 on 2018/5/10.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFApplyOrderModel.h"
typedef void(^ApplyRefundSuccess)();

/**<#desc#>*/

@interface XFApplyRefundVC : UIViewController
@property(nonatomic,weak)XFApplyOrderModel * model;
@property (nonatomic, copy) ApplyRefundSuccess loadBlock;

@end
