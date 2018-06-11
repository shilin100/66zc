//
//  XFHomeUseCarInfoView.h
//  666
//
//  Created by xiaofan on 2017/10/12.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XFHomeUseCarInfoView;
@protocol XFHomeUseCarInfoViewDelegate<NSObject>

@optional
- (void)XFHomeUseCarInfoView:(XFHomeUseCarInfoView *)contentView didClickHCPBtn:(UIButton *)button;
- (void)XFHomeUseCarInfoView:(XFHomeUseCarInfoView *)contentView didClickServicePBtn:(UIButton *)button;


@end




@class XFGetCarPriceModel;
typedef void(^submitBlock)();
typedef void(^costDetailBlock)();

@interface XFHomeUseCarInfoView : UIView
@property (nonatomic, strong) XFGetCarPriceModel *carPriceModel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, weak) UIButton *selectHCPointBtnTwo;
@property (nonatomic, weak) UIButton *selectServicePointBtnTwo;
@property (nonatomic, weak) UIButton *submitBtn;
@property (nonatomic, weak) UIButton *costDetailBtn;

/**<#desc#>*/
@property (nonatomic, copy) submitBlock submitBlock;
@property (nonatomic, copy) costDetailBlock costDetailBlock;
@property (nonatomic, weak) id<XFHomeUseCarInfoViewDelegate> delegate;

-(void)setSubMitBtnDisable:(BOOL)ishideCarNum;

@end
