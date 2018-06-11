//
//  XFGiveCarServiceCell.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceCell.h"
#import "XFGiveCarServiceModel.h"

@implementation XFGiveCarServiceCell

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
        
        UILabel *stateLabel = [[UILabel alloc] init];
//        stateLabel.backgroundColor=[UIColor redColor];
        stateLabel.font = XFont(13);
//        stateLabel.textColor = HEXCOLOR(@"333333");
        stateLabel.text = @"订单状态";
        [self.contentView addSubview:stateLabel];
        stateLabel.sd_layout
        .topSpaceToView(self.contentView, 5)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(60)
        .heightIs(40);
        
        
        UIButton *stateBtn = [[UIButton alloc] init];
//        stateBtn.backgroundColor=REDCOLOR;
//        [stateBtn setTitle:@"确认用车" forState:UIControlStateNormal];
        [stateBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        stateBtn.titleLabel.font=XFont(13);
        [self.contentView addSubview:stateBtn];
        self.stateBtn=stateBtn;
        [[stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            //
            
        }];
        
        stateBtn.sd_layout
        .topSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(60)
        .heightIs(30);
        

        UIButton *confirmUseCarBtn = [[UIButton alloc] init];
        confirmUseCarBtn.layer.cornerRadius=5;
        confirmUseCarBtn.layer.borderColor=HEXCOLOR(@"999999").CGColor;
        confirmUseCarBtn.layer.borderWidth=1;
        [confirmUseCarBtn setTitle:@"确认用车" forState:UIControlStateNormal];
        [confirmUseCarBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        confirmUseCarBtn.titleLabel.font=XFont(13);
        //        [confirmUseCarBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
        [self.contentView addSubview:confirmUseCarBtn];
        confirmUseCarBtn.hidden=YES;
        self.confirmUseCarBtn=confirmUseCarBtn;
        [[confirmUseCarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"确认用车");
            if (self.delegate && [self.delegate respondsToSelector:@selector(XFGiveCarServiceCell:didClickUseBtn:)]) {
                [self.delegate XFGiveCarServiceCell:self didClickUseBtn:confirmUseCarBtn];
            }
            
        
            
        }];
        
        confirmUseCarBtn.sd_layout
        .topSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(60)
        .heightIs(30);
        
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = LYColor(250, 250, 250);
        [self.contentView addSubview:bgView];
        bgView.sd_layout
        .topSpaceToView(stateLabel, 0)
        .leftEqualToView(self.contentView)
        .heightIs(90)
        .rightEqualToView(self.contentView);
        
        
        UILabel *nameLabel1 = [[UILabel alloc] init];
        nameLabel1.font = XFont(13);
        //        nameLabel1.textColor = HEXCOLOR(@"333333");
        nameLabel1.text = @"姓名：";
        [bgView addSubview:nameLabel1];
        nameLabel1.sd_layout
        .topSpaceToView(bgView, 0)
        .leftSpaceToView(bgView, 10)
        .widthIs(40)
        .heightIs(30);
        
        UILabel *nameLabel2 = [[UILabel alloc] init];
        nameLabel2.font = XFont(13);
        //        nameLabel2.textColor = HEXCOLOR(@"333333");
//        nameLabel2.text = @"张三李四";
        [bgView addSubview:nameLabel2];
        self.nameLabel2=nameLabel2;
        nameLabel2.sd_layout
        .topSpaceToView(bgView, 0)
        .leftSpaceToView(nameLabel1, 0)
        .widthIs(60)
        .heightIs(30);
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = XFont(13);
        //        phoneLabel.textColor = HEXCOLOR(@"333333");
//        phoneLabel.text = @"13100701825";
        [bgView addSubview:phoneLabel];
        self.phoneLabel=phoneLabel;
        phoneLabel.sd_layout
        .topSpaceToView(bgView, 0)
        .leftSpaceToView(nameLabel2, 10)
        .widthIs(120)
        .heightIs(30);
        
        UILabel *timeLabel1 = [[UILabel alloc] init];
        timeLabel1.font = XFont(13);
        //        timeLabel1.textColor = HEXCOLOR(@"333333");
        timeLabel1.text = @"送车时间：";
        [bgView addSubview:timeLabel1];
        timeLabel1.sd_layout
        .topSpaceToView(nameLabel1, 0)
        .leftSpaceToView(bgView, 10)
        .widthIs(70)
        .heightIs(30);
        
        UILabel *timeLabel2 = [[UILabel alloc] init];
        timeLabel2.font = XFont(13);
        //        timeLabel2.textColor = HEXCOLOR(@"333333");
//        timeLabel2.text = @"2017.08.20 12:12";
        [bgView addSubview:timeLabel2];
        self.timeLabel2=timeLabel2;
        timeLabel2.sd_layout
        .topSpaceToView(nameLabel1, 0)
        .leftSpaceToView(timeLabel1, 0)
        .widthIs(150)
        .heightIs(30);
        
        UILabel *addressLabel1 = [[UILabel alloc] init];
        addressLabel1.font = XFont(13);
        //        addressLabel1.textColor = HEXCOLOR(@"333333");
        addressLabel1.text = @"送车地址：";
        [bgView addSubview:addressLabel1];
        addressLabel1.sd_layout
        .topSpaceToView(timeLabel1, 0)
        .leftSpaceToView(bgView, 10)
        .widthIs(70)
        .heightIs(30);
        
        UILabel *addressLabel2 = [[UILabel alloc] init];
        addressLabel2.font = XFont(13);
        //        addressLabel2.textColor = HEXCOLOR(@"333333");
//        addressLabel2.text = @"武汉市洪山区光谷广场资本大厦";
        [bgView addSubview:addressLabel2];
        self.addressLabel2=addressLabel2;
        addressLabel2.sd_layout
        .topSpaceToView(timeLabel1, 0)
        .leftSpaceToView(addressLabel1, 0)
        .rightSpaceToView(bgView, 10)
        .heightIs(30);
        
    }
    return self;
}

-(void)setModel:(XFGiveCarServiceModel *)model
{
    if([model.is_show intValue])
    {
        [_stateBtn setTitle:@"已取消" forState:UIControlStateNormal];
        self.stateBtn.hidden=NO;
        self.confirmUseCarBtn.hidden=YES;
    }
    else
    {
        switch ([model.status intValue]) {
            case 1:
                [_stateBtn setTitle:@"未确认" forState:UIControlStateNormal];
                self.stateBtn.hidden=NO;
                self.confirmUseCarBtn.hidden=YES;
                break;
            case 2:
                self.stateBtn.hidden=YES;
                self.confirmUseCarBtn.hidden=NO;
                break;
            case 3:
                self.stateBtn.hidden=YES;
                self.confirmUseCarBtn.hidden=NO;
                break;
            case 4:
                [_stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
                self.stateBtn.hidden=NO;
                self.confirmUseCarBtn.hidden=YES;
                break;
            case 5:
                [_stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
                self.stateBtn.hidden=NO;
                self.confirmUseCarBtn.hidden=YES;
                break;
            default:
                break;
        }
    }
    
    _nameLabel2.text=model.name;
    _phoneLabel.text=model.tel;
    _timeLabel2.text=model.use_time;
    _addressLabel2.text=model.address;
    
}

@end
