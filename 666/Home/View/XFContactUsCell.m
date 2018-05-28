//
//  XFContactUsCell.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFContactUsCell.h"


@implementation XFContactUsCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(12.5);
        titleLbl.textColor = HEXCOLOR(@"333333");
        [self.contentView addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.contentMode = UIViewContentModeCenter;
        arrow.image = IMAGENAME(@"arrow_right");
        [self.contentView addSubview:arrow];
        self.arrow=arrow;
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@(78*SCALE_WIDTH));
        }];
        
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@(55*SCALE_WIDTH));
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(icon.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(arrow.mas_left);
        }];
        
    }
    return self;
}

@end
