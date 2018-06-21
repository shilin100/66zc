//
//  XFDoLoginController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFDoLoginController.h"
#import "XFHomeNavController.h"
#import "XFHomeController.h"

@interface XFDoLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *numberContent;
@property (weak, nonatomic) IBOutlet UIView *pwdContent;


@end

@implementation XFDoLoginController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.numberTF.text = @"13566665555";
//    self.pwdTF.text = @"135522";
    
    if([[USERDEFAULT objectForKey:@"account"] length])
    {
        self.numberTF.text=[USERDEFAULT objectForKey:@"account"];
    }
    else
    {
        self.numberTF.text=@"";
    }
    
    self.view.backgroundColor = WHITECOLOR;
    // 初始化子控件
    [self setupSubs];
    
}

#pragma mark - FUNC
/**初始化子控件*/
- (void) setupSubs {
    // numberContent
    self.numberContent.layer.cornerRadius = self.numberContent.height * 0.5;
    self.numberContent.clipsToBounds = YES;
    self.numberContent.layer.borderWidth = 0.5;
    self.numberContent.layer.borderColor = MAINGREEN.CGColor;
    
    // pwdContent
    self.pwdContent.layer.cornerRadius = self.pwdContent.height * 0.5;
    self.pwdContent.clipsToBounds = YES;
    self.pwdContent.layer.borderWidth = 0.5;
    self.pwdContent.layer.borderColor = MAINGREEN.CGColor;
    
    // 登录按钮
    self.loginBtn.layer.cornerRadius = self.loginBtn.height * 0.5;
    self.loginBtn.clipsToBounds = YES;
    
    UILabel * versionLabel = [UILabel new];
    versionLabel.font = XFont(10);
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取本地版本号
    NSString * localVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];

    versionLabel.text = [NSString stringWithFormat:@"v:%@",localVersion];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = WHITECOLOR;
    [self.view addSubview:versionLabel];
    versionLabel.sd_layout
    .bottomSpaceToView(self.view, 10)
    .rightEqualToView(self.view)
    .heightIs(30)
    .leftEqualToView(self.view);

}
/**返回*/
- (IBAction)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**登录*/
- (IBAction)loginBtnClick {
    NSString *number = self.numberTF.text;
    NSString *pwd = self.pwdTF.text;
    
    // 账号密码不能为空
    if (number.length == 0 || pwd.length == 0) {
        XFAlertView *alertView = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手机号或密码不能为空" sureBtn:@"确定" cancleBtn:nil];
        alertView.resultIndex = nil;
        [alertView showAlertView];
        return;
    }
    // 手机号合法性
//    if (![XFTool validateCellPhoneNumber:number] && number.length > 0 && pwd.length > 0) {
      if (number.length != 11) {
        XFAlertView *alertView = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" sureBtn:@"确定" cancleBtn:nil];
        alertView.resultIndex = nil;
        [alertView showAlertView];
        return;
    }
    // 登录操作
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:number forKey:@"name"];
    NSString *MD5PWD = [[pwd md5String] substringWithRange:NSMakeRange(8, 16)];
    [params setObject:MD5PWD forKey:@"pwd"];
//    NSLog(@"MD5PWD===%@",MD5PWD);
    /*
     [0]	(null)	@"imei" : @"9ED7C14F-9286-4538-8F31-DFD833206192"
     [1]	(null)	@"ostype" : (int)2
     [2]	(null)	@"name" : @"15629169373"
     [3]	(null)	@"pwd" : @"13955235245b2497"
     [4]	(null)	@"version" : (int)3
     
     [0]	(null)	@"imei" : @"9ED7C14F-9286-4538-8F31-DFD833206192"
     [1]	(null)	@"ostype" : (int)2
     [2]	(null)	@"name" : @"13566665555"
     [3]	(null)	@"pwd" : @"7df6923c5e64b205"
     [4]	(null)	@"version" : (int)3
     */
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Index/Login?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        /*
         @"phone" : @"13566665555"
         @"uid" : @"202"
         @"img" : @""
         @"number" : (no summary)
         @"user_state" : (long)2
         @"status" : (long)1
         @"info" : @""
         @"token" : @"C0D2977E647876FB60EC28400397BA91"
         @"type" : @"2"
         @"name" : @""
         @"car_state" : (long)0
         */
        NSLog(@"succ:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) { // 登录成功
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD dismissWithDelay:1.6];
            [SVProgressHUD dismissWithDelay:1.2 completion:^{
            // 保存信息
            [NSKeyedArchiver archiveRootObject:[XFLoginInfoModel mj_objectWithKeyValues:responseObject] toFile:LoginModel_Doc_path];
            [USERDEFAULT setBool:YES forKey:@"isLogin"];
            [USERDEFAULT setObject:number forKey:@"account"];
            [USERDEFAULT setObject:[MD5PWD dataUsingEncoding:NSUTF8StringEncoding] forKey:@"MD5PWD"];
            
            
            // 切换窗口根控制器为homeNav
            XFHomeController *homeVC = [[XFHomeController alloc] init];
            homeVC.isFromLogin = YES;
            XFHomeNavController *homeNav = [[XFHomeNavController alloc] initWithRootViewController:homeVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = homeNav;
        }];
        }else{ // 登录失败
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD dismissWithDelay:1.2];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}
#pragma mark - other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
