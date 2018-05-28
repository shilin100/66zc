//
//  XFSCFWAlertView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/28.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelItemBlock)();
typedef void(^sureItemBlock)();

@class XFSCFWAlertView;
@protocol XFSCFWAlertViewDelegate<NSObject>

@optional

- (void)XFSCFWAlertView:(XFSCFWAlertView *)contentView didClickSureBtn:(UIButton *)button;
@end



@interface XFSCFWAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title;

- (void) show;
- (void) hide;


@property (nonatomic, copy) cancelItemBlock cancelBlock;
@property (nonatomic, copy) sureItemBlock sureBlock;

@property (nonatomic, weak) id<XFSCFWAlertViewDelegate> delegate;

@end
