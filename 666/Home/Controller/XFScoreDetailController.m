//
//  XFScoreDetailController.m
//  666
//
//  Created by xiaofan on 2017/10/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFScoreDetailController.h"
#import "XFScoreDetailCell.h"
#import "XFMyWalletDetailModel.h"
#import "XFMyYJDetailModel.h"

@interface XFScoreDetailController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) UILabel *totalTripLabel;
@property (nonatomic, weak) UILabel *totalMoneyLabel;

@property (nonatomic, assign) int page;


@end

@implementation XFScoreDetailController

-(NSMutableArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120*SCALE_HEIGHT;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = HEXCOLOR(@"eeeeee");
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if ([self.indentifer isEqualToString:@"score"]) {
        self.navigationItem.title = @"积分明细";
    }else if ([self.indentifer isEqualToString:@"money"]) {
        self.navigationItem.title = @"佣金明细";
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self loadMoneyNewData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [self loadMoneyMoreData];
        }];
        
    }else if ([self.indentifer isEqualToString:@"wallet"]){
        self.navigationItem.title = @"钱包明细";
        [self setupWalletUI];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self loadWalletNewData];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [self loadWalletMoreData];
        }];
    }
    
}

#pragma mark - 钱包明细

-(void)setupWalletUI{
    UIImageView * topBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing"]];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.layer.masksToBounds = YES;
    [self.view addSubview:topBg];
    topBg.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view,0)
    .heightIs(100)
    .rightEqualToView(self.view);

    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = WHITECOLOR;
    [topBg addSubview:lineView];
    lineView.alpha = 0.6;
    lineView.sd_layout
    .topSpaceToView(topBg, 30)
    .bottomSpaceToView(topBg, 30)
    .centerXEqualToView(topBg)
    .widthIs(1);
    
    UILabel * totalTrip = [[UILabel alloc]init];
    totalTrip.textColor = WHITECOLOR;
    totalTrip.numberOfLines = 2;
    totalTrip.textAlignment = NSTextAlignmentCenter;
    totalTrip.font = XFont(17);
    [topBg addSubview:totalTrip];
    totalTrip.sd_layout
    .topSpaceToView(topBg, 0)
    .bottomSpaceToView(topBg, 0)
    .leftEqualToView(topBg)
    .rightEqualToView(lineView);
    self.totalTripLabel = totalTrip;
    totalTrip.text = @"总行程\n加载中...";
    
    UILabel * totalMoney = [[UILabel alloc]init];
    totalMoney.textColor = WHITECOLOR;
    totalMoney.numberOfLines = 2;
    totalMoney.textAlignment = NSTextAlignmentCenter;
    totalMoney.font = XFont(17);
    [topBg addSubview:totalMoney];
    totalMoney.sd_layout
    .topSpaceToView(topBg, 0)
    .bottomSpaceToView(topBg, 0)
    .rightEqualToView(topBg)
    .leftEqualToView(lineView);
    self.totalMoneyLabel = totalMoney;
    totalMoney.text = @"总消费\n加载中...";

    self.tableView.sd_layout
    .topSpaceToView(topBg, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);

    
}

-(void)loadWalletNewData
{
    _page=1;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/money_deail",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            NSDictionary * dic = responseObject;

            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[XFMyWalletDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            self.totalTripLabel.text = [NSString stringWithFormat:@"总行程\n%.2fkm",[dic doubleValueForKey:@"distances" default:0]];
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"总消费\n¥ %.2f",[dic doubleValueForKey:@"pay_moneys" default:0]];

            
            if(_dataArr.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"<<:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)loadWalletMoreData
{
    _page++;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/money_deail",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArr addObjectsFromArray:[XFMyWalletDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            
            if(_dataArr.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"<<:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

#pragma mark - 佣金明细
-(void)loadMoneyNewData
{
    _page=1;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/commission",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"responseObject===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[XFMyYJDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            
            if(_dataArr.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"<<:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)loadMoneyMoreData
{
    _page++;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/commission",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArr addObjectsFromArray:[XFMyYJDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            
            if(_dataArr.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"<<:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArr count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"scoreCell";
    XFScoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XFScoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if ([self.indentifer isEqualToString:@"score"]) {
        cell.titleLbl.text = @"积分";
    }else if ([self.indentifer isEqualToString:@"money"]) {
        
        XFMyYJDetailModel *model=_dataArr[indexPath.row];
        cell.titleLbl.text = [model.type intValue]==1 ? @"佣金获取":@"佣金提现";
        cell.timeLbl.text = model.time;
        //1.佣金获取 2.佣金提现
        cell.statusLbl.text = [model.type intValue]==1 ? [NSString stringWithFormat:@"%@",model.change]:[NSString stringWithFormat:@"%@",model.change];
        
    }
    else if ([self.indentifer isEqualToString:@"wallet"]) {
        
        XFMyWalletDetailModel *model=_dataArr[indexPath.row];
        cell.titleLbl.text = model.title;
        cell.timeLbl.text = model.time;
        //1.充值 2.提现
        cell.statusLbl.text = [model.type intValue]==1 ? [NSString stringWithFormat:@"+%@",model.money]:[NSString stringWithFormat:@"-%@",model.money];
        
    }
    
    return cell;
    
}

@end
