//
//  XFUseTicketCell.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUseTicketCell.h"
#import "XFUseTicketModel.h"

@interface XFUseTicketCell ()

@end

@implementation XFUseTicketCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        // 类型
        UILabel *typeLbl = [[UILabel alloc] init];
        typeLbl.font = XFont(13);
        typeLbl.textColor = HEXCOLOR(@"#999999");
//        typeLbl.text = @"满减券";
        typeLbl.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:typeLbl];
        self.typeLbl = typeLbl;
        
        [typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_equalTo(@50);
        }];
        
        
        UIImageView *imv=[[UIImageView alloc] init];
        imv.image=IMAGENAME(@"youhuiquan-quan");
//        imv.contentMode=UIViewContentModeCenter;
        [self.contentView addSubview:imv];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.mas_equalTo(@70);
        }];
        
        UILabel *moneyLbl = [[UILabel alloc] init];
        moneyLbl.font = XFont(13);
        moneyLbl.textAlignment=NSTextAlignmentLeft;
        moneyLbl.textColor = LYColor(249, 141, 40);
        //        moneyLbl.text = @"￥10";
        [imv addSubview:moneyLbl];
        self.moneyLbl = moneyLbl;
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imv.mas_centerX).offset(-5);
            make.centerY.mas_equalTo(imv.mas_centerY);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@20);
        }];
        
        //规则
        UILabel *ruleLbl = [[UILabel alloc] init];
        ruleLbl.font = XFont(13);
        ruleLbl.textColor = HEXCOLOR(@"#999999");
        //        ruleLbl.text = @"满20元使用";
//        ruleLbl.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:ruleLbl];
        self.ruleLbl = ruleLbl;
        [ruleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(imv.mas_left).offset(-10);
            make.width.mas_equalTo(@150);
        }];
        
    }
    return self;
}


-(void)setModel:(XFUseTicketModel *)model{
    _model = model;
    self.typeLbl.text = model.cou_type;
    self.ruleLbl.text = model.rule;
    self.moneyLbl.text = [NSString stringWithFormat:@"￥%.2f",model.money];
    
}

@end
