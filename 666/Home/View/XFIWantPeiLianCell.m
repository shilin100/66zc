//
//  XFIWantPeiLianCell.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFIWantPeiLianCell.h"
#import "XFIWantPLModel.h"

@implementation XFIWantPeiLianCell

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
        
        
        UIImageView *imv=[[UIImageView alloc] init];
//        imv.image=IMAGENAME(@"morentouxiang");
        imv.contentMode = UIViewContentModeScaleAspectFill;
        imv.layer.cornerRadius=25;
        imv.clipsToBounds=YES;
        [self.contentView addSubview:imv];
        self.imv=imv;
        imv.sd_layout
        .topSpaceToView(self.contentView, 15)
        .leftSpaceToView(self.contentView, 15)
        .widthIs(50)
        .heightEqualToWidth();
        
        UIImageView *littleImv=[[UIImageView alloc] init];
        littleImv.image=IMAGENAME(@"jiaolian-tubiao");
        littleImv.layer.cornerRadius=10;
        littleImv.clipsToBounds=YES;
        [self.contentView addSubview:littleImv];
        littleImv.sd_layout
        .topSpaceToView(self.contentView, 15)
        .leftSpaceToView(imv, 15)
        .widthIs(20)
        .heightEqualToWidth();
        
        
        UILabel *jiaolianLabel = [[UILabel alloc] init];
        //        jiaolianLabel.backgroundColor=[UIColor redColor];
        jiaolianLabel.font = XFont(13);
        jiaolianLabel.textColor = BLACKCOLOR;
//        jiaolianLabel.text = @"张教练";
        [self.contentView addSubview:jiaolianLabel];
        self.jiaolianLabel=jiaolianLabel;
        jiaolianLabel.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(littleImv, 5)
        .widthIs(90)
        .heightIs(30);
    
        UILabel *areaLabel1 = [[UILabel alloc] init];
        //        areaLabel1.backgroundColor=[UIColor redColor];
        areaLabel1.font = XFont(14);
        areaLabel1.textColor = HEXCOLOR(@"999999");
        areaLabel1.text = @"服务范围：";
        [self.contentView addSubview:areaLabel1];
        areaLabel1.sd_layout
        .topSpaceToView(jiaolianLabel, 0)
        .leftSpaceToView(imv, 15)
        .widthIs(80)
        .heightIs(30);
        
        UILabel *areaLabel2 = [[UILabel alloc] init];
        //        areaLabel2.backgroundColor=[UIColor redColor];
        areaLabel2.font = XFont(14);
        areaLabel2.textColor = HEXCOLOR(@"999999");
//        areaLabel2.text = @"南湖区";
        [self.contentView addSubview:areaLabel2];
        self.areaLabel2=areaLabel2;
        areaLabel2.sd_layout
        .topSpaceToView(jiaolianLabel, 0)
        .leftSpaceToView(areaLabel1, 0)
        .widthIs(100)
        .heightIs(30);
        
        
        UIButton *stateBtn = [[UIButton alloc] init];
        stateBtn.layer.cornerRadius=15;
//        stateBtn.backgroundColor=[UIColor lightGrayColor];
//        [stateBtn setTitle:@"空闲" forState:UIControlStateNormal];
        [stateBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        stateBtn.titleLabel.font=XFont(14);
        //        [stateBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        [self.contentView addSubview:stateBtn];
        self.stateBtn=stateBtn;
        stateBtn.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .widthIs(70)
        .heightIs(30);
        
        
    }
    return self;
}

-(void)setModel:(XFIWantPLModel *)model
{
    [_imv sd_setImageWithURL:[NSURL URLWithString:[model.pic stringByAppendingString:model.img]] placeholderImage:IMAGENAME(@"morentouxiang")];
    _jiaolianLabel.text=model.name;
    _areaLabel2.text=model.area;
    if([model.status_zh isEqualToString:@"空闲"])
    {
        [_stateBtn setTitle:@"空闲" forState:UIControlStateNormal];
        _stateBtn.backgroundColor=LYColor(246, 193, 30);
    }
    else
    {
        [_stateBtn setTitle:@"已约" forState:UIControlStateNormal];
        _stateBtn.backgroundColor=LYColor(165, 170, 190);
    }
    
}



@end
