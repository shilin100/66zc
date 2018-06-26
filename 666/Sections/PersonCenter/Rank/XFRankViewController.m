//
//  XFRankViewController.m
//  666
//
//  Created by 123 on 2018/6/23.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRankViewController.h"
#import "XFRankTableViewCell.h"
#import "XFMyRankView.h"

@interface XFRankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *myData;
@property (nonatomic, strong) XFMyRankView *myRankView;

@property (nonatomic, assign) int rankType;

@end

@implementation XFRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"总排行榜";
    self.dataArray = [NSMutableArray array];
    self.rankType = 0;
    
    
    NSArray * orderStateArr = @[@"总签到",@"用车时长",@"总公里数",@"总消费"];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:orderStateArr];
    segmentedControl.frame = CGRectMake(0, 0, SCREENW, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    segmentedControl.verticalDividerEnabled = YES;
//    segmentedControl.verticalDividerColor = RGBCOLOR(235, 235, 235);
//    segmentedControl.verticalDividerWidth = 1.0f;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : XFont(14),NSForegroundColorAttributeName : BlACKTEXT};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : MAINGREEN};
    segmentedControl.selectionIndicatorColor = MAINGREEN;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl = segmentedControl;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREENW, SCREENH-64-40) style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFRankTableViewCell class] forCellReuseIdentifier:@"XFRankCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    tableView.sd_layout
    .topSpaceToView(segmentedControl, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 62);

    
    XFMyRankView * bottomView = [[XFMyRankView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.sd_layout
    .heightIs(62)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    self.myRankView = bottomView;

    
    [self requestRank];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.rankType = (int)segmentedControl.selectedSegmentIndex;
    
    NSArray * param = self.myData[self.rankType];
    [self.myRankView setParams:param.firstObject RankType:self.rankType];
    
    [self.tableView reloadData];
}


-(void)requestRank{
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/car/useRanking"] withDic:nil Succeed:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:@[responseObject[@"data"][@"singintimes"],
                                                              responseObject[@"data"][@"times"],
                                                              responseObject[@"data"][@"totaldistance"],
                                                              responseObject[@"data"][@"money"]]];
            self.myData = @[responseObject[@"data"][@"mysingintimes"],
                            responseObject[@"data"][@"mytimes"],
                            responseObject[@"data"][@"mytotaldistance"],
                            responseObject[@"data"][@"mymoney"]];
            
            NSArray* myParam = self.myData.firstObject;
            [self.myRankView setParams:myParam.firstObject RankType:self.rankType];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        
    } andFaild:^(NSError *error) {
        
    }];
}


#pragma mark tableViewDelegate/DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 0;
    }else{
        NSArray * temp = self.dataArray[self.rankType];
        return temp == nil ? 0 : temp.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFRankCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray * temp = self.dataArray[self.rankType];

    NSDictionary * param = temp[indexPath.row];
    
    [cell setParams:param RankType:self.rankType];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 2) {
        return 60;
    }else
        return 49;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    XFApplyOrderDetailVC * vc = [XFApplyOrderDetailVC new];
//    vc.model = self.currentArray[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
