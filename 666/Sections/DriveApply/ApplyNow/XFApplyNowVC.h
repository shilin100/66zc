//
//  XFApplyNowVC.h
//  666
//
//  Created by 123 on 2018/5/8.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFDriverApplyModel.h"
typedef void(^ApplyNowBlock)();

@interface XFApplyNowVC : UIViewController
@property(nonatomic,weak)XFDriverApplyModel * model;
@property (nonatomic, copy) ApplyNowBlock applyNowBlock;

@end
