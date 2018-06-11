//
//  XFMyBreakRuleCell.m
//  666
//
//  Created by xiaofan on 2017/11/1.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyBreakRuleCell.h"
#import "XFBreakRuleModel.h"

@interface XFMyBreakRuleCell ()
/**罚单时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
/**罚单编号*/
@property (weak, nonatomic) IBOutlet UILabel *orderIDLbl;
/**罚单金额*/
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
/**罚单信息*/
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
/**支付状态*/
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
/**总时长*/
@property (weak, nonatomic) IBOutlet UILabel *sumTimeLbl;
/**停车时长*/
@property (weak, nonatomic) IBOutlet UILabel *stopTimeLbl;
/**总里程*/
@property (weak, nonatomic) IBOutlet UILabel *milesLbl;
/**开始地址*/
@property (weak, nonatomic) IBOutlet UILabel *startAddLbl;
/**结束地址*/
@property (weak, nonatomic) IBOutlet UILabel *endAddLbl;

@end

@implementation XFMyBreakRuleCell
-(void)setModel:(XFBreakRuleModel *)model{
    _model = model;
    
    self.timeLbl.text = model.order_time;
    self.orderIDLbl.text = [NSString stringWithFormat:@"订单号:%@",model.order_number];

    if([model.punish_score isEqualToString:@"0"])
    {
        self.statusLbl.text = [model.pay_status isEqualToString:@"0"] ? @"未支付":@"已支付";
    }
    else
    {
        if([model.punish_status isEqualToString:@"0"])
        {
            self.statusLbl.text=@"未销分";
        }
        else if ([model.punish_status isEqualToString:@"2"])
        {
            self.statusLbl.text=@"未通过";
        }
        else
        {
            self.statusLbl.text = [model.pay_status isEqualToString:@"0"] ? @"未支付":@"已支付";
        }
    }
    
    self.priceLbl.text = [NSString stringWithFormat:@"%@元",model.pay_money];
    self.infoLbl.text = model.car_content;
    self.sumTimeLbl.text = [NSString stringWithFormat:@"%.0f(Min)",model.sum_time];
    self.stopTimeLbl.text = [NSString stringWithFormat:@"%.0f(Min)",model.time];
    self.milesLbl.text = [NSString stringWithFormat:@"%.2f(KM)",model.distance];
    self.startAddLbl.text = model.start_address;
    self.endAddLbl.text = model.end_address;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
@end
