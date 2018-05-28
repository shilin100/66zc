//
//  XFActiveCenterViewController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFActiveCenterViewController.h"
#import "XFActiveListModel.h"
#import "XFActiveCenterCell.h"

@interface XFActiveCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<XFActiveListModel *> *ActiveListModels;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation XFActiveCenterViewController

-(NSMutableArray<XFActiveListModel *> *)ActiveListModels
{
    if(!_ActiveListModels)
    {
        _ActiveListModels=[NSMutableArray array];
    }
    return _ActiveListModels;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动中心";
    self.view.backgroundColor = GRAYBACKGROUND;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREENW-20, SCREENH-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 480/375*SCREENW;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = HEXCOLOR(@"eeeeee");
    tableView.separatorColor=CLEARCOLOR;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewDataWithType:@"2"];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreDataWithType:@"2"];
    }];
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂无活动";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);
    
}

- (void) loadNewDataWithType:(NSString *)type {
    
    _page=1;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:type forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/my/my_advert",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.ActiveListModels removeAllObjects];
            [self.ActiveListModels addObjectsFromArray:[XFActiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.ActiveListModels.count==0)
            {
                _noDataLabel.hidden=NO;
            }
            else
            {
                _noDataLabel.hidden=YES;
            }
            
        }else{
            
            _noDataLabel.hidden=NO;
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        [self endRefresh];
    }];
    
}

-(void)loadMoreDataWithType:(NSString *)type
{
    _page++;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:type forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/my/my_advert",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.ActiveListModels addObjectsFromArray:[XFActiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
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


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_ActiveListModels count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    XFActiveCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XFActiveCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _ActiveListModels[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* urlStr = self.ActiveListModels[indexPath.row].link;
    NSString* title = self.ActiveListModels[indexPath.row].title;
    XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
    webViewController.urlString = urlStr;
    webViewController.webTitle = title;
    [self.navigationController pushViewController:webViewController animated:YES];
    
}



@end
