//
//  XFCheckCodeController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFCheckCodeController.h"
#import "XFSetPWDController.h"

@interface XFCheckCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *oneLbl;
@property (weak, nonatomic) IBOutlet UILabel *twoLbl;
@property (weak, nonatomic) IBOutlet UILabel *threeLbl;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/**获取的验证码*/
@property (nonatomic, copy) NSString *checkCode;
/**跳转flag*/
@property (nonatomic, assign) BOOL isSegue;

@end

@implementation XFCheckCodeController
#pragma mark - SYS
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    // 初始化子控件
    [self setupSubs];
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
    
    self.timeBtn.layer.cornerRadius = self.timeBtn.height * 0.5;
    self.timeBtn.clipsToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.height * 0.5;
    self.nextBtn.clipsToBounds = YES;
    
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**下一步*/
//- (IBAction)nextBtnClick {

//    self.isSegue = YES;
//}
/**获取验证码*/
- (IBAction)getCodeBtnClick:(id)sender {
//    [self openCountdown];
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:self.number forKey:@"phone"];
    [params setValue:@1 forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Index/GetCode?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        /*
         {
         code = 723352;
         info = "";
         status = 1;
         }
         */
        if ([responseObject[@"status"] intValue] == 1) { //获取验证码成功
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1.2];
            [self openCountdown];
            self.checkCode = responseObject[@"code"];
        }else{ // 获取验证码失败
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
        [SVProgressHUD dismissWithDelay:1.2];
    }];
}
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
                [self.timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.timeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.timeBtn setTitle:[NSString stringWithFormat:@"重发(%d)", seconds] forState:UIControlStateNormal];
                [self.timeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XFSetPWDController *vc = segue.destinationViewController;
    vc.number = self.number;
    vc.inviteCode = self.inviteCode;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (!self.codeTF.text || self.codeTF.text.length != 6 || ![self.codeTF.text isEqualToString:self.checkCode]) { // 验证码错误
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        [SVProgressHUD dismissWithDelay:1.2];
        self.isSegue = NO;
    }else{
        self.isSegue = YES;
    }
    return self.isSegue;
}
@end
