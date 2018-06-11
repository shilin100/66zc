//
//  XFLeftViewItem.m
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFLeftViewItem.h"

@interface XFLeftViewItem ()
@property (nonatomic, weak) UIImageView *img;
@property (nonatomic, weak) UILabel *titleLbl;
@end

@implementation XFLeftViewItem

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
//        [self addGestureRecognizer:tap];
        self.backgroundColor = CLEARCOLOR;
        UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeCenter;
        [self addSubview:img];
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(13);
        titleLbl.textColor = WHITECOLOR;
        [self addSubview:titleLbl];
        
        self.img = img;
        self.titleLbl = titleLbl;
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20*SCALE_WIDTH);
            make.top.equalTo(self.mas_top);
            make.height.mas_equalTo(@(50*SCALE_WIDTH));
            make.width.mas_equalTo(@(50*SCALE_WIDTH));
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.img.mas_right).offset(24*SCALE_WIDTH);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}
-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.img.image = IMAGENAME(icon);
        self.titleLbl.text = title;
    }
    return self;
}
//- (void) didTap {
//    if (self.itemBlock) {
//        self.itemBlock(self.tag);
//    }
//}
@end
