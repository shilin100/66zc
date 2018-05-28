//
//  XFMySaleCardCell.m
//  666
//
//  Created by 123 on 2018/5/16.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFMySaleCardCell.h"

@interface XFMySaleCardCell ()

/**BG*/
@property (nonatomic, weak) UIImageView *bg;
/** 金额*/
@property (nonatomic, weak) UILabel *priceLbl;
/**标题*/
@property (nonatomic, weak) UILabel *titleLbl;
/**描述*/
@property (nonatomic, weak) UILabel *infoLbl;
/**时间*/
@property (nonatomic, weak) UILabel *timeLbl;
/**状态*/
@property (nonatomic, weak) UILabel *statusLbl;

@property (nonatomic, weak) UIImageView *imv;

@end

@implementation XFMySaleCardCell

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
        self.contentView.backgroundColor = HEXCOLOR(@"#eeeeee");
        
        // 背景图
        UIImageView *bg = [[UIImageView alloc] init];
        bg.contentMode = UIViewContentModeScaleToFill;
        //        bg.image = IMAGENAME(@"youhuiquan-weishiyong");
        [self.contentView addSubview:bg];
        self.bg = bg;
        
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(11);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        // 金额
        UILabel *priceLbl = [[UILabel alloc] init];
        priceLbl.font = [UIFont fontWithName:@"FZZYJW--GB1-0" size:30.f];
        priceLbl.textColor = MAINGREEN;
        priceLbl.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:priceLbl];
        self.priceLbl = priceLbl;
        
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg.mas_top).offset(5.5);
            make.left.equalTo(bg.mas_left).offset(20);
            make.height.mas_equalTo(@(53.5));
            make.width.mas_equalTo(@(180));
        }];
        
        // 描述2
        UILabel *infoLbl = [[UILabel alloc] init];
        infoLbl.font = XFont(12);
        //        infoLbl.text = @"每单满6元即可立减6元";
        infoLbl.textColor = HEXCOLOR(@"#666666");
        [bg addSubview:infoLbl];
        self.infoLbl = infoLbl;
        
        [infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLbl.mas_bottom).offset(0);
            make.left.equalTo(priceLbl.mas_left);
            make.height.mas_equalTo(@17.5);
            make.right.equalTo(priceLbl.mas_right).offset(-10);
        }];
        
        UIImageView *imv=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [bg addSubview:imv];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        self.imv=imv;
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg.mas_top).offset(20);
            make.right.equalTo(bg.mas_right).offset(-20);
            make.bottom.equalTo(bg.mas_bottom).offset(-30);
            make.left.equalTo(priceLbl.mas_right).offset(20);
        }];
        
        
        // 状态
        UILabel *statusLbl = [[UILabel alloc] init];
        statusLbl.font = XFont(12);
        //        statusLbl.text = @"未使用";
        statusLbl.textColor = HEXCOLOR(@"#999999");
        statusLbl.textAlignment = NSTextAlignmentRight;
        [bg addSubview:statusLbl];
        self.statusLbl = statusLbl;
        
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bg.mas_right).offset(-11);
            make.bottom.equalTo(bg.mas_bottom);
            make.height.mas_equalTo(@33.5);
            make.width.mas_equalTo(@45);
        }];
        
        
        // 时间
        UILabel *timeLbl = [[UILabel alloc] init];
        //        timeLbl.text = @"有效时间:2017-08-01至2017-08-31";
        timeLbl.textAlignment = NSTextAlignmentLeft;
        timeLbl.font = XFont(12);
        timeLbl.textColor = HEXCOLOR(@"#999999");
        [bg addSubview:timeLbl];
        self.timeLbl = timeLbl;
        
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bg.mas_left).offset(12.5);
            make.bottom.equalTo(bg.mas_bottom);
            make.height.mas_equalTo(@33.5);
            make.right.equalTo(statusLbl.mas_left);
        }];
        
        UIButton * useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        useBtn.titleLabel.font = XFont(12);
        useBtn.backgroundColor = MAINGREEN;
        [useBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        useBtn.layer.cornerRadius = 5;
        useBtn.layer.masksToBounds = YES;
        [bg addSubview:useBtn];
        [useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bg.mas_right).offset(-15);
            make.centerY.equalTo(timeLbl);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@80);
        }];
        [useBtn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
        bg.userInteractionEnabled = YES;

        
    }
    return self;
}

-(void)useBtnAction{
    if (self.mySaleCardCellBlock) {
        self.mySaleCardCellBlock(self.cardModel);
    }

}

-(void)setCardModel:(XFCardBagModel *)cardModel{
    _cardModel = cardModel;
    
    self.bg.image = IMAGENAME(@"youhuiquan-weishiyong");
    self.statusLbl.text = @"";
    self.timeLbl.text = [NSString stringWithFormat:@"有效时间:%@",cardModel.end_time];

    self.infoLbl.text = [NSString stringWithFormat:@"说明:%@",cardModel.content];
    self.priceLbl.text = cardModel.name;
    self.imv.alpha = 1;
    self.imv.image = IMAGENAME(@"card_icon");
//    [self.imv sd_setImageWithURL:[NSURL URLWithString:cardModel.image]];
}


@end
