//
//  XFRecommendIconCollectionViewCell.m
//  666
//
//  Created by 123 on 2018/6/26.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRecommendIconCollectionViewCell.h"

@implementation XFRecommendIconCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITECOLOR;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = XFont(9);
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = MAINGREEN;
        contentLabel.numberOfLines = 1;
        [self addSubview:contentLabel];
        contentLabel.sd_layout
        .bottomSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(22);
        self.titleLabel = contentLabel;
        
        UIImageView * icon = [[UIImageView alloc]init];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:icon];
        icon.sd_layout
        .heightIs(52)
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 5)
        .topSpaceToView(self, 10);
        
        icon.layer.cornerRadius = 26;
        icon.clipsToBounds = YES;

        
        self.icon = icon;
        
    }
    return self;
}


@end
