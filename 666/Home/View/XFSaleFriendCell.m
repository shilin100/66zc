//
//  XFSaleFriendCell.m
//  666
//
//  Created by xiaofan on 2017/10/18.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSaleFriendCell.h"
#import "XFMemberModel.h"

@interface XFSaleFriendCell()
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *nameLbl;
@property (nonatomic, weak) UILabel *numLbl;
@end

@implementation XFSaleFriendCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WHITECOLOR;
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.layer.cornerRadius = 45*SCALE_HEIGHT;
        icon.clipsToBounds = YES;
//        icon.image = IMAGENAME(@"icon_temp");
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        icon.sd_layout
        .leftSpaceToView(self.contentView, 20*SCALE_WIDTH)
        .heightIs(90*SCALE_HEIGHT)
        .widthEqualToHeight()
        .centerYEqualToView(self.contentView);
        
        UILabel *nameLbl = [[UILabel alloc] init];
//        nameLbl.text = @"张三";
        nameLbl.font = XFont(13);
        nameLbl.textColor = HEXCOLOR(@"333333");
        [self.contentView addSubview:nameLbl];
        self.nameLbl = nameLbl;
        
        nameLbl.sd_layout
        .topEqualToView(icon)
        .leftSpaceToView(icon, 20*SCALE_WIDTH)
        .heightRatioToView(icon, 0.5)
        .rightEqualToView(self.contentView);
        
        UILabel *numLbl = [[UILabel alloc] init];
//        numLbl.text = @"编号：0001";
        numLbl.font = XFont(12);
        numLbl.textColor = HEXCOLOR(@"#999999");
        [self.contentView addSubview:numLbl];
        self.numLbl = numLbl;
        
        numLbl.sd_layout
        .topSpaceToView(nameLbl, 0)
        .leftEqualToView(nameLbl)
        .bottomEqualToView(icon)
        .rightEqualToView(nameLbl);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBCOLORe(221);
        [self.contentView addSubview:line];
        line.sd_layout
        .leftEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(0.5);
        
        
        
    }
    return self;
}

-(void)setModel:(XFMemberModel *)model
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:IMAGENAME(@"morentouxiang")];
    self.nameLbl.text=model.username;
    self.numLbl.text=[NSString stringWithFormat:@"消费总额: %@元",model.pay_moneys];
}



@end
