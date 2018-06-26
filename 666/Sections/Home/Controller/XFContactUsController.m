//
//  XFContactUsController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFContactUsController.h"
#import "XFContactUsCell.h"

@interface XFContactUsController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation XFContactUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.icons = @[@"qq",@"lianxidianhua",@"guanwang",@"dizhi",@"youxiang"];
    self.titles = @[@"官方QQ群",@"027-59762081",@"www.66zuche.net",@"武汉洪山区中南民族大学北区3A-14",@"sanyouminsheng@yeah.net"];
    
    self.navigationItem.title = @"联系客服";
    
    [self setupSubs];
}
- (void) setupSubs {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.bounces = NO;
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 88*SCALE_HEIGHT;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *head = [[UIImageView alloc] init];
    head.contentMode = UIViewContentModeScaleAspectFill;
    head.image = IMAGENAME(@"lianxiwomen-beijing");
    head.frame = CGRectMake(0, 0, SCREENW, 300*SCALE_HEIGHT);
    tableView.tableHeaderView = head;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.icons.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"contactCell";
    XFContactUsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XFContactUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if(indexPath.row==3 || indexPath.row==4)
    {
        cell.arrow.hidden=YES;
    }
    cell.icon.image = IMAGENAME(self.icons[indexPath.row]);
    cell.titleLbl.text = self.titles[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"234881709",@"9d2a87a3e4557144f74f5c2f72a3c0b31374e807b5490939ec9ab1f4ae34ef67"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"027-59762081"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 2:
        {
            //官网
            XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
            webViewController.urlString = @"http://www.66zuche.net";
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        case 3:
        {
            //地址
        }
            break;
        case 4:
        {
            //邮箱
        }
            break;
       
            
        default:
            break;
    }
}
@end
