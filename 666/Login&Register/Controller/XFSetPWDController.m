//
//  XFSetPWDController.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSetPWDController.h"

@interface XFSetPWDController ()
@property (weak, nonatomic) IBOutlet UILabel *oneLbl;
@property (weak, nonatomic) IBOutlet UILabel *twoLbl;
@property (weak, nonatomic) IBOutlet UILabel *threeLbl;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTFagain;
@property (weak, nonatomic) IBOutlet UIButton *doRegisterBtn;

@end

@implementation XFSetPWDController
#pragma mark - SYS
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"number:%@",self.number);
    
    self.navigationItem.title = @"注册";
    // 初始化子控件
    [self setupSubs];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - FUNC
/**初始化子控件*/
- (void) setupSubs {
    self.oneLbl.layer.cornerRadius = self.oneLbl.height * 0.5;
    self.oneLbl.clipsToBounds = YES;
    
    self.twoLbl.layer.cornerRadius = self.twoLbl.height * 0.5;
    self.twoLbl.clipsToBounds = YES;
    
    self.threeLbl.layer.cornerRadius = self.threeLbl.height * 0.5;
    self.threeLbl.clipsToBounds = YES;
    
    self.doRegisterBtn.layer.cornerRadius = self.doRegisterBtn.height * 0.5;
    self.doRegisterBtn.clipsToBounds = YES;
    
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**注册*/
- (IBAction)doRegisterBtnClick {
    [self.view endEditing:YES];

    NSString *pwd = self.pwdTF.text;
    NSString *pwdRep = self.pwdTFagain.text;
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
    }else if ([pwd isEqualToString:pwdRep]) { // 正确,执行注册
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:self.number forKey:@"phone"];
        [params setObject:[[pwd md5String] substringWithRange:NSMakeRange(8, 16)] forKey:@"pwd"];
        if([_inviteCode length])
        {
            [params setObject:self.inviteCode forKey:@"r_id"];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/Register?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            /*
             {
             img = "";
             info = "";
             number = dojI;
             phone = 15629169373;
             status = 1;
             token = 6389BC8E00D512D9A0B48E1FA81DB102;
             type = 1;
             uid = 205;
             }
             */
            if ([responseObject[@"status"] intValue] == 1) { // 注册成功
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [SVProgressHUD dismissWithDelay:1.2 completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }else{ // 注册失败
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
            [SVProgressHUD dismissWithDelay:1.2];
        }];
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
