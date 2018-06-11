//
//  XFActiveCenterCell.m
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFActiveCenterCell.h"

@implementation XFActiveCenterCell

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
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.backgroundColor=MAINGREEN;
        imageView.layer.cornerRadius=5;
        imageView.clipsToBounds=YES;
        [self.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
        self.imv = imageView;
        
        imageView.sd_layout
        .topSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView, 15)
        .leftSpaceToView(self.contentView, 15);
    
        UILabel *nameTitle = [[UILabel alloc] init];
        nameTitle.backgroundColor = WHITECOLOR;
        nameTitle.font = XFont(14);
        nameTitle.textColor = BlACKTEXT;
        [self.contentView addSubview:nameTitle];
        self.titleLabel = nameTitle;
        
        nameTitle.sd_layout
        .topSpaceToView(imageView, 0)
        .leftSpaceToView(self.contentView, 15)
        .heightIs(30)
        .rightSpaceToView(self.contentView, 80);

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = WHITECOLOR;
        timeLabel.font = XFont(14);
        timeLabel.textColor = BlACKTEXT;
        [self.contentView addSubview:timeLabel];
                self.timeLabel = timeLabel;
        
        timeLabel.sd_layout
        .topSpaceToView(nameTitle, 0)
        .leftSpaceToView(self.contentView, 15)
        .heightIs(30)
        .rightSpaceToView(self.contentView, 80);

        UILabel *overdueLabel = [[UILabel alloc] init];
        overdueLabel.backgroundColor = WHITECOLOR;
        overdueLabel.font = XFont(14);
        overdueLabel.textColor = GRAYTEXT;
        [self.contentView addSubview:overdueLabel];
        overdueLabel.layer.borderColor = GRAYTEXT.CGColor;
        overdueLabel.layer.borderWidth = 1;
        overdueLabel.text = @"活动过期";
        overdueLabel.textAlignment = NSTextAlignmentCenter;
        self.overdueLabel = overdueLabel;
        
        overdueLabel.sd_layout
        .centerYEqualToView(timeLabel)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(30)
        .widthIs(70);
        
        UIView * bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = GRAYBACKGROUND;
        [self.contentView addSubview:bottomView];
        
        bottomView.sd_layout
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(20)
        .leftSpaceToView(self.contentView, 0);

    }
    return self;
}

-(void)setModel:(XFActiveListModel *)model{
    _model = model;
    self.titleLabel.text = [self getZZwithString:model.describe];
    self.timeLabel.text = [NSString stringWithFormat:@"过期时间:%@",model.end_time];
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.image]];

    if ([model.overdue_info isEqualToString:@"0"]) {
        self.overdueLabel.sd_layout
        .heightIs(30);
    }else{
        self.overdueLabel.sd_layout
        .heightIs(0);
    }
}

-(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n|&nbsp" options:0 error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

@end
