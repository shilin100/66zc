//
//  XFAlertViewThree.h
//  666
//
//  Created by TDC_MacMini on 2018/2/23.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertThreeButtonTypeCancel = 100,
    AlertThreeButtonTypeSure,
} AlertThreeButtonType;

typedef void(^AlertThreeResult)(AlertThreeButtonType type);

@interface XFAlertViewThree : UIView

@property (nonatomic,copy) AlertThreeResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title messageOne:(NSString *)messageOne
                      messageTwo:(NSString *)messageTwo sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showAlertView;

@end
