//
//  XFPrizeListCell.m
//  666
//
//  Created by 123 on 2018/5/14.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFPrizeListCell.h"

@implementation XFPrizeListCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITECOLOR;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = XFont(14);
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = MAINGREEN;
        contentLabel.numberOfLines = 1;
        [self addSubview:contentLabel];
        contentLabel.sd_layout
        .bottomSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(30);
        self.titleLabel = contentLabel;
        
        UIImageView * icon = [[UIImageView alloc]init];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:icon];
        icon.sd_layout
        .bottomSpaceToView(contentLabel, 10)
        .leftSpaceToView(self, 20)
        .rightSpaceToView(self, 20)
        .topSpaceToView(self, 10);
        self.icon = icon;

    }
    return self;
}

-(void)setModel:(XFPrizeListModel *)model{
    _model = model;
    self.titleLabel.text = model.content;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image]];
}

@end
