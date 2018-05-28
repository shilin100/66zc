//
//  XFDriveApplyTableViewCell.m
//  666
//
//  Created by 123 on 2018/5/2.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFDriveApplyTableViewCell.h"

@implementation XFDriveApplyTableViewCell

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
        
        UIView * rowLine = [[UIView alloc]init];
        rowLine.backgroundColor = HEXCOLOR(@"#eeeeee");
        [self.contentView addSubview:rowLine];
        rowLine.sd_layout
        .topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(2);
        self.rowLine = rowLine;
        
        UIView * grayBg = [[UIView alloc]init];
        grayBg.backgroundColor = RGBCOLOR(247, 249, 250);
        [self.contentView addSubview:grayBg];
        grayBg.sd_layout
        .topSpaceToView(self.contentView, 32)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(104);
        self.grayBg = grayBg;
        
        UILabel *schoolLabel = [[UILabel alloc] init];
        schoolLabel.font = XFont(14);
        schoolLabel.textColor = HEXCOLOR(@"999999");
        schoolLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:schoolLabel];
        self.schoolLabel=schoolLabel;
        schoolLabel.sd_layout
        .topSpaceToView(rowLine, 0)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(200)
        .bottomSpaceToView(grayBg, 0);
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.font = XFont(14);
        moneyLabel.textColor = REDCOLOR;
        [self.contentView addSubview:moneyLabel];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel=moneyLabel;
        moneyLabel.sd_layout
        .topSpaceToView(rowLine, 0)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(200)
        .bottomSpaceToView(grayBg, 0);


        UIImageView *imv=[[UIImageView alloc] init];
        [grayBg addSubview:imv];
        imv.contentMode = UIViewContentModeScaleAspectFill;
        self.imv=imv;
        imv.sd_layout
        .centerYEqualToView(grayBg)
        .widthIs(80)
        .leftSpaceToView(grayBg, 15)
        .heightEqualToWidth();
        imv.layer.cornerRadius=40;
        imv.clipsToBounds=YES;

        UIImageView *littleImv=[[UIImageView alloc] init];
        littleImv.image=IMAGENAME(@"jiaolian-tubiao");
        littleImv.layer.cornerRadius=10;
        littleImv.clipsToBounds=YES;
        [grayBg addSubview:littleImv];
        littleImv.sd_layout
        .topSpaceToView(grayBg, 15)
        .leftSpaceToView(imv, 15)
        .widthIs(20)
        .heightEqualToWidth();
        
        
        UILabel *jiaolianLabel = [[UILabel alloc] init];
        //        jiaolianLabel.backgroundColor=[UIColor redColor];
        jiaolianLabel.font = XFont(14);
        jiaolianLabel.textColor = BlACKTEXT;
        //        jiaolianLabel.text = @"张教练";
        [grayBg addSubview:jiaolianLabel];
        self.jiaolianLabel=jiaolianLabel;
        jiaolianLabel.sd_layout
        .centerYEqualToView(littleImv)
        .leftSpaceToView(littleImv, 5)
        .widthIs(60)
        .heightIs(30);
        
        UIImageView *phoneImv=[[UIImageView alloc] init];
        phoneImv.image=IMAGENAME(@"phone_icon");
        phoneImv.layer.cornerRadius=10;
        phoneImv.clipsToBounds=YES;
        [grayBg addSubview:phoneImv];
        phoneImv.sd_layout
        .topSpaceToView(grayBg, 15)
        .leftSpaceToView(jiaolianLabel, 15)
        .widthIs(20)
        .heightEqualToWidth();
        
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = XFont(14);
        phoneLabel.textColor = BlACKTEXT;
        [grayBg addSubview:phoneLabel];
        self.phoneLabel=phoneLabel;
        phoneLabel.sd_layout
        .centerYEqualToView(phoneImv)
        .leftSpaceToView(phoneImv, 5)
        .rightSpaceToView(grayBg, 15)
        .heightIs(30);

        
        UILabel *areaLabel2 = [[UILabel alloc] init];
        areaLabel2.font = XFont(14);
        areaLabel2.textColor = BlACKTEXT;
        [grayBg addSubview:areaLabel2];
        self.areaLabel2=areaLabel2;
        areaLabel2.sd_layout
        .centerYEqualToView(imv)
        .leftSpaceToView(imv, 15)
        .rightSpaceToView(grayBg, 15)
        .heightIs(30);
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = XFont(13);
        addressLabel.textColor = HEXCOLOR(@"999999");
        //        areaLabel2.text = @"南湖区";
        [grayBg addSubview:addressLabel];
        self.addressLabel=addressLabel;
        addressLabel.sd_layout
        .bottomEqualToView(imv)
        .leftSpaceToView(imv, 15)
        .rightSpaceToView(grayBg, 15)
        .heightIs(30);

        UILabel *payLabel = [[UILabel alloc] init];
        payLabel.font = XFont(14);
        payLabel.textColor = HEXCOLOR(@"999999");
        payLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:payLabel];
        payLabel.textAlignment = NSTextAlignmentRight;
        self.payLabel=payLabel;
        payLabel.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(grayBg, 0)
        .leftSpaceToView(self.contentView, 10)
        .heightIs(0);

        
        UIButton *stateBtn = [[UIButton alloc] init];
        stateBtn.layer.cornerRadius=5;
        stateBtn.layer.masksToBounds = YES;
        stateBtn.layer.borderColor = HEXCOLOR(@"999999").CGColor;
        stateBtn.layer.borderWidth = 1;
        [stateBtn setTitleColor:HEXCOLOR(@"999999") forState:UIControlStateNormal];
        stateBtn.titleLabel.font=XFont(14);
        //        [stateBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        [stateBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        [self.contentView addSubview:stateBtn];
        self.applyBtn=stateBtn;
        stateBtn.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(payLabel, 7)
        .widthIs(70)
        .heightIs(30);
        
        [stateBtn addTarget:self action:@selector(applyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)applyBtnAction{
    if (self.applyCellBlock) {
        if (self.model != nil) {
            self.applyCellBlock(self.model);
        }else if (self.orderModel != nil){
            self.applyCellBlock(self.orderModel);
        }
    }

}

-(void)setModel:(XFDriverApplyModel *)model{
    _model = model;
    self.schoolLabel.text = model.d_name;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.cost];
    self.phoneLabel.text = model.phone;
    self.jiaolianLabel.text = model.name;
    self.areaLabel2.text = model.address;
    self.addressLabel.text = model.field;
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.co_header]];

}

