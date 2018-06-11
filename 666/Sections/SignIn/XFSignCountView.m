//
//  XFSignCountView.m
//  666
//
//  Created by 123 on 2018/5/11.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSignCountView.h"
@interface XFSignCountView ()
@property(nonatomic,weak)UIView * grayLine;
@property(nonatomic,weak)UIView * greenLine;
@property(nonatomic,weak)UIImageView * leftImg;
@property(nonatomic,weak)UIImageView * midImg;
@property(nonatomic,weak)UIImageView * rightImg;


@end

@implementation XFSignCountView



-(instancetype)init{
    if (self = [super init]) {
        UIView * grayLine = [UIView new];
        grayLine.backgroundColor = RGBCOLOR(180, 180, 180);
        [self addSubview:grayLine];
        self.grayLine = grayLine;
        grayLine.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .centerYEqualToView(self)
        .heightIs(2);
        
        UIImage * tik = [UIImage imageNamed:@"icon_sign_in"];
        
        UIImageView * leftImg = [[UIImageView alloc]initWithImage:tik];
        leftImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:leftImg];
        leftImg.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, 0)
        .heightIs(20)
        .widthEqualToHeight();
        self.leftImg = leftImg;
        
        UIImageView * midImg = [[UIImageView alloc]initWithImage:tik];
        midImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:midImg];
        midImg.sd_layout
        .centerYEqualToView(self)
        .heightIs(20)
        .centerXEqualToView(self)
        .widthEqualToHeight();
        self.midImg = midImg;

        UIImageView * rightImg = [[UIImageView alloc]initWithImage:tik];
        rightImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:rightImg];
        rightImg.sd_layout
        .centerYEqualToView(self)
        .heightIs(20)
        .rightSpaceToView(self, 0)
        .widthEqualToHeight();
        self.rightImg = rightImg;



    }
    return self;
}

-(void)setSigntimes:(int)signtimes{
    _signtimes = signtimes;
    int index = signtimes%3;
    UIImage * tik = [UIImage imageNamed:@"icon_sign_in"];
    UIImage * de_tik = [UIImage imageNamed:@"icon_unsign_in_gift"];
    
    if (!self.greenLine) {
        UIView * greenLine = [UIView new];
        greenLine.backgroundColor = MAINGREEN;
        [self insertSubview:greenLine aboveSubview:self.grayLine];
        self.greenLine = greenLine;
        greenLine.sd_layout
        .leftSpaceToView(self, 0)
        .widthRatioToView(self.grayLine, 1)
        .centerYEqualToView(self)
        .heightIs(2);

    }
    
    self.leftImg.image = tik;
    
    
    switch (index) {
        case 0:
            self.midImg.image = tik;
            self.rightImg.image = tik;
            self.greenLine.sd_layout
            .widthRatioToView(self.grayLine, 1);

            break;
        case 1:
            self.midImg.image = de_tik;
            self.rightImg.image = de_tik;
            self.greenLine.sd_layout
            .widthRatioToView(self.grayLine, 0);

            break;
            
            
        case 2:
            self.midImg.image = tik;
            self.rightImg.image = de_tik;
            self.greenLine.sd_layout
            .widthRatioToView(self.grayLine, 0.5);

            break;

        default:
            break;
    }
    
}

@end
