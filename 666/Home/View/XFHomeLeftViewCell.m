//
//  XFHomeLeftViewCell.m
//  666
//
//  Created by TDC_MacMini on 2017/11/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeLeftViewCell.h"

@implementation XFHomeLeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(13);
        titleLbl.textColor = WHITECOLOR;
        [self.contentView addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(20*SCALE_WIDTH);
            make.size.mas_equalTo(CGSizeMake(50*SCALE_WIDTH, 50*SCALE_WIDTH));
            make.centerY.equalTo(self.contentView.mas_centerY);
            
            
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.icon.mas_right).offset(24*SCALE_WIDTH);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
    }
    return self;
}



@end
