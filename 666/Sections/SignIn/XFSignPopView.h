//
//  XFSignPopView.h
//  666
//
//  Created by 123 on 2018/5/16.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSignInModel.h"

typedef void(^DrawBlock)();

@interface XFSignPopView : UIView
@property (nonatomic,copy) DrawBlock drawBlock;
@property (nonatomic,strong) XFSignInModel* model;

@property(nonatomic,weak)UILabel * signInCountLabel;
- (void)show;

@end
