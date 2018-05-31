//
//  XFDriveApplyVC.m
//  666
//
//  Created by 123 on 2018/5/2.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFDriveApplyVC.h"
#import "XFDriveApplyTableViewCell.h"
#import "XFDriverApplyModel.h"
#import "XFApplyOrderCenterVC.h"
#import "XFApplyNowVC.h"

@interface XFDriveApplyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _popoverWidth;
    CGFloat _popoverHeight;
    CGSize _popoverArrowSize;
    CGFloat _popoverCornerRadius;
    CGFloat _animationIn;
    CGFloat _animationOut;
    BOOL _animationSpring;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic,weak) UIButton * popButton;
@property (nonatomic,strong) NSMutableArray * popArray;
@property (nonatomic,assign) BOOL didSelectedPopView;
@property (nonatomic,assign) NSInteger choosedCellIndex;

@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *school;
@property (nonatomic,weak) UIButton * areaBtn;
@property (nonatomic,weak) UIButton * schoolBtn;

@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSMutableArray *schoolArray;

@end

@implementation XFDriveApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"驾校报名";
    UIImage *rightImage = [[UIImage imageNamed:@"order_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(orderListAction)];

    self.dataArray = [NSMutableArray array];
    
    self.area = @"全部区域";
    self.school = @"全部驾校";
    
    [self setupUI];
}

-(void)setupUI{
    UIButton *areaBtn = [[UIButton alloc] init];
    [areaBtn setTitle:@"全部区域 ▼" forState:UIControlStateNormal];
    [areaBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    areaBtn.backgroundColor = WHITECOLOR;
    areaBtn.titleLabel.font = XFont(13);
    [areaBtn addTarget:self action:@selector(areaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaBtn];
    areaBtn.frame = CGRectMake(0, 0, SCREENW/2, 44);
    self.areaBtn = areaBtn;
    
    UIButton *schoolBtn = [[UIButton alloc] init];
    [schoolBtn setTitle:@"全部驾校 ▼" forState:UIControlStateNormal];
    [schoolBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    schoolBtn.backgroundColor = WHITECOLOR;
    schoolBtn.titleLabel.font = XFont(13);
    [schoolBtn addTarget:self action:@selector(schoolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:schoolBtn];
    schoolBtn.frame = CGRectMake(SCREENW/2+1, 0, SCREENW/2-1, 44);
    self.schoolBtn = schoolBtn;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, SCREENH-64-44-1) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFDriveApplyTableViewCell class] forCellReuseIdentifier:@"XFDriveApplyCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.area = @"全部区域";
        self.school = @"全部驾校";
        [self.schoolBtn setTitle:@"全部驾校" forState:UIControlStateNormal];
        [self.areaBtn setTitle:@"全部区域" forState:UIControlStateNormal];

        [self loadNewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];
    
    [self loadNewData];
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, _popoverWidth, _popoverHeight);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.popTableView = blueView;
    [self resetPopover];
    
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂无驾校";
    _noDataLabel.textColor=HEXCOLOR(@"999999");
    _noDataLabel.font=XFont(14);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.sd_layout
    .centerXEqualToView(tableView)
    .centerYEqualToView(tableView)
    .widthIs(100)
    .heightIs(30);

    
}

-(void)orderListAction{
    XFApplyOrderCenterVC * vc = [XFApplyOrderCenterVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)areaBtnClick:(UIButton*)sender{
    self.popArray = nil;
    self.popArray = [NSMutableArray arrayWithArray:self.areaArray];
    self.popButton = sender;
    [self updatePopTableViewFrame:sender];
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    //    NSLog(@"x:%f,y:%f",CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.popTableView
                       inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:sender];
        
        if (weakSelf.didSelectedPopView) {
            weakSelf.area = weakSelf.popButton.titleLabel.text;
            weakSelf.school = @"全部驾校";
            [weakSelf.schoolBtn setTitle:@"全部驾校" forState:UIControlStateNormal];
            [weakSelf loadNewData];
        }
        weakSelf.didSelectedPopView = NO;
    };
    [_popTableView reloadData];
    
    
}

-(void)schoolBtnClick:(UIButton*)sender{
    self.popArray = nil;
    self.popArray = [NSMutableArray arrayWithArray:self.schoolArray];
    self.popButton = sender;
    [self updatePopTableViewFrame:sender];
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    //    NSLog(@"x:%f,y:%f",CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.popTableView
                       inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:sender];
        
        if (weakSelf.didSelectedPopView) {
            weakSelf.area = @"全部区域";
            [weakSelf.areaBtn setTitle:@"全部区域" forState:UIControlStateNormal];
            weakSelf.school = weakSelf.popButton.titleLabel.text;
            [weakSelf loadNewData];
        }
        weakSelf.didSelectedPopView = NO;
    };
    [_popTableView reloadData];
    
    
}

