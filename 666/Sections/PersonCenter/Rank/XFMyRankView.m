//
//  XFMyRankView.m
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFMyRankView.h"

@implementation XFMyRankView


-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = HEXCOLOR(@"#ADF6C1");
        UILabel * rankLabel = [UILabel new];
        rankLabel.font = XFont(17);
        rankLabel.textColor = BlACKTEXT;
        rankLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rankLabel];
        self.rankLabel = rankLabel;
        
        rankLabel.sd_layout
        .centerYEqualToView(self)
        .widthIs(30)
        .leftSpaceToView(self, 8)
        .heightIs(30);
        
        
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:icon];
        self.icon = icon;
        icon.sd_layout
        .centerYEqualToView(self)
        .widthIs(48)
        .leftSpaceToView(rankLabel, 0)
        .heightIs(48);
        icon.clipsToBounds = YES;
        icon.layer.cornerRadius = 24;

        UIImageView * rankImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        rankImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:rankImg];
        self.rankImg = rankImg;
        rankImg.alpha = 0;

        
        UILabel * contentLabel = [UILabel new];
        contentLabel.font = XFont(12);
        contentLabel.textColor = BlACKTEXT;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        contentLabel.sd_layout
        .centerYEqualToView(self)
        .widthIs(100)
        .leftSpaceToView(self, 90)
        .heightIs(30);
        
        UILabel * detailLabel = [UILabel new];
        detailLabel.font = XFont(12);
        detailLabel.textColor = MAINGREEN;
        [self addSubview:detailLabel];
        self.detailLabel = detailLabel;
        detailLabel.textAlignment = NSTextAlignmentRight;
        
        detailLabel.sd_layout
        .centerYEqualToView(self)
        .rightSpaceToView(self, 18)
        .leftSpaceToView(contentLabel, 20)
        .heightIs(30);
        

    }
    
    return self;
}

-(void)setParams:(NSDictionary*)params RankType:(int)ranktype{
    
    int rank = [params[@"mypaiming"] intValue];
    int rankIndex = rank - 1;
    
    if (rank <= 3) {
        self.rankImg.alpha = 1;
        self.rankImg.sd_layout
        .topEqualToView(self.icon)
        .widthIs(28)
        .leftEqualToView(self.icon)
        .heightIs(25);
        
        NSArray * rankImgName = @[@"NO.1",@"NO.2",@"NO.3"];
        self.rankImg.image = [UIImage imageNamed:rankImgName[rankIndex]];
        
        NSArray * detailColor = @[HEXCOLOR(@"#F42424"),HEXCOLOR(@"#EB7F0B"),HEXCOLOR(@"#F0D80D")];
        self.detailLabel.textColor = detailColor[rankIndex];
        self.rankLabel.textColor = detailColor[rankIndex];

    }else{
        self.rankImg.alpha = 0;
        
        self.detailLabel.textColor = MAINGREEN;
        self.rankLabel.textColor = BlACKTEXT;

    }

    NSArray * ranktypes = @[@"mysingtimes",@"mysum_time",@"mydistance",@"mypay_money"];
    
    self.rankLabel.text = [NSString stringWithFormat:@"%d",rank];
    self.contentLabel.text = params[@"myusername"];
    
    self.detailLabel.text = params[ranktypes[ranktype]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:params[@"myheadimg"]]];
}


@end
