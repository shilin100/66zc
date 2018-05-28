//
//  XFFaPiaoViewController.m
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFFaPiaoViewController.h"
#import "XFFaPiaoView.h"
#import "XFFaPiaoViewCell.h"
#import "XFFaPiaoSubmitViewController.h"
#import "XFFaPiaoModel.h"

@interface XFFaPiaoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XFFaPiaoView *contentView;
@property (nonatomic, strong) NSMutableArray *fpModelArr;
@property (nonatomic, assign) float syMoney;


@end

@implementation XFFaPiaoViewController

-(NSMutableArray *)fpModelArr
{
    if(!_fpModelArr)
    {
        _fpModelArr=[NSMutableArray array];
    }
    return _fpModelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"发票开具";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 54, 30);
    [rightBtn setTitle:@"开票" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = XFont(13);
    [rightBtn addTarget:self action:@selector(kpClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    
    XFFaPiaoView *contentView = [[XFFaPiaoView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 150)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    
    [self setupSubs];
    [self getData];
}

-(void)kpClick
{
    XFFaPiaoSubmitViewController *vc=[[XFFaPiaoSubmitViewController alloc] init];
    vc.syMoney=_syMoney;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupSubs
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[XFFaPiaoViewCell class] forCellReuseIdentifier:@"fpCell"];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
    tableView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightEqualToView(self.view)
    .leftEqualToView(self.view)
    .heightIs(SCREENH-64-self.contentView.frame.size.height);
    
}


- (void) getData {
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/invoice_money",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            self.contentView.yjMoneyLabel2.text=[NSString stringWithFormat:@"%.2f",[responseObject[@"a_money"] floatValue]];
            self.contentView.ykMoneyLabel2.text=[NSString stringWithFormat:@"%.2f",[responseObject[@"v_money"] floatValue]];
            self.contentView.syMoneyLabel2.text=[NSString stringWithFormat:@"%.2f",[responseObject[@"s_money"] floatValue]];
            _syMoney=[responseObject[@"s_money"] floatValue];
            
            [self.fpModelArr removeAllObjects];
            [self.fpModelArr addObjectsFromArray:[XFFaPiaoModel mj_objectArrayWithKeyValuesArray:responseObject[@"money_list"]]];
            [self.tableView reloadData];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.fpModelArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XFFaPiaoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fpCell" forIndexPath:indexPath];
    cell.model = self.fpModelArr[indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
