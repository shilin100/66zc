//
//  XFRefundCashViewController.m
//  666
//
//  Created by 123 on 2018/6/22.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRefundCashViewController.h"
#import "XFRefundCashTableViewCell.h"
#import "XFWarnView.h"
#import "XFDisclaimerView.h"


@interface XFRefundCashViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UILabel * alipayAccount;
@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,weak)UITextView * reasonTextView;

@property(nonatomic,assign)BOOL isAgressDisclaimer;

@end

@implementation XFRefundCashViewController{
    NSArray * dataArr;
    NSMutableArray * selectedData;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"押金退还";
    self.view.backgroundColor = HEXCOLOR(@"eeeeee");
    dataArr = @[@"租车费用昂贵",@"可租车辆少，使用不方便",@"车况较差，车内环境不整洁，车内物品缺失",@"押金过高，体验感较差",@"选择使用其他汽车租赁APP",@"APP使用不稳定，服务网点过少",@"其他原因"];
    selectedData = [NSMutableArray array];
    _isAgressDisclaimer = NO;
    
    [self setupUI];
    [self requestAccount];
}

-(void)setupUI{
    UIView * accountContent = [UIView new];
    accountContent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountContent];
    
    accountContent.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(40);
    
    
    UILabel * accountTitle = [UILabel new];
    accountTitle.font = XFont(13);
    accountTitle.textColor = GRAYTEXT;
    accountTitle.text = @"默认退还账户";
    [accountContent addSubview:accountTitle];
    
    accountTitle.sd_layout
    .centerYEqualToView(accountContent)
    .leftSpaceToView(accountContent, 10)
    .widthIs(80)
    .heightIs(30);
    
    
    UILabel * payRouter = [UILabel new];
    payRouter.font = XFont(13);
    payRouter.textColor = BlACKTEXT;
    payRouter.textAlignment = NSTextAlignmentRight;
    [accountContent addSubview:payRouter];
    payRouter.text = @"支付宝";
    
    payRouter.sd_layout
    .centerYEqualToView(accountContent)
    .rightSpaceToView(accountContent, 18)
    .widthIs(40)
    .heightIs(30);

    
    UIImageView * payIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhifubao"]];
    payIcon.contentMode = UIViewContentModeScaleAspectFit;
    [accountContent addSubview:payIcon];

    payIcon.sd_layout
    .centerYEqualToView(accountContent)
    .rightSpaceToView(payRouter, 5)
    .widthIs(16)
    .heightIs(16);

    
    UILabel * alipayAccount = [UILabel new];
    alipayAccount.font = XFont(13);
    alipayAccount.textColor = BlACKTEXT;
    [accountContent addSubview:alipayAccount];
    alipayAccount.text = @"111";
    self.alipayAccount = alipayAccount;
    
    alipayAccount.sd_layout
    .centerYEqualToView(accountContent)
    .leftSpaceToView(accountTitle, 10)
    .rightSpaceToView(payIcon, 10)
    .heightIs(30);
    
    UIView * amountContent = [UIView new];
    amountContent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:amountContent];
    
    amountContent.sd_layout
    .topSpaceToView(accountContent, 2)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(40);
    
    
    UILabel * amountTitle = [UILabel new];
    amountTitle.font = XFont(13);
    amountTitle.textColor = GRAYTEXT;
    amountTitle.text = @"退还金额";
    [amountContent addSubview:amountTitle];
    
    amountTitle.sd_layout
    .centerYEqualToView(amountContent)
    .leftSpaceToView(amountContent, 10)
    .widthIs(80)
    .heightIs(30);

    UILabel * amountMoney = [UILabel new];
    amountMoney.font = XFont(13);
    amountMoney.textColor = BlACKTEXT;
    amountMoney.textAlignment = NSTextAlignmentRight;
    [amountContent addSubview:amountMoney];
    amountMoney.text = [NSString stringWithFormat:@"￥%.2f",self.amount];
    
    amountMoney.sd_layout
    .centerYEqualToView(amountContent)
    .rightSpaceToView(amountContent, 18)
    .widthIs(100)
    .heightIs(30);

    
    UILabel * reasonTitle = [UILabel new];
    reasonTitle.font = XFont(13);
    reasonTitle.textColor = BlACKTEXT;
    NSString * totalStr = @"申请押金退款原因:(必选，可多选)";
    NSString * str = @"(必选，可多选)";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    attributeString.color = BlACKTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:GRAYTEXT, NSForegroundColorAttributeName,XBFont(9),NSFontAttributeName, nil] range:rang];
    reasonTitle.attributedText = attributeString;
    [self.view addSubview:reasonTitle];
    
    reasonTitle.sd_layout
    .topSpaceToView(amountContent, 0)
    .leftSpaceToView(self.view, 14)
    .rightSpaceToView(self.view, 10)
    .heightIs(30);

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, 400) style:UITableViewStylePlain];
    tableView.backgroundColor = WHITECOLOR;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFRefundCashTableViewCell class] forCellReuseIdentifier:@"XFRefundCashCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.sd_layout
    .topSpaceToView(reasonTitle, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(35*dataArr.count);

    
    UILabel * detailLabel = [UILabel new];
    detailLabel.font = XFont(13);
    detailLabel.textColor = BlACKTEXT;
    totalStr = @"备注以及反馈:*";
    str = @"*";
    attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    rang = [totalStr rangeOfString:str];
    attributeString.color = BlACKTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:REDCOLOR, NSForegroundColorAttributeName,XBFont(14),NSFontAttributeName, nil] range:rang];
    detailLabel.attributedText = attributeString;
    [self.view addSubview:detailLabel];
    
    detailLabel.sd_layout
    .topSpaceToView(tableView, 0)
    .leftSpaceToView(self.view, 14)
    .rightSpaceToView(self.view, 10)
    .heightIs(30);
    
    UITextView *reasonTextView = [[UITextView alloc] init];
    reasonTextView.backgroundColor = WHITECOLOR;
    reasonTextView.font = XFont(14);
    reasonTextView.textColor = BlACKTEXT;
    reasonTextView.contentInset = UIEdgeInsetsMake(2.0f, 10.0f, 10.0f, 10.0f);
    self.reasonTextView = reasonTextView;
    
    [self.view addSubview:reasonTextView];
    reasonTextView.sd_layout
    .topSpaceToView(detailLabel, 0)
    .leftSpaceToView(self.view, 13)
    .rightSpaceToView(self.view, 13)
    .heightIs(62);

    
    UIButton *tikBtn = [[UIButton alloc] init];
    [tikBtn setImage:IMAGENAME(@"tik_empty") forState:UIControlStateNormal];
    [tikBtn setImage:IMAGENAME(@"tik") forState:UIControlStateSelected];
    [self.view addSubview:tikBtn];
    [tikBtn addTarget:self action:@selector(tikBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    tikBtn.sd_layout
    .widthIs(30)
    .topSpaceToView(reasonTextView, 2)
    .leftSpaceToView(self.view, 15)
    .heightIs(30);


    totalStr = @"我已阅读并同意《六六租车免责说明》";
    str = @"《六六租车免责说明》";
    attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    rang = [totalStr rangeOfString:str];
    attributeString.color = GRAYTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(@"#FF5555"), NSForegroundColorAttributeName,XBFont(12),NSFontAttributeName, nil] range:rang];

    UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.titleLabel.font=XFont(14);
    [stateBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
    stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [stateBtn addTarget:self action:@selector(showDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:stateBtn];
    stateBtn.sd_layout
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(reasonTextView, 2)
    .leftSpaceToView(tikBtn, 1)
    .heightIs(30);

    UIButton *loadBtn = [[UIButton alloc] init];
    [loadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loadBtn.titleLabel.font = XFont(14);
    loadBtn.layer.cornerRadius = 22;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:loadBtn];
    [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loadBtn.sd_layout
    .bottomSpaceToView(self.view, 37)
    .leftSpaceToView(self.view, 37)
    .heightIs(44)
    .rightSpaceToView(self.view, 37);

    
}
-(void)tikBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    _isAgressDisclaimer = sender.selected;
}


-(void)showDisclaimer{
    [XFDisclaimerView show];
}

-(void)loadBtnClick{
    if (!_isAgressDisclaimer) {
        [SVProgressHUD showErrorWithStatus:@"您需要同意免责声明再退款"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    if (selectedData.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择至少一个退款原因"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    NSMutableArray * temp = [NSMutableArray array];
    for (NSNumber *index in selectedData) {
        [temp addObject:dataArr[index.integerValue]];
    }
    if (self.reasonTextView.text.length > 0) {
        [temp addObject:self.reasonTextView.text];
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:temp forKey:@"refundReason"];
    [param setObject:@"1" forKey:@"user_type"];
    [param setObject:@"1" forKey:@"type"];
    [param setObject:@(self.amount) forKey:@"money"];

    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@/My/upmoney",BASE_URL] withDic:param Succeed:^(NSDictionary *responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"您的提现申请已提交,系统会在3到5个工作日退还至您指定的账号"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            XFWarnView * view = [XFWarnView new];
            view.titleLabel.text = responseObject[@"info"];
            [view showWithoutImg];
            
        }

    } andFaild:^(NSError *error) {
        
    }];
    
}


-(void)requestAccount{
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/User"] withDic:nil Succeed:^(NSDictionary *responseObject) {
        
        self.alipayAccount.text = [NSString stringWithFormat:@"%@ %@",responseObject[@"data"][@"username"],responseObject[@"data"][@"paynumber"]];
        
    } andFaild:^(NSError *error) {
        
    }];
}

#pragma mark tableViewDelegate/DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [dataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        XFRefundCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFRefundCashCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = dataArr[indexPath.row];

    
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 35;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XFRefundCashTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL isSelected = [selectedData containsObject:@(indexPath.row)];
    if (isSelected) {
        [cell.checkBox setOn:!isSelected animated:YES];
        [selectedData removeObject:@(indexPath.row)];
    }else{
        [cell.checkBox setOn:!isSelected animated:YES];
        [selectedData addObject:@(indexPath.row)];
    }
//    123
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
