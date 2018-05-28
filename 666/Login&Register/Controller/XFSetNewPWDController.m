//
//  XFSetNewPWDController.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSetNewPWDController.h"
#import "XFDoLoginController.h"

@interface XFSetNewPWDController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdOneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTwoTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation XFSetNewPWDController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAME(@"navbg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
    // 初始化子控件
    [self setupSubs];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - FUNC
/**初始化子控件*/
- (void) setupSubs {
    self.doneBtn.layer.cornerRadius = self.doneBtn.height * 0.5;
    self.doneBtn.clipsToBounds = YES;
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**完成*/
- (IBAction)doneBtnClick {
    [self.view endEditing:YES];
    
    NSString *pwd = self.pwdOneTF.text;
    NSString *pwdRep = self.pwdTwoTF.text;
    
    if (!pwd.length || !pwdRep.length) { // 不能为空
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码不能为空";
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }else if (pwd.length < 6 || pwdRep.length < 6){ // 不能少于6位
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请设置6位数以上密码";
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }else if ([pwd isEqualToString:pwdRep]) { // 正确,修改
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:self.number forKey:@"phone"];
        [params setObject:self.inviteCode forKey:@"code"];
        [params setObject:[[pwd md5String] substringWithRange:NSMakeRange(8, 16)] forKey:@"newpwd"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/Forgetpwd?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            /*
             {
             info = "修改成功!";
             status = 1;
             }
             */
            if ([responseObject[@"status"] intValue] == 1) { // 修改成功
                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.6 completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"连接超时"];
            [SVProgressHUD dismissWithDelay:1.2];
        }];
    }else{ // 两次输入不同
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次密码不同请重新输入";
        [hud hideAnimated:YES afterDelay:1.2];
    }
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
