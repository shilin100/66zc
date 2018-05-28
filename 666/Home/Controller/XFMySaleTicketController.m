//
//  XFMySaleTicketController.m
//  666
//
//  Created by xiaofan on 2017/10/18.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMySaleTicketController.h"
#import "XFMyTicketCell.h"
#import "XFUseTicketModel.h"
#import "XFDhmController.h"
#import "XFCardBagModel.h"
#import "XFMySaleCardCell.h"

@interface XFMySaleTicketController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *unuseBtn;
@property (nonatomic, weak) UIButton *usedBtn;
@property (nonatomic, weak) UIButton *cardBagBtn;

@property (nonatomic, strong) NSMutableArray *ticketModels;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation XFMySaleTicketController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的卡券";
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    [self setupSubs];
    
}

- (void) setupSubs {
    
    UIImage *rightImage = [IMAGENAME(@"yhq_dhm") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(dhmClick)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84*SCALE_HEIGHT, SCREENW, SCREENH-64-84*SCALE_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 123;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *unuseBtn = [[UIButton alloc] init];
    if (!self.selectedIndex) {
        unuseBtn.selected = YES;
    }
    [unuseBtn setTitle:@"未使用" forState:UIControlStateNormal];
    [unuseBtn setTitleColor:MAINGREEN forState:UIControlStateSelected];
    [unuseBtn setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
    unuseBtn.titleLabel.font = XFont(12);
    unuseBtn.backgroundColor = WHITECOLOR;
    unuseBtn.layer.cornerRadius = 32*SCALE_HEIGHT;
    unuseBtn.clipsToBounds = YES;
    [self.view insertSubview:unuseBtn aboveSubview:tableView];
    self.unuseBtn = unuseBtn;
    [[unuseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self loadNewDataWithType:1];
        unuseBtn.selected = YES;
        self.usedBtn.selected = NO;
        self.cardBagBtn.selected = NO;
    }];
    
    UIButton *usedBtn = [[UIButton alloc] init];
    [usedBtn setTitle:@"已使用／过期" forState:UIControlStateNormal];
    [usedBtn setTitleColor:MAINGREEN forState:UIControlStateSelected];
    [usedBtn setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
    usedBtn.titleLabel.font = XFont(12);
    usedBtn.backgroundColor = WHITECOLOR;
    usedBtn.layer.cornerRadius = 32*SCALE_HEIGHT;
    usedBtn.clipsToBounds = YES;
    [self.view insertSubview:usedBtn aboveSubview:tableView];
    self.usedBtn = usedBtn;
    [[usedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self loadNewDataWithType:2];
        unuseBtn.selected = NO;
        self.usedBtn.selected = YES;
        self.cardBagBtn.selected = NO;
    }];
    
    UIButton *cardBagBtn = [[UIButton alloc] init];
    [cardBagBtn setTitle:@"卡包" forState:UIControlStateNormal];
    [cardBagBtn setTitleColor:MAINGREEN forState:UIControlStateSelected];
    [cardBagBtn setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
    cardBagBtn.titleLabel.font = XFont(12);
    cardBagBtn.backgroundColor = WHITECOLOR;
    cardBagBtn.layer.cornerRadius = 32*SCALE_HEIGHT;
    cardBagBtn.clipsToBounds = YES;
    [self.view insertSubview:cardBagBtn aboveSubview:tableView];
    self.cardBagBtn = cardBagBtn;
    [[cardBagBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self loadNewCardBag];
        unuseBtn.selected = NO;
        self.usedBtn.selected = NO;
        self.cardBagBtn.selected = YES;

    }];

    if (self.selectedIndex) {
        unuseBtn.selected = NO;
        self.usedBtn.selected = NO;
        self.cardBagBtn.selected = NO;

        switch (self.selectedIndex) {
            case 1:
                usedBtn.selected = YES;
                break;
            case 2:
                cardBagBtn.selected = YES;
                break;
            default:
                unuseBtn.selected = YES;
                break;
        }
    }
    
    unuseBtn.sd_layout
    .topSpaceToView(self.view, 20*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 20*SCALE_WIDTH)
    .heightIs(64*SCALE_HEIGHT)
    .widthIs(193*SCALE_WIDTH);
    
    usedBtn.sd_layout
    .topEqualToView(unuseBtn)
    .leftSpaceToView(unuseBtn, 20*SCALE_WIDTH)
    .bottomEqualToView(unuseBtn)
    .widthRatioToView(unuseBtn, 1);
    
    cardBagBtn.sd_layout
    .topEqualToView(usedBtn)
    .leftSpaceToView(usedBtn, 20*SCALE_WIDTH)
    .bottomEqualToView(usedBtn)
    .widthRatioToView(usedBtn, 1);

    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(unuseBtn.selected)
        {
            [self loadNewDataWithType:1];
        }
        else if(cardBagBtn.selected){
            [self loadNewCardBag];
        }
        else
        {
            [self loadNewDataWithType:2];
        }
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if(unuseBtn.selected)
        {
            [self loadMoreDataWithType:1];
        }
        else if(cardBagBtn.selected){
            [self loadMoreCardBag];
        }
        else
        {
            [self loadMoreDataWithType:2];
        }
        
    }];
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂无优惠券";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);
    
}

