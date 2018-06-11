//
//  XFScoreDetailCell.m
//  666
//
//  Created by xiaofan on 2017/10/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFScoreDetailCell.h"

@interface XFScoreDetailCell()

@end

@implementation XFScoreDetailCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(15);
        titleLbl.textColor = HEXCOLOR(@"333333");
//        titleLbl.text = @"积分";
        [self.contentView addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        UILabel *timeLbl = [[UILabel alloc] init];
        timeLbl.font = XFont(12);
        timeLbl.textColor = HEXCOLOR(@"999999");
        [self.contentView addSubview:timeLbl];
        self.timeLbl = timeLbl;
        
        UILabel *statusLbl = [[UILabel alloc] init];
        statusLbl.font = XFont(17);
        statusLbl.textColor = MAINGREEN;
        statusLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statusLbl];
        self.statusLbl = statusLbl;
        
        statusLbl.sd_layout
        .topEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*SCALE_WIDTH)
        .bottomEqualToView(self.contentView)
        .widthRatioToView(self.contentView, 0.5);
        
        titleLbl.sd_layout
        .topEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*SCALE_WIDTH)
        .rightSpaceToView(statusLbl, 0)
        .heightRatioToView(self.contentView, 0.5);
        
        timeLbl.sd_layout
        .topSpaceToView(titleLbl, 0)
        .leftEqualToView(titleLbl)
        .rightEqualToView(titleLbl)
        .bottomSpaceToView(self.contentView, 0);
        
    }
    return self;
}
@end
