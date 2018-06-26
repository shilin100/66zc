//
//  XFSuggestViewController.m
//  666
//
//  Created by 123 on 2018/6/20.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSuggestViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "XFSuggestHistoryViewController.h"

@interface XFSuggestViewController ()
@property(nonatomic,strong)UITextView * reasonTextView;

@end

@implementation XFSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = HEXCOLOR(@"eeeeee");

    UIButton *suggestHistoryBtn = [[UIButton alloc] init];
    suggestHistoryBtn.titleLabel.font = XFont(13);
    [suggestHistoryBtn setTitle:@"历史反馈" forState:UIControlStateNormal];
    [suggestHistoryBtn addTarget:self action:@selector(suggestHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:suggestHistoryBtn];


    UILabel * suggestTitle = [UILabel new];
    suggestTitle.font = XFont(12);
    suggestTitle.textColor = BlACKTEXT;
    suggestTitle.text = @"您的建议或意见:";
    [self.view addSubview:suggestTitle];
    
    suggestTitle.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 10)
    .heightIs(35);

    UITextView *reasonTextView = [[UITextView alloc] init];
    reasonTextView.backgroundColor = WHITECOLOR;
    reasonTextView.font = XFont(12);
    reasonTextView.textColor = BlACKTEXT;
    reasonTextView.zw_placeHolder = @"感谢您对六六租车的支持和关注，您的宝贵意见将帮助我们不断改进！";
    reasonTextView.zw_placeHolderColor = GRAYTEXT;
    reasonTextView.contentInset = UIEdgeInsetsMake(2.0f, 10.0f, 10.0f, 10.0f);
    self.reasonTextView = reasonTextView;
    
    [self.view addSubview:reasonTextView];
    reasonTextView.sd_layout
    .topSpaceToView(suggestTitle, 0)
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 12)
    .heightIs(100);

    UILabel * thankTitle = [UILabel new];
    thankTitle.font = XFont(12);
    thankTitle.textColor = BlACKTEXT;
    thankTitle.text = @"您的建议或意见:";
    [self.view addSubview:thankTitle];
    
    thankTitle.sd_layout
    .topSpaceToView(reasonTextView, 0)
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 10)
    .heightIs(35);

    UIButton *loadBtn = [[UIButton alloc] init];
    [loadBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [loadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loadBtn.titleLabel.font = XFont(14);
    loadBtn.layer.cornerRadius = 22;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:loadBtn];
    [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loadBtn.sd_layout
    .topSpaceToView(thankTitle, 40)
    .leftSpaceToView(self.view, 37)
    .heightIs(40)
    .rightSpaceToView(self.view, 37);

}

-(void)loadBtnClick{
    if (self.reasonTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还未输入您的意见或建议"];
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.reasonTextView.text forKey:@"usercontent"];
    
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@/user/addSuggest",BASE_URL] withDic:param Succeed:^(NSDictionary *responseObject) {
        NSLog(@"responseObject***:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功,感谢您的反馈。"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } andFaild:^(NSError *error) {
        
    }];

}

-(void)suggestHistoryBtnClick{
    XFSuggestHistoryViewController * vc = [XFSuggestHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
