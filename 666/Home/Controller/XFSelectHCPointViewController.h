//
//  XFSelectHCPointViewController.h
//  666
//
//  Created by TDC_MacMini on 2017/11/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFSelectHCPointViewPassValueDelegate <NSObject>

@optional
- (void) SelectHCPointViewPassValue:(NSString *)str type:(NSString *)type;

@end

@interface XFSelectHCPointViewController : UIViewController

@property(nonatomic,weak) id<XFSelectHCPointViewPassValueDelegate> passValueDelegate;

@property (nonatomic,strong)NSString *selectType;

@end
