//
//  XFMyOrderController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrderController.h"
#import "XFMyOrderModel.h"
#import "XFMyOrderCell.h"
#import "XFMyOrdersDetailController.h"
#import "XFMyOrderDetailCompletedController.h"
#import "XFFaPiaoViewController.h"

@interface XFMyOrderController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<XFMyOrderModel *> *orderModels;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation XFMyOrderController
-(NSMutableArray<XFMyOrderModel *> *)orderModels{
    if (!_orderModels) {
        _orderModels = [NSMutableArray array];
    }
    return _orderModels;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"我的订单";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 54, 30);
    [rightBtn setTitle:@"发票开具" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = XFont(13);
    [rightBtn addTarget:self action:@selector(fpClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    
    [self setupSubs];
    
}

- (void) setupSubs {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, SCREENW, SCREENH - 70)];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 153;
    [tableView registerNib:[UINib nibWithNibName:@"XFMyOrderCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂时没有订单";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);
    
}
- (void) loadNewData {
    
    _page=1;
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/orders",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [self.orderModels removeAllObjects];
            [self.orderModels addObjectsFromArray:[XFMyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.orderModels.count==0)
            {
                _noDataLabel.hidden=NO;
            }
            else
            {
                _noDataLabel.hidden=YES;
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        [self endRefresh];
    }];
}

-(void)loadMoreData
{
    _page++;
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/orders",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.orderModels addObjectsFromArray:[XFMyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        [self endRefresh];
    }];
}

-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    cell.model = self.orderModels[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.orderModels[indexPath.row].status)
    {
        
        XFMyOrderDetailCompletedController *vc = [[XFMyOrderDetailCompletedController alloc] init];
        vc.model = self.orderModels[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        XFMyOrdersDetailController *vc = [[XFMyOrdersDetailController alloc] init];
        vc.model = self.orderModels[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)fpClick
{
    XFFaPiaoViewController *vc = [[XFFaPiaoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
