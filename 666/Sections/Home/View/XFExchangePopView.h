//
//  XFExchangePopView.h
//  666
//
//  Created by 123 on 2018/5/17.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExchangeCheckBlock)();
typedef enum _ExchangeType
{
    ExchangeSuccess = 0,
    ExchangeFail
    
} ExchangeType;
@interface XFExchangePopView : UIView
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)XFExchangePopView * popView;
@property (nonatomic, copy) ExchangeCheckBlock exchangeCheckBlock;

-(void)show;
-(instancetype)initWithTitle:(NSString*)title Msg:(NSString*)msg ExchangType:(ExchangeType)type;
@end
