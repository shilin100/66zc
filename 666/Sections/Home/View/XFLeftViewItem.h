//
//  XFLeftViewItem.h
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftItemBlcok)(NSUInteger flag);
@interface XFLeftViewItem : UIButton
@property (nonatomic, copy) leftItemBlcok itemBlock;
- (instancetype) initWithIcon:(NSString *)icon andTitle:(NSString *)title;
@end
