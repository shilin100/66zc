//
//  XFGiveCarServiceController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceController.h"
#import "XFGiveCarServiceCell.h"
#import "XFGiveCarServiceDetailController.h"
#import "XFGiveCarServiceYCController.h"
#import "XFGiveCarServiceModel.h"
#import "XFSCFWAlertView.h"

@interface XFGiveCarServiceController ()<UITableViewDelegate,UITableViewDataSource,XFGiveCarServiceCellDelegate,XFSCFWAlertViewDelegate>

@property (nonatomic, strong) UIButton *yueBtn;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *notSureBtn;
@property (nonatomic, strong) UIButton *haveSureBtn;
@property (nonatomic, strong) UIButton *haveCompletedBtn;
@property (nonatomic, strong) UIButton *haveCancelBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *SCFWArr;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) UILabel *noDataLabel;


@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation XFGiveCarServiceController


-(NSMutableArray *)SCFWArr
{
    if(!_SCFWArr)
    {
        _SCFWArr=[NSMutableArray array];
    }
    return _SCFWArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getFWDataWithType:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    
    self.navigationItem.title = @"送车服务";
    
    [self setupSubViews];
    
    
}


-(void)setupSubViews
{
    UIImageView *bgImv=[[UIImageView alloc] init];
    bgImv.image=IMAGENAME(@"songchefuwu");
    bgImv.contentMode=UIViewContentModeScaleAspectFill;
    bgImv.clipsToBounds=YES;
    [self.view addSubview:bgImv];
//    bgImv.backgroundColor=MAINGREEN;
    bgImv.userInteractionEnabled=YES;
    bgImv.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(250);
    
    UIButton *yueBtn = [[UIButton alloc] init];
    yueBtn.layer.cornerRadius=15;
    yueBtn.layer.borderColor=MAINGREEN.CGColor;
    yueBtn.layer.borderWidth=1;
    [yueBtn setTitle:@"立即约车" forState:UIControlStateNormal];
    [yueBtn setTitleColor:MAINGREEN forState:UIControlStateNormal];
    yueBtn.titleLabel.font=XFont(14);
    //        [yueBtn setImage:IMAGENAME(@"shangchuantu") forState:UIControlStateNormal];
    [bgImv addSubview:yueBtn];
    self.yueBtn=yueBtn;
    [[yueBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    
        XFGiveCarServiceYCController *vc = [[XFGiveCarServiceYCController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    yueBtn.sd_layout
    .centerXEqualToView(bgImv)
    .bottomSpaceToView(bgImv, 40)
    .widthIs(80)
    .heightIs(30);
    
    
    
    NSArray * orderStateArr = @[@"全部",@"未确认",@"已确认",@"已完成",@"已取消"];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:orderStateArr];
    segmentedControl.frame = CGRectMake(0, 0, SCREENW, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = RGBCOLOR(235, 235, 235);
    segmentedControl.verticalDividerWidth = 1.0f;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : XFont(14),NSForegroundColorAttributeName : BlACKTEXT};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : MAINGREEN};
    segmentedControl.selectionIndicatorColor = MAINGREEN;
    segmentedControl.selectionIndicatorHeight = 0;//隐藏滑块
    self.segmentedControl = segmentedControl;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    segmentedControl.sd_layout
    .topSpaceToView(bgImv, 0)
    .leftEqualToView(self.view)
    .heightIs(40)
    .rightEqualToView(self.view);

    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFGiveCarServiceCell class] forCellReuseIdentifier:@"serCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString * str = [NSString stringWithFormat:@"%d",(int)self.segmentedControl.selectedSegmentIndex+1];
        [self getFWDataWithType:str];
    }];

    tableView.sd_layout
    .topSpaceToView(segmentedControl, 1)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
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

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    [self.tableView.mj_header beginRefreshing];
    
}


- (void) getFWDataWithType:(NSString *)type {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].minShowTime = 0.4;
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:type forKey:@"status"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/Car/send_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.SCFWArr removeAllObjects];
            [self.SCFWArr addObjectsFromArray:[XFGiveCarServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.SCFWArr.count==0)
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
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.SCFWArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XFGiveCarServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serCell" forIndexPath:indexPath];

    cell.model=self.SCFWArr[indexPath.section];
    
    cell.confirmUseCarBtn.tag=indexPath.section;
    cell.delegate=self;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XFGiveCarServiceDetailController *vc = [[XFGiveCarServiceDetailController alloc] init];
    vc.model = self.SCFWArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)XFGiveCarServiceCell:(XFGiveCarServiceCell *)cell didClickUseBtn:(UIButton *)button
{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"section==%ld", [path section]);
    XFGiveCarServiceModel *model=self.SCFWArr[path.section];
    _appId=model.applyId;
    NSLog(@"id==%@", _appId);
    
    XFSCFWAlertView *alertView = [[XFSCFWAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您已交定金%@元,还需付剩余金额%@元,即可使用车辆",model.pay_money,model.get_money]];
    alertView.delegate=self;
    [alertView show];
}

-(void)XFSCFWAlertView:(XFSCFWAlertView *)contentView didClickSureBtn:(UIButton *)button
{
    contentView.sureBlock = ^{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].minShowTime = 0.4;
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:_appId forKey:@"id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"%@/Car/car_arrive",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success:%@",responseObject);
            if ([responseObject[@"status"] intValue] == 1) {
                
                [self getFWDataWithType:@"4"];
                [self.allBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                [self.notSureBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                [self.haveSureBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                [self.haveCompletedBtn setTitleColor:MAINGREEN forState:UIControlStateNormal];
                [self.haveCancelBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"error:%@",error);
        }];
        
    };

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
