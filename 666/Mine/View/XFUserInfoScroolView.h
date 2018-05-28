//
//  XFUserInfoScroolView.h
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFUserInfoScroolView;
@protocol XFUserInfoScroolViewDelegate<NSObject>

@optional
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickIconBtn:(UIButton *)button;
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickSaveBtn:(UIButton *)button;
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickAreaBtn:(UIButton *)button;
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickFriendBtn:(UIButton *)button;
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickCarCardBtn:(UIButton *)button;
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickCardBtn:(UIButton *)button;

@end


@class XFUserInfoModel;
@interface XFUserInfoScroolView : UIView
/**头像*/
@property (nonatomic, weak) UIButton *iconBtn;
/**名字*/
@property (nonatomic, weak) UITextField *nameTF;
/**性别*/
@property (nonatomic, weak) UILabel *sexLbl;
/**男*/
@property (nonatomic, weak) UIButton *sexManBtn;
/**女*/
@property (nonatomic, weak)  UIButton *sexWomanBtn;
/**手机号*/
@property (nonatomic, weak) UITextField *phoneTF;
/**现居地*/
@property (nonatomic, weak) UILabel *areaLbl;
/**<#desc#>*/
@property (nonatomic, weak) UIButton *areaBtn;
/**详细地址*/
@property (nonatomic, weak) UITextField *addressTF;
/**亲友关系*/
@property (nonatomic, weak) UILabel *friendLbl;
/**<#desc#>*/
@property (nonatomic, weak) UIButton *friendBtn;
/**亲友电话*/
@property (nonatomic, weak) UITextField *friendNumTF;
/**支付宝号*/
@property (nonatomic, weak) UITextField *alipayTF;
////////////////////////////////////////////
/**驾驶证content*/
@property (nonatomic, weak) UIView *carCardContent;
/**标题*/
@property (nonatomic, weak) UILabel *carCardTitle;
/**驾驶证号*/
@property (nonatomic, weak) UITextField *carCardTF;
/**
 上传驾驶证图content
 */
@property (nonatomic, weak) UIView *carCardImgContent;
/**
 上传驾驶证图提示文字
 */
@property (nonatomic, weak) UILabel *carCardImgTitle;

/**添加按钮*/
@property (nonatomic, weak) UIButton *carCardBtn;
/**驾驶证imageView*/
@property (nonatomic, weak) UIImageView *carCardImg;
/////////////////////////////////////////////
/**身份证content*/
@property (nonatomic, weak) UIView *cardContent;
/**标题*/
@property (nonatomic, weak) UILabel *cardTitle;
/**输入身份证号*/
@property (nonatomic, weak) UITextField *cardTF;
/**身份证上传图content*/
@property (nonatomic, weak) UIView *cardImgContent;
/**
 身份证上传图提示文字
 */
@property (nonatomic, weak) UILabel *cardImgTitle;

/**添加*/
@property (nonatomic, weak) UIButton *cardBtn;
/**身份证1*/
@property (nonatomic, weak) UIImageView *cardFrontImg;
/**身份证2*/
@property (nonatomic, weak) UIImageView *cardBackImg;
/////////////////////////////////////////////
/**model*/
@property (nonatomic, strong) XFUserInfoModel *userModel;
////////////////////////////////////////////
/**是否允许编辑*/
@property (nonatomic, assign) BOOL enableEdit;
/**保存按钮*/
@property (nonatomic, weak) UIButton *saveBtn;

/**delegete*/
@property (nonatomic, weak) id<XFUserInfoScroolViewDelegate> delegate;
@end