-(void)dhmClick
{
    XFDhmController *dhmVC=[[XFDhmController alloc] init];
    [self.navigationController pushViewController:dhmVC animated:YES];
    
}

-(void)requestToUseCard:(NSString*)cardId{
    
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    [params setObject:cardId forKey:@"prid"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/usePrizes",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) {
            [self.tableView.mj_header beginRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];

}

- (void)loadNewCardBag {
    _page = 1;
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/myPrizes",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        [self endRefresh];
        if ([responseObject[@"status"] intValue] == 1) { //
            [self.ticketModels removeAllObjects];
            [self.ticketModels addObjectsFromArray:[XFCardBagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            if(self.ticketModels.count==0){
                _noDataLabel.hidden=NO;
            }
            else{
                _noDataLabel.hidden=YES;
            }
        }else
        {
            [self.ticketModels removeAllObjects];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)loadMoreCardBag {
    _page++;
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/myPrizes",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        [self endRefresh];
        if ([responseObject[@"status"] intValue] == 1) { //
            [self.ticketModels addObjectsFromArray:[XFCardBagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
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
    
    NSLog(@"params===%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/coupon",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) { //
            [self.ticketModels removeAllObjects];
            [self.ticketModels addObjectsFromArray:[XFUseTicketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            for (XFUseTicketModel *model in self.ticketModels) {
                model.isUsed = type == 1 ? NO : YES;
            }
            //            [self.tableView reloadData];

            if(self.ticketModels.count==0)
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
            [self.ticketModels removeAllObjects];
            //            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
//            [SVProgressHUD dismissWithDelay:1.2];
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
            
            for (XFUseTicketModel *model in self.ticketModels) {
                model.isUsed = type == 1 ? NO : YES;
            }
            //            [self.tableView reloadData];
            if(self.ticketModels.count==0)
            {
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        }
        
        else
        {
//            [self.ticketModels removeAllObjects];
            //            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD showInfoWithStatus:@"暂无优惠券"];
//            [SVProgressHUD dismissWithDelay:1.2];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ticketModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cardBagBtn.selected) {
        
        XFMySaleCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMySaleCardCellid"];
        if (!cell) {
            cell = [[XFMySaleCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XFMySaleCardCellid"];;
        }
        WeakSelf
        cell.mySaleCardCellBlock = ^(id model) {
            XFCardBagModel * cardModel = model;
            XFAlertView * alert = [[XFAlertView alloc]initWithTitle:@"系统提示" message:@"该卡仅限于服务网点工作人员操作，个人操作将作废！" sureBtn:@"使用" cancleBtn:@"取消"];
            alert.resultIndex = ^(AlertButtonType type) {
                switch (type) {
                    case AlertButtonTypeSure:
                        [weakSelf requestToUseCard:cardModel.ID];
                        break;
                    case AlertButtonTypeCancel:
                        
                        break;

                    default:
                        break;
                };
            };
            [alert showAlertView];
        };
        cell.cardModel = self.ticketModels[indexPath.row];
        return cell;
    }else{
        static NSString *ID = @"ticketCell";
        XFMyTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[XFMyTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];;
        }
        cell.ticketModel = self.ticketModels[indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