-(void)setOrderModel:(XFApplyOrderModel *)model{
    NSArray * orderState = @[@"",@"待付款",@"预约中",@"已完成",@"售后"];
    NSArray * afterSaleState = @[@"",@"申请中",@"审核通过",@"审核未通过"];

    _orderModel = model;
    self.schoolLabel.text = model.d_name;
    self.moneyLabel.text = model.order_type == 4 ? afterSaleState[model.stuatuse] : orderState[model.order_type];
    self.moneyLabel.textColor = HEXCOLOR(@"999999");
    self.phoneLabel.text = model.phone;
    self.jiaolianLabel.text = model.name;
    self.areaLabel2.text = model.address;
    self.addressLabel.text = model.field;
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.co_header]];
    [self.applyBtn setTitle:model.order_type == 1 ? @"去付款":@"申请退款" forState:UIControlStateNormal];
    self.payLabel.sd_layout
    .heightIs(30);

    self.payLabel.text = [NSString stringWithFormat:@"实付款: ¥%@",model.cost];
    if (model.order_type != 4 && model.order_type != 3) {
        self.applyBtn.sd_layout
        .heightIs(30);
        self.payLabel.sd_layout
        .topSpaceToView(self.grayBg, 0);

    }else{
        self.applyBtn.sd_layout
        .heightIs(0);
        self.payLabel.sd_layout
        .topSpaceToView(self.grayBg, 7);

    }
}


@end
