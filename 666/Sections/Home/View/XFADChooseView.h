//
//  XFADChooseView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^topItemBlock)(NSIndexPath *index);

@interface XFADChooseView : UIView

- (instancetype)initWithImageArray:(NSMutableArray *)array;

- (void) show;
- (void) hide;

@property (nonatomic, copy) topItemBlock topBlock;


@end
