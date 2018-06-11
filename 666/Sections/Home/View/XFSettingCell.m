//
//  XFSettingCell.m
//  666
//
//  Created by TDC_MacMini on 2018/1/27.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSettingCell.h"

@implementation XFSettingCell

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
        
        UILabel *titleLbl2 = [[UILabel alloc] init];
        titleLbl2.textAlignment=NSTextAlignmentRight;
        titleLbl2.font = XFont(12.5);
        titleLbl2.textColor = HEXCOLOR(@"333333");
        [self.contentView addSubview:titleLbl2];
        self.titleLbl2 = titleLbl2;
        
//        UIImageView *arrow = [[UIImageView alloc] init];
//        arrow.contentMode = UIViewContentModeCenter;
//        arrow.image = IMAGENAME(@"arrow_right");
//        [self.contentView addSubview:arrow];
//        self.arrow=arrow;
//
//        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top);
//            make.right.equalTo(self.contentView.mas_right);
//            make.bottom.equalTo(self.contentView.mas_bottom);
//            make.width.mas_equalTo(@(55*SCALE_WIDTH));
//        }];
        
        
        
//        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top);
//            make.left.equalTo(self.contentView.mas_left);
//            make.bottom.equalTo(self.contentView.mas_bottom);
//            make.width.mas_equalTo(@(78*SCALE_WIDTH));
//        }];
        
        [titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@(150*SCALE_WIDTH));
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).with.offset(16);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(titleLbl2.mas_left);
        }];
        
    }
    return self;
}


@end
