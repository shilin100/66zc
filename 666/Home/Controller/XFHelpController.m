//
//  XFHelpController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHelpController.h"
#import "XFHelpInfoModel.h"

@interface XFHelpController ()
@property (nonatomic, strong) NSMutableArray<XFHelpInfoModel *> *infoModels;
@end

@implementation XFHelpController
#pragma mark - Lazy
- (NSMutableArray<XFHelpInfoModel *> *)infoModels{
    if (!_infoModels) {
        _infoModels = [NSMutableArray array];
    }
    return _infoModels;
}

#pragma mark - SYS
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"帮助中心";
    self.tableView.backgroundColor = HEXCOLOR(@"eeeeee");
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getData];
}
#pragma mark - FUNC
- (void) getData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中...";
    
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:model.token forKey:@"token"];
    [params setObject:model.uid forKey:@"uid"];
    [params setValue:@1 forKey:@"page"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/System/help",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES afterDelay:0.8];
        if ([responseObject[@"status"] intValue] == 1) {
            [self.infoModels removeAllObjects];
            [self.infoModels addObjectsFromArray:[XFHelpInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"连接超时"];
        [SVProgressHUD dismissWithDelay:1.2];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.self.infoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"helpCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = XFont(13);
        cell.textLabel.textColor = HEXCOLOR(@"333333");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.infoModels valueForKeyPath:@"title"][indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* urlStr = self.infoModels[indexPath.row].url;
    XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
    webViewController.urlString = urlStr;
    webViewController.webTitle = self.infoModels[indexPath.row].title;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
