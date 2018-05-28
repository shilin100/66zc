//
//  XFApplyOrderCenterVC.m
//  666
//
//  Created by 123 on 2018/5/7.
//  Copyright © 2018年 xiaofan. All rights reserved.
//.3

#import "XFApplyOrderCenterVC.h"
#import "XFDriveApplyTableViewCell.h"
#import "XFApplyOrderModel.h"
#import "XFApplyOrderDetailVC.h"
#import "XFChooseView.h"
#import "XFWXPayReqModel.h"
#import "XFApplyRefundVC.h"

@interface XFApplyOrderCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int orderType;

@property (nonatomic, strong) NSMutableArray *currentArray;
@property (nonatomic, weak) XFChooseView *choosePayView;


@end

@implementation XFApplyOrderCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"订单中心";
    self.dataArray = [NSMutableArray array];
    self.currentArray = [NSMutableArray array];
    self.orderType = 0;
    [self setupUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultHandle:) name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResultHandle:) name:WXPayResultNotification object:nil];

}


-(void)setupUI{
    
    NSArray * orderStateArr = @[@"全部",@"待付款",@"预约中",@"已完成",@"售后"];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:orderStateArr];
    segmentedControl.frame = CGRectMake(0, 0, SCREENW, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = RGBCOLOR(235, 235, 235);
    segmentedControl.verticalDividerWidth = 1.0f;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : XFont(14),NSForegroundColorAttributeName : BlACKTEXT};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : MAINGREEN};
    segmentedControl.selectionIndicatorColor = MAINGREEN;
    self.segmentedControl = segmentedControl;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREENW, SCREENH-64-40) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFDriveApplyTableViewCell class] forCellReuseIdentifier:@"XFApplyOrderCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
        
    
    [self loadNewData];
    
    
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂无订单";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);
    
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.orderType = (int)segmentedControl.selectedSegmentIndex;
    [self.currentArray removeAllObjects];
    if (self.orderType == 0) {
        self.currentArray = [NSMutableArray arrayWithArray:self.dataArray];
    }else{
        for (XFApplyOrderModel * model in self.dataArray) {
            if (model.order_type == self.orderType) {
                [self.currentArray addObject:model];
            }
        }
    }
    [self.tableView reloadData];
//    [self.tableView setContentOffset:CGPointMake(0,0)animated:YES];
    
}

- (void) loadNewData {
    
    _page=1;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/StudyCar/drivingOrder",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[XFApplyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            self.currentArray = [NSMutableArray arrayWithArray:self.dataArray];
            self.segmentedControl.selectedSegmentIndex = 0;
            if (self.index) {
                self.segmentedControl.selectedSegmentIndex = self.index;
                [self segmentedControlChangedValue:self.segmentedControl];
                self.index = 0;
            }

            [self.tableView reloadData];
            
        }else{
            
            _noDataLabel.hidden=NO;
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

- (void) requestPayOrderWithType:(int)type andModel:(XFApplyOrderModel*)model{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:model.de_id forKey:@"deid"];
    [params setObject:model.cost forKey:@"money"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/pay/details",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"status"] intValue] == 1) {
            if (type == 1) {
                
                [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",responseObject[@"url"]] fromScheme:@"llzuche" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    
                    int resultStatus = [resultDic[@"resultStatus"] intValue];
                    NSString *memo = resultDic[@"memo"];
                    
                    switch (resultStatus) {
                        case 9000:
                            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                            break;
                        case 8000 : case 6001:
                            [SVProgressHUD showInfoWithStatus:memo];
                            break;
                        case 4000 : case 6002:
                            [SVProgressHUD showErrorWithStatus:memo];
                            break;
                            
                        default:
                            break;
                    }
                }];
                
            }else{
                XFWXPayReqModel *model = [XFWXPayReqModel mj_objectWithKeyValues:responseObject[@"config"]];
                if ([model.return_code isEqualToString:@"SUCCESS"]) {
                    PayReq *req = [[PayReq alloc] init];
                    req.partnerId = model.mch_id;
                    req.prepayId = model.prepay_id;
                    req.nonceStr = model.nonce_str;
                    req.timeStamp = model.timestamp;
                    req.package = model.wxpackage;
                    req.sign = model.sign;
                    
                    [WXApi sendReq:req];
                    
                    //没安装微信客户端
                    if (![WXApi isWXAppInstalled])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请先安装微信再进行支付" sureBtn:@"确定" cancleBtn:nil];
                        [alert showAlertView];
                    }
                }
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

- (void) alipayResultHandle:(NSNotification *)notification {
    NSLog(@"notification==%@",[notification object]);
    int resultStatus = [[notification object][@"resultStatus"] intValue];
    NSString *memo = [notification object][@"memo"];
    
    switch (resultStatus) {
        case 9000:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            break;
        case 8000 : case 6001:
            [SVProgressHUD showInfoWithStatus:memo];
            break;
        case 4000 : case 6002:
            [SVProgressHUD showErrorWithStatus:memo];
            break;
            
        default:
            break;
    }
    [self loadNewData];
}
- (void) WXPayResultHandle:(NSNotification *)notification {
    NSLog(@"wx_notifi:%@--%d",((PayResp *)notification.object).errStr,((PayResp *)notification.object).errCode);
    switch (((PayResp *)notification.object).errCode) {
        case 0:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            break;
        case -1:
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            break;
        case -2:
            [SVProgressHUD showInfoWithStatus:@"支付已取消"];
            break;
        case -3:
            [SVProgressHUD showErrorWithStatus:@"发起支付失败"];
            break;
        case -4:
            [SVProgressHUD showErrorWithStatus:@"授权支付失败"];
            break;
        case -5:
            [SVProgressHUD showErrorWithStatus:@"不支持该支付"];
            break;
            
        default:
            break;
    }
    [self loadNewData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayResultNotification object:nil];
}


#pragma mark tableViewDelegate/DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFDriveApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFApplyOrderCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.orderModel=self.currentArray[indexPath.row];
    
    WeakSelf;
    cell.applyCellBlock = ^(id model) {
        XFApplyOrderModel * orderModel = model;
        if (orderModel.order_type == 1) {
            XFChooseView *choosePayView = [[XFChooseView alloc] initWithTopTitles:@[@"支付宝",@"使用支付宝进行付款"] bottomTitles:@[@"微信",@"使用微信进行付款"]];
            choosePayView.topImgV.image = [UIImage imageNamed:@"ssdk_oks_classic_alipay"];
            choosePayView.topImgV.contentMode = UIViewContentModeScaleAspectFit;
            choosePayView.bottomImgV.image = [UIImage imageNamed:@"ssdk_oks_classic_wechat"];
            choosePayView.bottomImgV.contentMode = UIViewContentModeScaleAspectFit;

            choosePayView.topBlock = ^{
                [weakSelf requestPayOrderWithType:1 andModel:model];
            };
            choosePayView.bottomBlock = ^{
                [weakSelf requestPayOrderWithType:2 andModel:model];
            };

            [choosePayView show];
        }else if (orderModel.order_type != 4){
            __block XFApplyRefundVC * vc = [XFApplyRefundVC new];
            vc.model = orderModel;
            vc.loadBlock = ^{
                [weakSelf loadNewData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XFApplyOrderModel * model = self.currentArray[indexPath.row];
    if (model.order_type == 4 || model.order_type == 3) {
        return 180;
    }else
        return 210;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XFApplyOrderDetailVC * vc = [XFApplyOrderDetailVC new];
    vc.model = self.currentArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
