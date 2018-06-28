//
//  XFContactUsController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFContactUsController.h"
#import "XFContactUsCell.h"
#import "JZLocationConverter.h"

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


-(void)guildToCompany{
    CLLocation *myLocation=[[CLLocation alloc] initWithLatitude:[JZLocationConverter bd09ToGcj02:_userLocation.location.coordinate].latitude longitude:[JZLocationConverter bd09ToGcj02:_userLocation.location.coordinate].longitude];
    
    CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(30.5010428363, 114.4017290276);

    CLLocation *toLocation=[[CLLocation alloc] initWithLatitude:[JZLocationConverter bd09ToGcj02:temp].latitude longitude:[JZLocationConverter bd09ToGcj02:temp].longitude];

    
    if (myLocation.coordinate.latitude==0 ||
        myLocation.coordinate.longitude == 0 ||
        toLocation.coordinate.latitude==0 ||
        toLocation.coordinate.longitude==0) {
        UIAlertController *alter=[UIAlertController alertControllerWithTitle:@"注意！" message:@"未定位到您当前位置，无法导航！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alter addAction:cancel];
        [self presentViewController:alter animated:YES completion:nil];
        return;
    }
    
    [SVProgressHUD showWithStatus: @"正在载入线路信息..."];
    CLGeocoder* geocoder_navigation=[[CLGeocoder alloc ] init];
    
    [geocoder_navigation reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *myplacemark=[[CLPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
        
        [geocoder_navigation reverseGeocodeLocation:toLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *toPlacemark=[[CLPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
            MKMapItem *from=[[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:myplacemark]];
            MKMapItem *to=[[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:toPlacemark]];
            NSMutableDictionary *options=[NSMutableDictionary dictionary];
            options[MKLaunchOptionsDirectionsModeKey]=MKLaunchOptionsDirectionsModeDriving;
            options[MKLaunchOptionsShowsTrafficKey]=@NO;
            BOOL MapItemOK=YES;
            MapItemOK = [MKMapItem openMapsWithItems:@[from,to] launchOptions:options];
            if (MapItemOK) {
                
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                [SVProgressHUD dismiss];
            }else{
                
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                [SVProgressHUD dismiss];
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"注意！" message:@"未能获取到相关的线路信息，请您检查您的网络情况后再试！" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
                
            }
            
        }];
        
    }];
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
            [self guildToCompany];
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
