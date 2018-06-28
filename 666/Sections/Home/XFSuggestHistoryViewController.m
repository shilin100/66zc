//
//  XFSuggestHistoryViewController.m
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSuggestHistoryViewController.h"
#import "XFSuggestHistoryTableViewCell.h"
#import "XFSuggestModel.h"

@interface XFSuggestHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation XFSuggestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"历史反馈";
    self.view.backgroundColor = HEXCOLOR(@"eeeeee");
    self.dataArray = [NSMutableArray array];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, 400) style:UITableViewStylePlain];
    tableView.backgroundColor = WHITECOLOR;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFSuggestHistoryTableViewCell class] forCellReuseIdentifier:@"XFSuggestHistoryCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = HEXCOLOR(@"eeeeee");

    tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    self.tableView.estimatedRowHeight = 150;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    [self requestData];

}


-(void)requestData{
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@/user/suggest",BASE_URL] withDic:nil Succeed:^(NSDictionary *responseObject) {
        NSLog(@"responseObject***:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [self.dataArray addObjectsFromArray:[XFSuggestModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];

            [self.tableView reloadData];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } andFaild:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFSuggestHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFSuggestHistoryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.height = UITableViewAutomaticDimension;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0){
    return 150;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XFSuggestModel * model = self.dataArray[indexPath.row];
//
//    return model.status ? 139 : 98;
//}

@end
