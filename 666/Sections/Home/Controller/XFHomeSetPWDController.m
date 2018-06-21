//
//  XFHomeSetPWDController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeSetPWDController.h"
#import "XFLoginNaviController.h"

@interface XFHomeSetPWDController ()
@property (weak, nonatomic) IBOutlet UITextField *PWDTF;
@property (weak, nonatomic) IBOutlet UITextField *PWDTFRep;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation XFHomeSetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置新密码";
    
    self.doneBtn.layer.cornerRadius = self.doneBtn.height * 0.5;
    self.doneBtn.clipsToBounds = YES;
}
- (IBAction)doneBtnClick {
    [self.view endEditing:YES];
    
    NSString *pwd = self.PWDTF.text;
    NSString *pwdRep = self.PWDTFRep.text;
    
    if (!pwd.length || !pwdRep.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码不能为空";
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }else if (pwd.length < 6 || pwdRep.length < 6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请设置6位数以上密码";
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }else if ([pwd isEqualToString:pwdRep]) {
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:self.number forKey:@"phone"];
        [params setObject:self.inviteCode forKey:@"code"];
        [params setObject:[[pwd md5String] substringWithRange:NSMakeRange(8, 16)] forKey:@"newpwd"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Index/Forgetpwd?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {

            if ([responseObject[@"status"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.6 completion:^{
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:[NSBundle mainBundle]];
                    XFLoginNaviController *loginNav = sb.instantiateInitialViewController;
                    [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
                    
                    [USERDEFAULT setBool:NO forKey:@"isLogin"];
                    
                    NSFileManager *fileMgr = [NSFileManager defaultManager];
                    if ([fileMgr fileExistsAtPath:LoginModel_Doc_path]) {
                        [fileMgr removeItemAtPath:LoginModel_Doc_path error:nil];
                    }
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"连接超时"];
            [SVProgressHUD dismissWithDelay:1.2];
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"两次密码不同请重新输入";
        [hud hideAnimated:YES afterDelay:1.2];
    }
}


@end
