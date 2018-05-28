//
//  XFWebViewController.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFWebViewController.h"

@interface XFWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;

@property (assign, nonatomic) NSUInteger loadCount;



@end

@implementation XFWebViewController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [self.view addSubview:callWebview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    self.webView = callWebview;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.webView loadRequest:request];
    
    // 初始化子控件
    [self setupSubs];

}
#pragma mark - FUNC96969
- (void) setupSubs {
    self.webView.delegate = self;
    
    self.webView.scrollView.bounces = NO;
    // 导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"fanhuijianbaise") style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    if (self.webTitle) {
        self.navigationItem.title = self.webTitle;
    }
}
/**返回POP*/
- (void) backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIWebViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    //获取网页title
    NSString *htmlTitle = @"document.title";
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
    self.navigationItem.title = titleHtmlInfo;

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [SVProgressHUD showErrorWithStatus:@"加载失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.85 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
//        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)dealloc {
    
}


@end
