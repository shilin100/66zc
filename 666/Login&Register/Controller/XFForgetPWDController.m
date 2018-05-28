//
//  XFForgetPWDController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFForgetPWDController.h"
#import "XFSetNewPWDController.h"

@interface XFForgetPWDController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/**跳转*/
@property (nonatomic, assign) BOOL isSegue;
/**验证码*/
@property (nonatomic, copy) NSString *inviteCode;
/**number*/
@property (nonatomic, copy) NSString *number;
@end

@implementation XFForgetPWDController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAME(@"navbg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
    
    self.infoLbl.text = @"请先获取短信验证码";
    // 初始化子控件
    [self setupSubs];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - FUNC
/**初始化子控件*/
- (void) setupSubs {
    self.getCodeBtn.layer.cornerRadius = self.getCodeBtn.height * 0.5;
    self.getCodeBtn.clipsToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.height * 0.5;
    self.nextBtn.clipsToBounds = YES;
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**获取验证码*/
- (IBAction)getCodeBtnClick {
    [self.view endEditing:YES];
    
    // number
    NSString *number = self.numberTF.text;
    if ([XFTool validateCellPhoneNumber:number]) {
        // 获取验证码
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:number forKey:@"phone"];
        [params setObject:@2 forKey:@"type"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/GetCode?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            /*
             {
             code = 741477;
             info = "";
             status = 1;
             }
             */
            if ([responseObject[@"status"] intValue] == 1) { // 获取成功
                self.inviteCode = responseObject[@"code"];
                self.number = number;
                
                self.infoLbl.text = [NSString stringWithFormat:@"已成功向%@发送验证码",number];
                
                [self openCountdown]; // 开启倒计时
                
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [SVProgressHUD dismissWithDelay:1.2];
                
            }else{ // 获取失败
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
            [SVProgressHUD dismissWithDelay:1.2];
        }];
        
    }else{ // 手机号错误
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写正确的手机号";
        [hud hideAnimated:YES afterDelay:1.2];
    }
    
}
/**下一步*/
//- (IBAction)nextBtnClick {
//
//}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重发(%d)", seconds] forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XFSetNewPWDController *vc = segue.destinationViewController;
    vc.number = self.number;
    vc.inviteCode = self.inviteCode;
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([self.numberTF.text isEqualToString:self.number] && [self.codeTF.text isEqualToString:self.inviteCode]) {
        self.isSegue = YES;
    }else{ // 错误
        self.isSegue = NO;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"手机号或验证码错误";
        [hud hideAnimated:YES afterDelay:1.2];
    }
    return self.isSegue;
}
@end
