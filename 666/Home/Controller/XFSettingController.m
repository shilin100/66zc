//
//  XFSettingController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSettingController.h"
#import "XFContactUsCell.h"
#import "XFLoginNaviController.h"
#import "XFForgetPWDController.h"
#import "XFSettingCell.h"

@interface XFSettingController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic,copy) NSString *trackViewUrl1;
@property (nonatomic, copy)  NSString  *localVersion;
@property (nonatomic,copy) NSString *releaseNotesStr;

@end

@implementation XFSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = HEXCOLOR(@"eeeeee");
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.rowHeight = 88*SCALE_HEIGHT;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    logoutBtn.hidden=YES;
    logoutBtn.backgroundColor = MAINGREEN;
    [logoutBtn setTitle:@"注销账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = XFont(13);
    logoutBtn.layer.cornerRadius = 44*SCALE_HEIGHT;
    logoutBtn.clipsToBounds = YES;
    [self.view insertSubview:logoutBtn aboveSubview:self.tableView];
    [[logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"是否退出登录？" sureBtn:@"确定" cancleBtn:@"取消"];
        alert.resultIndex = ^(AlertButtonType type) {
            switch (type) {
                case AlertButtonTypeSure:
                    [self doLogout];
                    break;
                case AlertButtonTypeCancel:
                    
                    break;
                    
                default:
                    break;
            }
        };
        [alert showAlertView];
    }];
    
    logoutBtn.sd_layout
    .bottomSpaceToView(self.view, 50*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(88*SCALE_HEIGHT);
}
- (void) doLogout {
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path exception:nil];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/Outlogin"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            [SVProgressHUD dismissWithDelay:1.0 completion:^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:[NSBundle mainBundle]];
                XFLoginNaviController *loginNav = sb.instantiateInitialViewController;
                [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
                
                [USERDEFAULT setBool:NO forKey:@"isLogin"];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                if ([fileMgr fileExistsAtPath:LoginModel_Doc_path]) {
                    [fileMgr removeItemAtPath:LoginModel_Doc_path error:nil];
                }
            }];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"退出失败"];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        static NSString *ID = @"settingCell";
        XFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[XFSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.icon.image = IMAGENAME(@"banbenhao");
        cell.titleLbl.text = @"当前版本";
        NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *verStr= [dicInfo objectForKey:@"CFBundleShortVersionString"];
        cell.titleLbl2.text=[NSString stringWithFormat:@"v%@",verStr];
        
        return cell;
    }
    else
    {
        static NSString *ID = @"settingCellTwo";
        XFContactUsCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cellTwo) {
            cellTwo = [[XFContactUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cellTwo.icon.image = IMAGENAME(@"mima");
        cellTwo.titleLbl.text = @"重置密码";
        
        return cellTwo;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        [self checkVersion];
    }
    
    if(indexPath.row==1)
    {
        XFForgetPWDController *vc = [UIStoryboard storyboardWithName:@"XFHomeForgetController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)checkVersion{
    //请求参数
    NSString *urlStr = [NSString stringWithFormat:@"%@id=%@",APP_checkUp,MY_APPID];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        NSArray *array=dic[@"results"];
        NSDictionary *dict = [array lastObject];
        _releaseNotesStr = dict[@"releaseNotes"];
        if (array.count>0) {
            NSDictionary *releaseInfo = [array objectAtIndex:0];
            NSString *latestVersion = [releaseInfo objectForKey:@"version"];
//            _trackViewUrl1 = [releaseInfo objectForKey:@"trackViewUrl"];//地址trackViewUrl
            //            NSString *trackName = [releaseInfo objectForKey:@"trackName"];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            //获取本地版本号
            _localVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            //            NSLog(@"currentVersion %@ CFBundleShortVersionString %@   %@",latestVersion ,_localVersion ,infoDict);
            if ([latestVersion compare:_localVersion]==NSOrderedDescending) {
//                [self alertUpdateControl:@"有新版本可供更新"];
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本%@",latestVersion] message:[NSString stringWithFormat:@"版本更新内容:\n%@",_releaseNotesStr] sureBtn:@"立即更新" cancleBtn:@"取消"];
                alert.resultIndex = ^(AlertButtonType type) {
                    switch (type) {
                        case AlertButtonTypeSure:
                        {
                            
                            NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/app/id1163445276"];
                            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                            
                        }
                            break;
                        case AlertButtonTypeCancel:
                            
                            break;
                        default:
                            break;
                    }
                };

                [alert showAlertView];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"已是最新版本"];
                [SVProgressHUD dismissWithDelay:0.85];
            }
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
    }];

    
    
}


@end
