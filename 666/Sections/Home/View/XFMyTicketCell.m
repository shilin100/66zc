//
//  XFMyTicketCell.m
//  666
//
//  Created by xiaofan on 2017/10/18.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyTicketCell.h"
#import "XFUseTicketModel.h"

@interface XFMyTicketCell()
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

@implementation XFMyTicketCell


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
        priceLbl.font = XFont(18);
//        priceLbl.textColor = MAINGREEN;
//        priceLbl.text = @"6元";
        [bg addSubview:priceLbl];
        self.priceLbl = priceLbl;
        
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg.mas_top).offset(5.5);
            make.left.equalTo(bg.mas_left).offset(32.5);
            make.height.mas_equalTo(@(73.5));
            make.width.mas_equalTo(@(80));
        }];
        
        // 描述1
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(12);
//        titleLbl.text = @"优惠红包";
        titleLbl.textColor = HEXCOLOR(@"#666666");
        [bg addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLbl.mas_top).offset(17);
            make.left.equalTo(priceLbl.mas_right).offset(25);
            make.height.mas_equalTo(@17.5);
            make.right.equalTo(bg.mas_right).offset(-10);
        }];
        
        // 描述2
        UILabel *infoLbl = [[UILabel alloc] init];
        infoLbl.font = XFont(12);
//        infoLbl.text = @"每单满6元即可立减6元";
        infoLbl.textColor = HEXCOLOR(@"#666666");
        [bg addSubview:infoLbl];
        self.infoLbl = infoLbl;
        
        [infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).offset(5);
            make.left.equalTo(titleLbl.mas_left);
            make.height.mas_equalTo(@17.5);
            make.right.equalTo(bg.mas_right).offset(-10);
        }];
        
        UIImageView *imv=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [bg addSubview:imv];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        self.imv=imv;
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg.mas_top).offset(5.5);
            make.left.equalTo(bg.mas_left).offset(32.5);
            make.height.mas_equalTo(@(73.5));
            make.width.mas_equalTo(@(80));
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
        
        
        
    }
    return self;
}

-(void)setTicketModel:(XFUseTicketModel *)ticketModel{
    _ticketModel = ticketModel;
    
    self.titleLbl.text=ticketModel.cou_type;
    self.priceLbl.text = [NSString stringWithFormat:@"%.2f元",ticketModel.money];
    self.infoLbl.text=ticketModel.rule;
    //暂时改为用车抵扣6元
//    self.infoLbl.text=@"用车抵扣6元";
//    self.timeLbl.text = [NSString stringWithFormat:@"有效时间:%@",ticketModel.time];
    
    NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:[ticketModel.satrtime integerValue]];
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:[ticketModel.end_time integerValue]];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startStr=[formatter stringFromDate:startDate];
    NSString *endStr=[formatter stringFromDate:endDate];
    NSString *s1=[startStr stringByAppendingString:@"至"];
    NSString *s2=[s1 stringByAppendingString:endStr];
    NSLog(@"s2===%@",s2);
    self.timeLbl.text = [NSString stringWithFormat:@"有效时间:%@",s2];
    
    if (ticketModel.isUsed) { // 已使用
        self.bg.image = IMAGENAME(@"youhuiquan-yishiyong");
        self.priceLbl.textColor = RGBCOLORe(133);
        self.statusLbl.text = @"已使用";
    }else{ // 未使用
        self.bg.image = IMAGENAME(@"youhuiquan-weishiyong");
        self.priceLbl.textColor = MAINGREEN;
        self.statusLbl.text = @"未使用";
    }
    self.priceLbl.alpha = 1;
    self.imv.alpha = 0;
}

-(void)setCardModel:(XFCardBagModel *)cardModel{
    _cardModel = cardModel;
    
    self.bg.image = IMAGENAME(@"youhuiquan-weishiyong");
    self.statusLbl.text = @"";
    self.timeLbl.text = [NSString stringWithFormat:@"有效时间:%@",cardModel.deadline];
    self.titleLbl.text = cardModel.name;
    self.infoLbl.text = cardModel.content;
    self.priceLbl.alpha = 0;
    self.imv.alpha = 1;
    [self.imv sd_setImageWithURL:[NSURL URLWithString:cardModel.image]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
@end
