//
//  XFSelectHCPointTableViewCell.m
//  666
//
//  Created by TDC_MacMini on 2017/11/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSelectHCPointTableViewCell.h"

@implementation XFSelectHCPointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = XFont(15);
//        label.text=@"洪山区";
        label.textColor = HEXCOLOR(@"999999");
        [self.contentView addSubview:label];
        self.label = label;
        
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.font = XFont(13);
//        subLabel.text=@"光谷国际广场";
        subLabel.textColor = HEXCOLOR(@"999999");
        [self.contentView addSubview:subLabel];
        self.subLabel = subLabel;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.height.equalTo(@20);
        }];
        
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.label.mas_bottom).offset(2);
            make.height.equalTo(@20);
            
        }];
        
    }
    return self;
}

@end
