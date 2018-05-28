//
//  XFApplyOrderDetailVC.m
//  666
//
//  Created by 123 on 2018/5/8.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFApplyOrderDetailVC.h"
#import "XFDriveApplyTableViewCell.h"
@interface XFApplyOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation XFApplyOrderDetailVC

-(void)viewDidLoad{
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"订单详情";

    [self setupUI];
}
-(void)setupUI{
    
    
    UILabel *orderStateLabel = [[UILabel alloc] init];
    orderStateLabel.font = XFont(14);
    orderStateLabel.textColor = HEXCOLOR(@"999999");
    [self.view addSubview:orderStateLabel];
    orderStateLabel.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);

    CGFloat height = 30;
    
    UIView * userInfoContent = [[UIView alloc]init];
    userInfoContent.backgroundColor = WHITECOLOR;
    [self.view addSubview:userInfoContent];
    userInfoContent.sd_layout
    .topSpaceToView(orderStateLabel, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(height*4 + 10);
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = XFont(14);
    nameLabel.textColor = HEXCOLOR(@"999999");
    [userInfoContent addSubview:nameLabel];
    nameLabel.sd_layout
    .topSpaceToView(userInfoContent, 5)
    .leftSpaceToView(userInfoContent, 10)
    .rightSpaceToView(userInfoContent, 0)
    .heightIs(height);

    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.font = XFont(14);
    telLabel.textColor = HEXCOLOR(@"999999");
    [userInfoContent addSubview:telLabel];
    telLabel.sd_layout
    .topSpaceToView(nameLabel, 0)
    .leftSpaceToView(userInfoContent, 10)
    .rightSpaceToView(userInfoContent, 0)
    .heightIs(height);

    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.font = XFont(14);
    idLabel.textColor = HEXCOLOR(@"999999");
    [userInfoContent addSubview:idLabel];
    idLabel.sd_layout
    .topSpaceToView(telLabel, 0)
    .leftSpaceToView(userInfoContent, 10)
    .rightSpaceToView(userInfoContent, 0)
    .heightIs(height);

    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = XFont(14);
    addressLabel.textColor = HEXCOLOR(@"999999");
    [userInfoContent addSubview:addressLabel];
    addressLabel.sd_layout
    .topSpaceToView(idLabel, 0)
    .leftSpaceToView(userInfoContent, 10)
    .rightSpaceToView(userInfoContent, 0)
    .heightIs(height);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREENW, SCREENH) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFDriveApplyTableViewCell class] forCellReuseIdentifier:@"XFApplyOrderCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
    tableView.sd_layout
    .topSpaceToView(userInfoContent, 2)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(180);
    
    UIView * orderContent = [[UIView alloc]init];
    orderContent.backgroundColor = WHITECOLOR;
    [self.view addSubview:orderContent];
    orderContent.sd_layout
    .topSpaceToView(self.tableView, 2)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(height*2 + 10);
    
    UILabel *orderNumLabel = [[UILabel alloc] init];
    orderNumLabel.font = XFont(14);
    orderNumLabel.textColor = HEXCOLOR(@"999999");
    [orderContent addSubview:orderNumLabel];
    orderNumLabel.sd_layout
    .topSpaceToView(orderContent, 5)
    .leftSpaceToView(orderContent, 10)
    .rightSpaceToView(orderContent, 0)
    .heightIs(height);
    
    UILabel *orderTimeLabel = [[UILabel alloc] init];
    orderTimeLabel.font = XFont(14);
    orderTimeLabel.textColor = HEXCOLOR(@"999999");
    [orderContent addSubview:orderTimeLabel];
    orderTimeLabel.sd_layout
    .topSpaceToView(orderNumLabel, 0)
    .leftSpaceToView(orderContent, 10)
    .rightSpaceToView(orderContent, 0)
    .heightIs(height);

    NSArray * afterSaleState = @[@"",@"申请中",@"审核通过",@"审核未通过"];
    NSArray * orderStateArr = @[@"全部",@"待付款",@"预约中",@"已完成",@"售后"];

    orderStateLabel.text = [NSString stringWithFormat:@"订单状态: %@",self.model.order_type == 4 ? afterSaleState[_model.stuatuse] : orderStateArr[_model.order_type]];
    nameLabel.attributedText = [self differentColor:BlACKTEXT string:_model.username inString:[NSString stringWithFormat:@"姓名: %@",_model.username]];
    telLabel.attributedText = [self differentColor:BlACKTEXT string:_model.tel inString:[NSString stringWithFormat:@"电话: %@",_model.tel]];
    idLabel.attributedText = [self differentColor:BlACKTEXT string:_model.id_card inString:[NSString stringWithFormat:@"身份证: %@",_model.id_card]];
    addressLabel.attributedText = [self differentColor:BlACKTEXT string:_model.newaddress inString:[NSString stringWithFormat:@"地址: %@",_model.newaddress]];
    orderNumLabel.attributedText = [self differentColor:BlACKTEXT string:_model.indent inString:[NSString stringWithFormat:@"订单编号: %@",_model.indent]];
    orderTimeLabel.attributedText = [self differentColor:BlACKTEXT string:_model.data_time inString:[NSString stringWithFormat:@"订单时间: %@",_model.data_time]];

}

-(NSMutableAttributedString*)differentColor:(UIColor*)color string:(NSString*)str inString:(NSString*)totalStr{
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    //设置标签文字属性
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil] range:rang];
    return attributeString;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFDriveApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFApplyOrderCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.orderModel=self.model;
    cell.applyBtn.sd_layout
    .heightIs(0);
    cell.payLabel.sd_layout
    .topSpaceToView(cell.grayBg, 7);

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 180;
}


@end
