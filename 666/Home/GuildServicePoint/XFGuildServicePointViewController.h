//
//  XFGuildServicePointViewController.h
//  666
//
//  Created by 123 on 2018/4/27.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSelectHCPointModel.h"

@interface XFGuildServicePointViewController : UIViewController

@property(nonatomic,strong)NSString * sid;
@property(nonatomic,strong)BMKUserLocation *userLocation;
@property(nonatomic, strong) XFSelectHCPointModel *model;



@end
