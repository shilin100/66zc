//
//  XFIWantPeiLianController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFIWantPeiLianController.h"
#import "XFIWantPeiLianCell.h"
#import "XFIWantPLModel.h"

@interface XFIWantPeiLianController ()<UITableViewDelegate,UITableViewDataSource>
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
@property (nonatomic, strong) NSMutableArray<XFIWantPLModel *> *PLmodelArr;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *noDataLabel;

//popview
@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic,weak) UIButton * popButton;
@property (nonatomic,strong) NSMutableArray * popArray;
@property (nonatomic,assign) BOOL didSelectedPopView;
@property (nonatomic,assign) NSInteger choosedCellIndex;

@property (nonatomic, strong) NSString *area;
@property (nonatomic, assign) int state;
@property (nonatomic,weak) UIButton * areaBtn;
@property (nonatomic,weak) UIButton * stateBtn;

@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSMutableArray *stateArray;


@end

@implementation XFIWantPeiLianController

-(NSMutableArray<XFIWantPLModel *> *)PLmodelArr
{
    if(!_PLmodelArr)
    {
        _PLmodelArr=[NSMutableArray array];
    }
    return _PLmodelArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    
    self.navigationItem.title = @"我要陪练";
    
    self.area = @"全部";
    self.state = 0;
    self.stateArray = [NSMutableArray arrayWithArray:@[@"全部",@"空闲",@"已约",@"停止接单"]];
    [self setupSubViews];
    
}

-(void)setupSubViews
{
    UIImage *rightImage = [IMAGENAME(@"kefu") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(callClick)];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    rightBtn.frame = CGRectMake(0, 0, 54, 30);
//    [rightBtn setTitle:@"客服" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = XFont(13);
//    [rightBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    
    
    
    UIButton *areaBtn = [[UIButton alloc] init];
    [areaBtn setTitle:@"选择服务范围 ▼" forState:UIControlStateNormal];
    [areaBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    areaBtn.backgroundColor = WHITECOLOR;
    areaBtn.titleLabel.font = XFont(13);
    [areaBtn addTarget:self action:@selector(areaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaBtn];
    areaBtn.frame = CGRectMake(0, 0, SCREENW/2, 44);
    self.areaBtn = areaBtn;
    
    UIButton *stateBtn = [[UIButton alloc] init];
    [stateBtn setTitle:@"空闲状态 ▼" forState:UIControlStateNormal];
    [stateBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    stateBtn.backgroundColor = WHITECOLOR;
    stateBtn.titleLabel.font = XFont(13);
    [stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stateBtn];
    stateBtn.frame = CGRectMake(SCREENW/2+1, 0, SCREENW/2-1, 44);
    self.stateBtn = stateBtn;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, SCREENW, SCREENH-64-55) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFIWantPeiLianCell class] forCellReuseIdentifier:@"plCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [self loadMoreData];
    }];
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, _popoverWidth, _popoverHeight);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.popTableView = blueView;
    [self resetPopover];
    
    
    _noDataLabel=[[UILabel alloc] init];
    _noDataLabel.hidden=YES;
    _noDataLabel.textAlignment=NSTextAlignmentCenter;
    _noDataLabel.text=@"暂无教练";
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
    [params setObject:@(self.state) forKey:@"status"];
    [params setObject:self.area forKey:@"area"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/coach_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.PLmodelArr removeAllObjects];
            [self.PLmodelArr addObjectsFromArray:[XFIWantPLModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
            if(self.PLmodelArr.count==0)
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
                [self.areaArray insertObject:@"全部" atIndex:0];
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
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    [params setObject:@(self.state) forKey:@"status"];
    [params setObject:self.area forKey:@"area"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/coach_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.PLmodelArr addObjectsFromArray:[XFIWantPLModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
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


-(void)callClick
{
    NSLog(@"打电话");
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"02759762081"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.popTableView) {
        return self.popArray.count;
    } else return [self.PLmodelArr count];
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
        XFIWantPeiLianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.model=self.PLmodelArr[indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.popTableView) {
        return 30;
    }else return 80;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] init];
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] init];
//}

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

#pragma mark btnAction

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
            weakSelf.state = 0;
            [weakSelf.stateBtn setTitle:@"全部" forState:UIControlStateNormal];
            [weakSelf loadNewData];
        }
        weakSelf.didSelectedPopView = NO;
    };
    [_popTableView reloadData];

    
}

-(void)stateBtnClick:(UIButton*)sender{
    self.popArray = nil;
    self.popArray = [NSMutableArray arrayWithArray:self.stateArray];
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
            weakSelf.area = @"全部";
            [weakSelf.areaBtn setTitle:@"全部" forState:UIControlStateNormal];
            weakSelf.state = [weakSelf.stateArray indexOfObject:weakSelf.popButton.titleLabel.text];
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
