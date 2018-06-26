//
//  XFRefundCashTableViewCell.m
//  666
//
//  Created by 123 on 2018/6/23.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRefundCashTableViewCell.h"

@implementation XFRefundCashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        BEMCheckBox *myCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.contentView addSubview:myCheckBox];
        myCheckBox.on = NO;
        myCheckBox.onTintColor = MAINGREEN;
        myCheckBox.onCheckColor = MAINGREEN;
        myCheckBox.onAnimationType =  BEMAnimationTypeOneStroke;
        myCheckBox.offAnimationType =  BEMAnimationTypeOneStroke;
        self.checkBox = myCheckBox;
        
        myCheckBox.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 15)
        .heightIs(15)
        .widthIs(15);
        
        UILabel * contentLabel = [UILabel new];
        contentLabel.font = XFont(13);
        contentLabel.textColor = BlACKTEXT;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        contentLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 18)
        .leftSpaceToView(myCheckBox, 8)
        .heightIs(30);

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
