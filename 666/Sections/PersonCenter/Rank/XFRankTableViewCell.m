//
//  XFRankTableViewCell.m
//  666
//
//  Created by 123 on 2018/6/23.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRankTableViewCell.h"


@implementation XFRankTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * rankLabel = [UILabel new];
        rankLabel.font = XFont(17);
        rankLabel.textColor = BlACKTEXT;
        rankLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:rankLabel];
        self.rankLabel = rankLabel;
        
        rankLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .widthIs(30)
        .leftSpaceToView(self.contentView, 8)
        .heightIs(30);

        
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:icon];
        self.icon = icon;
        icon.sd_layout
        .centerYEqualToView(self.contentView)
        .widthIs(36)
        .leftSpaceToView(rankLabel, 6)
        .heightIs(36);
        icon.clipsToBounds = YES;
        
        UIImageView * rankImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        rankImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:rankImg];
        self.rankImg = rankImg;
        rankImg.alpha = 0;
        
        
        
        UILabel * contentLabel = [UILabel new];
        contentLabel.font = XFont(12);
        contentLabel.textColor = BlACKTEXT;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        contentLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .widthIs(100)
        .leftSpaceToView(self.contentView, 85)
        .heightIs(30);

        UILabel * detailLabel = [UILabel new];
        detailLabel.font = XFont(12);
        detailLabel.textColor = MAINGREEN;
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        detailLabel.textAlignment = NSTextAlignmentRight;
        
        detailLabel.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 18)
        .leftSpaceToView(contentLabel, 20)
        .heightIs(30);

        
    }
    return self;
}

-(void)setParams:(NSDictionary*)params RankType:(int)ranktype{
    
    int rank = [params[@"paiming"] intValue];
    int rankIndex = rank - 1;
    
    if (rank <= 3) {
        self.icon.sd_layout
        .centerYEqualToView(self.contentView)
        .widthIs(48)
        .leftSpaceToView(self.contentView, 20)
        .heightIs(48);
        self.icon.layer.cornerRadius = 24;
        self.rankLabel.alpha = 0;
        self.rankImg.alpha = 1;
        
        self.rankImg.sd_layout
        .topEqualToView(self.icon)
        .widthIs(28)
        .leftEqualToView(self.icon)
        .heightIs(25);
        
        NSArray * rankImgName = @[@"NO.1",@"NO.2",@"NO.3"];
        self.rankImg.image = [UIImage imageNamed:rankImgName[rankIndex]];
        
        self.contentLabel.font = XFont(16);
        
        NSArray * detailColor = @[HEXCOLOR(@"#F42424"),HEXCOLOR(@"#EB7F0B"),HEXCOLOR(@"#F0D80D")];
        self.detailLabel.textColor = detailColor[rankIndex];

    }else{
        self.rankLabel.alpha = 1;
        self.rankImg.alpha = 0;

        self.icon.sd_layout
        .centerYEqualToView(self.contentView)
        .widthIs(36)
        .leftSpaceToView(self.rankLabel, 6)
        .heightIs(36);
        self.icon.layer.cornerRadius = 18;

        self.contentLabel.font = XFont(12);
        self.detailLabel.textColor = MAINGREEN;
    }
    
    NSArray * ranktypes = @[@"singtimes",@"sum_time",@"distance",@"pay_money"];

    
    self.rankLabel.text = [NSString stringWithFormat:@"%d",rank];
    self.contentLabel.text = params[@"username"];
    
    self.detailLabel.text = params[ranktypes[ranktype]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:params[@"headimg"]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
