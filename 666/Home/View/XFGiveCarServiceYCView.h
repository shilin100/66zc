//
//  XFGiveCarServiceYCView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFGiveCarServiceYCView;
@protocol XFGiveCarServiceYCViewDelegate<NSObject>

@optional

- (void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickAreaBtn:(UIButton *)button;

- (void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickTimeBtn:(UIButton *)button;

- (void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickCarBrandBtn:(UIButton *)button;


- (void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickCommitBtn:(UIButton *)button;

@end


@interface XFGiveCarServiceYCView : UIView

@property (nonatomic, strong) UILabel *areaLbl;
@property (nonatomic, strong) UILabel *carTypeLbl;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *carTypeTF;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UITextField *peopleTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *carBrandBtn;


@property (nonatomic, weak) id<XFGiveCarServiceYCViewDelegate> delegate;


@end
