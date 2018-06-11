//
//  XFMyOrderCell.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrderCell.h"
#import "XFMyOrderModel.h"

@interface XFMyOrderCell ()
/**订单号*/
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
/**订单时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
/**总时间*/
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
/**停车时间*/
@property (weak, nonatomic) IBOutlet UILabel *stopTimeLbl;
/**总里程*/
@property (weak, nonatomic) IBOutlet UILabel *totalMilesLbl;
/**订单状态*/
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
/**开始地址*/
@property (weak, nonatomic) IBOutlet UILabel *startAddressLbl;
/**结束地址*/
@property (weak, nonatomic) IBOutlet UILabel *endAddressLbl;
/**订单金额*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;

@end

@implementation XFMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}
-(void)setModel:(XFMyOrderModel *)model{
    _model = model;
    
    self.timeLbl.text = model.time;
    
    self.codeLbl.text = [NSString stringWithFormat:@"订单号:%@",model.code];
    
//    self.totalTimeLbl.text = [NSString stringWithFormat:@"%.2f(Min)",model.sum_time];
    self.totalTimeLbl.text = [NSString stringWithFormat:@"%@",model.sum_time];

    self.stopTimeLbl.text = [NSString stringWithFormat:@"%d(Min)",model.stop_time];
    
    self.totalMilesLbl.text = [NSString stringWithFormat:@"%.2f(KM)",model.sumMiles];
    
    self.startAddressLbl.text = model.start_address;
    
    self.endAddressLbl.text = model.end_address;
    
    if (model.status) { // 已支付
        self.statusLbl.text = @"已支付";
        self.statusLbl.textColor = HEXCOLOR(@"999999");
    }else{ // 未支付
        self.statusLbl.text = @"未支付";
        self.statusLbl.textColor = MAINGREEN;
    }
    
    self.moneyLbl.text = [NSString stringWithFormat:@"¥ %.2f",model.money];
}
@end
