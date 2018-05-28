//
//  XFRegisterViewController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFRegisterViewController.h"
#import "XFCheckCodeController.h"

@interface XFRegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *oneLbl;
@property (weak, nonatomic) IBOutlet UILabel *twoLbl;
@property (weak, nonatomic) IBOutlet UILabel *threeLbl;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**跳转flag*/
@property (nonatomic, assign) BOOL isSegue;
@end

@implementation XFRegisterViewController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:IMAGENAME(@"navbg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAME(@"navbg") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    
    self.numberTF.text = @"";
    
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
    
    self.getCodeBtn.layer.cornerRadius = self.getCodeBtn.height * 0.5;
    self.getCodeBtn.clipsToBounds = YES;
    
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**查看协议*/
- (IBAction)dealBtnClick {
//    NSString* urlStr = @"https://www.baidu.com";
//    XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
//    webViewController.urlString = urlStr;
//    [self.navigationController pushViewController:webViewController animated:YES];
    [self requestDelegateUrl];
}

-(void)requestDelegateUrl{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/user_deal",BASE_URL] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            NSString* urlStr = responseObject[@"url"];
            XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
            webViewController.urlString = urlStr;
            [self.navigationController pushViewController:webViewController animated:YES];

            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:0.85];

            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        [SVProgressHUD dismissWithDelay:0.85];

    }];

}

/**下一步*/
//- (IBAction)getCodeBtnClick {
//    [self.view endEditing:YES];
////    self.isSegue = self.numberTF.text.length > 0 ? YES : NO;
//    // 判断手机号
//    NSString *number = self.numberTF.text;
//    if ([XFTool validateCellPhoneNumber:number]) {
//        self.isSegue = YES;
//    }else{
//        self.isSegue = NO;
//
//        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
//        [SVProgressHUD dismissWithDelay:1.2];
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XFCheckCodeController *vc = segue.destinationViewController;
    vc.number = self.numberTF.text;
    vc.inviteCode = self.inviteTF.text;
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    return self.isSegue;
    [self.view endEditing:YES];
    //    self.isSegue = self.numberTF.text.length > 0 ? YES : NO;
    // 判断手机号
    NSString *number = self.numberTF.text;
    if ([XFTool validateCellPhoneNumber:number]) {
        self.isSegue = YES;
    }else{
        self.isSegue = NO;
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
        [SVProgressHUD dismissWithDelay:1.2];
    }
    return self.isSegue;
}

@end
