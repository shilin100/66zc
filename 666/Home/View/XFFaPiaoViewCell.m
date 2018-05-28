//
//  XFFaPiaoViewCell.m
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFFaPiaoViewCell.h"
#import "XFFaPiaoModel.h"

@implementation XFFaPiaoViewCell

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
    
        UILabel *timeLabel = [[UILabel alloc] init];
        //        timeLabel.backgroundColor=[UIColor redColor];
        timeLabel.font = XFont(13);
        timeLabel.textColor = HEXCOLOR(@"999999");
//        timeLabel.text = @"2017.10.30 12:12:12";
        [self.contentView addSubview:timeLabel];
        self.timeLabel=timeLabel;
        timeLabel.sd_layout
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(180);
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        //        moneyLabel.backgroundColor=[UIColor redColor];
        moneyLabel.textAlignment=NSTextAlignmentRight;
        moneyLabel.font = XFont(13);
        moneyLabel.textColor = BLACKCOLOR;
//        moneyLabel.text = @"200";
        self.moneyLabel=moneyLabel;
        [self.contentView addSubview:moneyLabel];
        moneyLabel.sd_layout
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(100);
        
    }
    return self;
}

-(void)setModel:(XFFaPiaoModel *)model
{
    
    _timeLabel.text=model.time;
    _moneyLabel.text=model.money;


}


@end
