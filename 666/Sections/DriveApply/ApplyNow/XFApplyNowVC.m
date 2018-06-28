//
//  XFApplyNowVC.m
//  666
//
//  Created by 123 on 2018/5/8.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFApplyNowVC.h"
#import "XFAppluNowCell.h"
#import "XFDriveApplyTableViewCell.h"
#import "IQKeyboardManager.h"

@interface XFApplyNowVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeholderArr;


@end

@implementation XFApplyNowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"立即报名";
    
    self.titleArr = @[@"姓名",@"电话",@"身份证",@"地址"];
    self.placeholderArr = @[@"请填写您的姓名",@"请填写联系电话",@"请填写身份证号",@"请填写详细地址"];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self setupUI];

}
-(void)setupUI{

    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = WHITECOLOR;
    [self.view addSubview:bottomView];
    bottomView.sd_layout
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(64);

    UIButton *reportOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportOrderBtn.titleLabel.font=XFont(18);
    [reportOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [reportOrderBtn addTarget:self action:@selector(reportOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    reportOrderBtn.backgroundColor = MAINGREEN;
    
    [bottomView addSubview:reportOrderBtn];
    reportOrderBtn.sd_layout
    .rightSpaceToView(bottomView, 0)
    .topSpaceToView(bottomView, 0)
    .bottomSpaceToView(bottomView, 0)
    .widthIs(120);

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = XFont(18);
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = GRAYTEXT;
    moneyLabel.attributedText = [self differentColor:REDCOLOR string:[NSString stringWithFormat:@"¥%@",self.model.cost] inString:[NSString stringWithFormat:@"实付款:¥%@",self.model.cost]];
    
    [bottomView addSubview:moneyLabel];
    moneyLabel.sd_layout
    .topSpaceToView(bottomView, 0)
    .leftSpaceToView(bottomView, 10)
    .rightSpaceToView(reportOrderBtn, 10)
    .bottomSpaceToView(bottomView, 0);

    NSString * totalStr = @"我已阅读并同意《六六租车用户协议》";
    NSString * str = @"《六六租车用户协议》";
    NSMutableAttributedString *attributeString = [self differentColor:REDCOLOR string:str inString:totalStr];
    
    UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.titleLabel.font=XFont(14);
    [stateBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
    [stateBtn setImage:IMAGENAME(@"tik") forState:UIControlStateNormal];
    stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [stateBtn addTarget:self action:@selector(requestDelegateUrl) forControlEvents:UIControlEventTouchUpInside];
    stateBtn.backgroundColor = WHITECOLOR;
    
    [self.view addSubview:stateBtn];
    stateBtn.sd_layout
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(bottomView, 2)
    .leftSpaceToView(self.view, 0)
    .heightIs(30);

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -30, SCREENW, 44*4+136+54+2*3+30 + 10) style:UITableViewStyleGrouped];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFDriveApplyTableViewCell class] forCellReuseIdentifier:@"XFApplyNowCellSchool"];
    [tableView registerClass:[XFAppluNowCell class] forCellReuseIdentifier:@"XFApplyOrderCellText"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = YES;
    
    tableView.sd_layout
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(stateBtn, 2)
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, -30);

}

-(void)reportOrderBtnAction{
    [self requestSubmitOrder];
}


-(void)requestDelegateUrl{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/user_deal",BASE_URL] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            NSString* urlStr = responseObject[@"url"];
            XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
            webViewController.urlString = urlStr;
            [self.navigationController pushViewController:webViewController animated:YES];
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:0.85];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        [SVProgressHUD dismissWithDelay:0.85];
        
    }];
    
}


- (void) requestSubmitOrder {
    NSString * username = [self getCellText:0];
    NSString * tel = [self getCellText:1];
    NSString * idcard = [self getCellText:2];
    NSString * address = [self getCellText:3];

    if (!(username.length >0 &&tel.length >0 &&idcard.length >0 &&address.length >0)) {
        [SVProgressHUD showErrorWithStatus:@"请先将信息填写完整"];
        [SVProgressHUD dismissWithDelay:0.85];
        return;
    }
    if (![RegularHelperUtil checkTelNumber:tel]) {
        [SVProgressHUD showErrorWithStatus:@"手机号有误或不是国内手机号"];
        [SVProgressHUD dismissWithDelay:0.85];
        return;
    }
    if (![RegularHelperUtil checkUserIdCard:idcard]) {
        [SVProgressHUD showErrorWithStatus:@"身份证有误"];//护照怎么办
        [SVProgressHUD dismissWithDelay:0.85];
        return;
    }

    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    [params setObject:self.model.did forKey:@"did"];
    [params setObject:self.model.cid forKey:@"cid"];
    [params setObject:username forKey:@"username"];
    [params setObject:tel forKey:@"tel"];
    [params setObject:idcard forKey:@"id_card"];
    [params setObject:address forKey:@"address"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/StudyCar/buyOrder",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.applyNowBlock) {
                self.applyNowBlock();
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(NSString*)getCellText:(int)index{
    XFAppluNowCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.textField.text;
}

-(NSMutableAttributedString*)differentColor:(UIColor*)color string:(NSString*)str inString:(NSString*)totalStr{
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    attributeString.color = GRAYTEXT;

    NSRange rang = [totalStr rangeOfString:str];
    //设置标签文字属性
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil] range:rang];
    return attributeString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArr.count;
    }else
        return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view = [UIView new];
//    view.backgroundColor = GRAYBACKGROUND;

    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        XFAppluNowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFApplyOrderCellText" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setTitle:self.titleArr[indexPath.row] placeholder:self.placeholderArr[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 1) {
        XFDriveApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFApplyNowCellSchool" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model=self.model;
        cell.applyBtn.sd_layout
        .heightIs(0);
        cell.payLabel.sd_layout
        .heightIs(0);
        cell.rowLine.sd_layout
        .heightIs(0);
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"客服电话";
        cell.textLabel.textColor = BlACKTEXT;
        cell.detailTextLabel.text = self.model.service;
        cell.detailTextLabel.text = @"027-59762081";

        
        cell.detailTextLabel.textColor = BlACKTEXT;
        cell.imageView.image = [UIImage imageNamed:@"serviceTel"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",cell.detailTextLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:
            return 136;
            break;
        case 2:
            return 54;
            break;

        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

@end
