//
//  XFMySaleMoneyGetView.h
//  666
//
//  Created by TDC_MacMini on 2017/12/7.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFMySaleMoneyGetView;
@protocol XFMySaleMoneyGetViewDelegate<NSObject>
@optional

- (void)XFMySaleMoneyGetView:(XFMySaleMoneyGetView *)contentView didClickCommitBtn:(UIButton *)button;

@end


@interface XFMySaleMoneyGetView : UIView

@property (nonatomic, strong) UITextField *moneyTF;
@property (nonatomic, strong) UILabel *yeLabel2;
@property (nonatomic, strong) UILabel *eduLabel2;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, weak) id<XFMySaleMoneyGetViewDelegate> delegate;

@end


