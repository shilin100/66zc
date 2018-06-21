//
//  XFHomeForgetController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeForgetController.h"
#import "XFHomeSetPWDController.h"

@interface XFHomeForgetController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *number;

@end

@implementation XFHomeForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    self.infoLbl.text = @"请先获取短信验证码";
    
    [self setupSubs];
    
}
- (void) setupSubs {
    self.codeBtn.layer.cornerRadius = self.codeBtn.height * 0.5;
    self.codeBtn.clipsToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.height * 0.5;
    self.nextBtn.clipsToBounds = YES;
}
- (IBAction)getCodeBtnClick {
    [self.view endEditing:YES];
    NSString *number = self.numberTF.text;
    if ([XFTool validateCellPhoneNumber:number]) {
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:number forKey:@"phone"];
        [params setObject:@2 forKey:@"type"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Index/GetCode?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            if ([responseObject[@"status"] intValue] == 1) {
                self.inviteCode = responseObject[@"code"];
                self.number = number;
                
                self.infoLbl.text = [NSString stringWithFormat:@"已成功向%@发送验证码",number];
                
                [self openCountdown];
                
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [SVProgressHUD dismissWithDelay:1.2];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
            [SVProgressHUD dismissWithDelay:1.2];
        }];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写正确的手机号";
        [hud hideAnimated:YES afterDelay:1.2];
    }
}
-(void)openCountdown{
    
    __block NSInteger time = 59;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重发(%d)", seconds] forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)nextBtnClick {
//    XFHomeSetPWDController *vc = [UIStoryboard storyboardWithName:@"XFHomeSetPWDController" bundle:nil].instantiateInitialViewController;
//    vc.number = self.number;
//    vc.inviteCode = self.inviteCode;
//    [self.navigationController pushViewController:vc animated:YES];
    
    if ([self.numberTF.text isEqualToString:self.number] && [self.codeTF.text isEqualToString:self.inviteCode]) {
        XFHomeSetPWDController *vc = [UIStoryboard storyboardWithName:@"XFHomeSetPWDController" bundle:nil].instantiateInitialViewController;
        vc.number = self.number;
        vc.inviteCode = self.inviteCode;
        [self.navigationController pushViewController:vc animated:YES];
    }else{ 
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"手机号或验证码错误";
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }
     
}


@end
