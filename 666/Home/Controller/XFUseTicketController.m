//
//  XFUseTicketController.m
//  666
//
//  Created by xiaofan on 2017/10/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUseTicketController.h"
#import "XFUseTicketModel.h"
#import "XFUseTicketCell.h"

@interface XFUseTicketController () <UITableViewDelegate,UITableViewDataSource>
- (IBAction)unuseBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**<#desc#>*/
@property (nonatomic, strong) NSMutableArray<XFUseTicketModel *> *ticketModels;

@property (nonatomic, assign) int page;


@end

@implementation XFUseTicketController

-(NSMutableArray<XFUseTicketModel *> *)ticketModels{
    if (!_ticketModels) {
        _ticketModels = [NSMutableArray array];
    }
    return _ticketModels;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.useTicketBtn.selected) { //
        self.ticketBlock([XFUseTicketModel new]);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.useTicketBtn.selected = self.isUnuse;
    
    self.navigationItem.title = @"优惠券";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 44;
    [self.tableView registerClass:[XFUseTicketCell class] forCellReuseIdentifier:@"useTicketCell"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewDataWithType:1];
        
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreDataWithType:1];
        
    }];
    

}

- (void) loadNewDataWithType:(int)type {
    
    _page=1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].minShowTime = 0.5;
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/coupon",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) { //
            [self.ticketModels removeAllObjects];
            [self.ticketModels addObjectsFromArray:[XFUseTicketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
            if(self.ticketModels.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        }
        
        else
        {
           
            [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefresh];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)loadMoreDataWithType:(int)type
{
    
    _page++;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].minShowTime = 0.5;
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/coupon",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) { //
            
            [self.ticketModels addObjectsFromArray:[XFUseTicketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
            if(self.ticketModels.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        }
        
        else
        {
    
            [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ticketModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFUseTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"useTicketCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = self.ticketModels[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_orderMoney<self.ticketModels[indexPath.row].fullmoney)
    {
        [SVProgressHUD showInfoWithStatus:@"您的消费总额还没达到该优惠券的使用条件,请重新选择"];
    }
    else
    {
        self.useTicketBtn.selected = NO;
        self.ticketBlock(self.ticketModels[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)unuseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}
@end
