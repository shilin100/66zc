//
//  XFMyBreakRulesController.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyBreakRulesController.h"
#import "XFMyBreakRuleCell.h"
#import "XFBreakRuleModel.h"
#import "XFMyBreakRulesDetailController.h"
#import "XFMyBreakRulesDetailCompletedController.h"
#import "XFCleanScoreController.h"


@interface XFMyBreakRulesController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *breakRuleModels;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) UILabel *noDataLabel;



@end

@implementation XFMyBreakRulesController
-(NSMutableArray *)breakRuleModels{
    if (!_breakRuleModels) {
        _breakRuleModels = [NSMutableArray array];
    }
    return _breakRuleModels;
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
    
    self.navigationItem.title = @"我的违章";
    
    [self setupTableView];
    
    
}
- (void) setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, SCREENW, SCREENH - 70)];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 255;
    [tableView registerNib:[UINib nibWithNibName:@"XFMyBreakRuleCell" bundle:nil] forCellReuseIdentifier:@"breakCell"];
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
    _noDataLabel.text=@"暂无罚单";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);
    
}


-(void)loadNewData
{
    _page=1;
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
//    [params setObject:@"1" forKey:@"num"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/My/my_ticket",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            [self.breakRuleModels removeAllObjects];
            [self.breakRuleModels addObjectsFromArray:[XFBreakRuleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.breakRuleModels.count==0)
            {
                _noDataLabel.hidden=NO;
            }
            else
            {
                _noDataLabel.hidden=YES;
            }
        }
        else
        {
            _noDataLabel.hidden=NO;
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
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
//    [params setObject:@"1" forKey:@"num"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/My/my_ticket",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.breakRuleModels addObjectsFromArray:[XFBreakRuleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
        }
        else
        {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - tableViewDelegate && tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.breakRuleModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFMyBreakRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"breakCell" forIndexPath:indexPath];
    cell.model = self.breakRuleModels[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XFBreakRuleModel *model=self.breakRuleModels[indexPath.row];
    
    if([model.punish_score isEqualToString:@"0"])
    {
        if([model.pay_status isEqualToString:@"0"])
        {
            //支付
            XFMyBreakRulesDetailController *vc = [[XFMyBreakRulesDetailController alloc] init];
            vc.model=model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            XFMyBreakRulesDetailCompletedController *vc = [[XFMyBreakRulesDetailCompletedController alloc] init];
            vc.model=model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        if([model.punish_status isEqualToString:@"0"] || [model.punish_status isEqualToString:@"2"])
        {
            //未处理先销分
            XFCleanScoreController *vc=[[XFCleanScoreController alloc] init];
            vc.model=model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if([model.pay_status isEqualToString:@"0"])
            {
                //支付
                XFMyBreakRulesDetailController *vc = [[XFMyBreakRulesDetailController alloc] init];
                vc.model=model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                XFMyBreakRulesDetailCompletedController *vc = [[XFMyBreakRulesDetailCompletedController alloc] init];
                vc.model=model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
}



@end