#pragma mark popview

- (void)resetPopover {
    self.popover = [DXPopover new];
    self.popover.cornerRadius = 0;
    self.popover.arrowSize = CGSizeMake(0, 0);
    //    self.popover.maskType = 1;
    _popoverWidth = 280.0;
    _popoverHeight = 180.0;
}
- (void)updatePopTableViewFrame:(UIButton*)sender {
    CGRect tableViewFrame = self.popTableView.frame;
    _popoverWidth = sender.frame.size.width;
    if (self.popArray.count < 6) {
        _popoverHeight = self.popArray.count * 30.0;
    } else {
        _popoverHeight = 6 * 30.0;
    }
    tableViewFrame.size.width = _popoverWidth;
    tableViewFrame.size.height = _popoverHeight;
    self.popTableView.frame = tableViewFrame;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = [UIColor whiteColor];
}
- (void)showPopover:(UIButton*)sender WithSelector:(SEL)sel{
    self.popButton = sender;
    [self updatePopTableViewFrame:sender];
    
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    //    NSLog(@"x:%f,y:%f",CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame));
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.popTableView
                       inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:sender];
        if (sel != nil) {
            [weakSelf performSelector:sel];
        }
    };
}
- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
    
}


- (void) loadNewData {
    
    _page=1;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    [params setObject:self.school forKey:@"d_name"];
    [params setObject:self.area forKey:@"area"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/StudyCar/index",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[XFDriverApplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.dataArray.count==0)
            {
                _noDataLabel.hidden=NO;
            }
            else
            {
                _noDataLabel.hidden=YES;
            }
            if (!self.areaArray) {
                NSArray * temp = [NSArray arrayWithArray:[responseObject[@"data"] valueForKeyPath:@"area"]];
                NSSet *set = [NSSet setWithArray:temp];
                self.areaArray = [NSMutableArray arrayWithArray:[set allObjects]];
                [self.areaArray insertObject:@"全部区域" atIndex:0];
            }
            if (!self.schoolArray) {
                NSArray * temp = [NSArray arrayWithArray:[responseObject[@"data"] valueForKeyPath:@"d_name"]];
                NSSet *set = [NSSet setWithArray:temp];
                self.schoolArray = [NSMutableArray arrayWithArray:[set allObjects]];
                [self.schoolArray insertObject:@"全部驾校" atIndex:0];
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

-(void)loadMoreData
{
    _page++;
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    [params setObject:self.school forKey:@"d_name"];
    [params setObject:self.area forKey:@"area"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/StudyCar/index",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.dataArray addObjectsFromArray:[XFDriverApplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
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


#pragma mark tableViewDelegate/DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.popTableView) {
        return self.popArray.count;
    } else return [self.dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.popTableView) {
        static NSString *cellId = @"plPopTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        cell.textLabel.text = self.popArray[indexPath.row];
        
        return cell;
        
        
    }else{
        XFDriveApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFDriveApplyCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model=self.dataArray[indexPath.row];
        WeakSelf;
        cell.applyCellBlock = ^(id model) {
            __block XFApplyNowVC * vc = [XFApplyNowVC new];
            vc.model = weakSelf.dataArray[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            vc.applyNowBlock = ^{
                __block XFApplyOrderCenterVC * orderVC = [XFApplyOrderCenterVC new];
                orderVC.index = 1;
                [weakSelf.navigationController pushViewController:orderVC animated:YES];

            };
        };

        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.popTableView) {
        return 30;
    }else return 180;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _popTableView) {
        _didSelectedPopView = YES;
        _choosedCellIndex = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.popover dismiss];
        [self.popButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    }
    
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
