//
//  XFChooseView.h
//  666
//
//  Created by xiaofan on 2017/11/6.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^topItemBlock)();

typedef void(^bottomItemBlock)(); 

@interface XFChooseView : UIView

@property (nonatomic, weak) UIImageView* topImgV;
@property (nonatomic, weak) UIImageView* bottomImgV;

- (instancetype)initWithTopTitles:(NSArray <NSString *> *)topTitles bottomTitles:(NSArray <NSString *> *)bottomTitles;
- (void) show;
- (void) hide;

/**上部分block*/
@property (nonatomic, copy) topItemBlock topBlock;

/**下部分block*/
@property (nonatomic, copy) bottomItemBlock bottomBlock;

@end
