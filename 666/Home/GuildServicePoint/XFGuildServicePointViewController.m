//
//  XFGuildServicePointViewController.m
//  666
//
//  Created by 123 on 2018/4/27.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFGuildServicePointViewController.h"
#import "JXButton.h"
#import "JZLocationConverter.h"

@interface XFGuildServicePointViewController ()

@property(nonatomic,weak)UILabel * addressLabel;
@property(nonatomic,weak)UILabel * workLabel;
@property(nonatomic,weak)UILabel * managerLabel;
@property(nonatomic,weak)UILabel * telLabel;
@property(nonatomic,weak)UILabel * idleLabel;

@property(nonatomic,strong)NSString * tel;


@property(nonatomic,strong)NSMutableArray * imgArray;

@end

@implementation XFGuildServicePointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    self.navigationItem.title = @"服务点周边";
    [self setupUI];
    [self requestData];
    
    
}

-(void)setupUI{
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = WHITECOLOR;
    [self.view addSubview:topView];
    topView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(75);

    
    JXButton *guildBtn = [[JXButton alloc] initWithFrame:CGRectMake(20, 100, 80, 80)];
    [guildBtn setTitle:@"导航" forState:0];
    [guildBtn setTitleColor:[UIColor blackColor] forState:0];
    [guildBtn setImage:[UIImage imageNamed:@"icon_navigation"] forState:0];
    [topView addSubview:guildBtn];
    [guildBtn addTarget:self action:@selector(guildBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    guildBtn.sd_layout
    .topSpaceToView(topView, 0)
    .rightSpaceToView(topView, 0)
    .widthIs(90)
    .bottomSpaceToView(topView, 0);

    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = HEXCOLOR(@"#eeeeee");
    [topView addSubview:lineView];
    lineView.sd_layout
    .topSpaceToView(topView, 10)
    .rightSpaceToView(guildBtn, 0)
    .widthIs(1)
    .bottomSpaceToView(topView, 10);

    
    UILabel * addressLabel = [UILabel new];
    addressLabel.font = XFont(13);
    addressLabel.textColor = BLACKCOLOR;
    addressLabel.text = @"服务点:加载中...";
    addressLabel.numberOfLines = 1;
    [topView addSubview:addressLabel];
    addressLabel.sd_layout
    .topSpaceToView(topView, 4.5)
    .leftSpaceToView(topView, 10)
    .rightSpaceToView(lineView, 5)
    .heightIs(22);
    self.addressLabel = addressLabel;
    
    UILabel * workTitleLabel = [UILabel new];
    workTitleLabel.font = XFont(13);
    workTitleLabel.textColor = BLACKCOLOR;
    workTitleLabel.text = @"营业时间:";
//    workTitleLabel.numberOfLines = 2;
    [topView addSubview:workTitleLabel];
    workTitleLabel.sd_layout
    .topSpaceToView(addressLabel, 0)
    .leftSpaceToView(topView, 10)
    .rightSpaceToView(lineView, 5)
    .heightIs(22);

    
    UILabel * workLabel = [UILabel new];
    workLabel.font = XFont(13);
    workLabel.textColor = BLACKCOLOR;
    workLabel.text = @"加载中...";
    workLabel.numberOfLines = 2;
    [topView addSubview:workLabel];
    workLabel.sd_layout
    .topSpaceToView(workTitleLabel, 0)
    .leftSpaceToView(topView, 10)
    .rightSpaceToView(lineView, 5)
    .heightIs(22);
    self.workLabel = workLabel;


    UIView * secView = [[UIView alloc]init];
    secView.backgroundColor = WHITECOLOR;
    [self.view addSubview:secView];
    secView.sd_layout
    .topSpaceToView(topView, 1)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(75);

    JXButton *telBtn = [[JXButton alloc] initWithFrame:CGRectMake(20, 100, 80, 80)];
    [telBtn setTitle:@"电话" forState:0];
    [telBtn setTitleColor:[UIColor blackColor] forState:0];
    [telBtn setImage:[UIImage imageNamed:@"tel2"] forState:0];
    [secView addSubview:telBtn];
    [telBtn addTarget:self action:@selector(telBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    telBtn.sd_layout
    .topSpaceToView(secView, 0)
    .rightSpaceToView(secView, 0)
    .widthIs(90)
    .bottomSpaceToView(secView, 0);
    
    UIView * lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = HEXCOLOR(@"#eeeeee");
    [secView addSubview:lineView2];
    lineView2.sd_layout
    .topSpaceToView(secView, 10)
    .rightSpaceToView(telBtn, 0)
    .widthIs(1)
    .bottomSpaceToView(secView, 10);
    
    
    UILabel * managerLabel = [UILabel new];
    managerLabel.font = XFont(13);
    managerLabel.textColor = BLACKCOLOR;
    managerLabel.text = @"服务点负责人:加载中...";
    managerLabel.numberOfLines = 1;
    [secView addSubview:managerLabel];
    managerLabel.sd_layout
    .topSpaceToView(secView, 4.5)
    .leftSpaceToView(secView, 10)
    .rightSpaceToView(lineView2, 5)
    .heightIs(22);
    self.managerLabel = managerLabel;
    
    UILabel * telLabel = [UILabel new];
    telLabel.font = XFont(13);
    telLabel.textColor = BLACKCOLOR;
    telLabel.text = @"联系电话:加载中...";
    [secView addSubview:telLabel];
    telLabel.sd_layout
    .topSpaceToView(managerLabel, 0)
    .leftSpaceToView(secView, 10)
    .rightSpaceToView(lineView2, 5)
    .heightIs(22);
    self.telLabel = telLabel;

    
    UILabel * idleLabel = [UILabel new];
    idleLabel.font = XFont(13);
    idleLabel.textColor = BLACKCOLOR;
    idleLabel.text = @"闲置车辆:加载中...";
    idleLabel.numberOfLines = 2;
    [secView addSubview:idleLabel];
    idleLabel.sd_layout
    .topSpaceToView(telLabel, 0)
    .leftSpaceToView(secView, 10)
    .rightSpaceToView(lineView2, 5)
    .heightIs(22);
    self.idleLabel = idleLabel;

    
}

-(void)telBtnAction:(UIButton*)sender{
    if (!self.tel) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)guildBtnAction:(UIButton*)sender{
    CLLocation *myLocation=[[CLLocation alloc] initWithLatitude:[JZLocationConverter bd09ToGcj02:_userLocation.location.coordinate].latitude longitude:[JZLocationConverter bd09ToGcj02:_userLocation.location.coordinate].longitude];
    
    CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(_model.latitude.doubleValue, _model.longtitude.doubleValue);
    
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

-(void)creatImgGroup{
    CGFloat padding = 20;
    CGFloat width = SCREENW/2 - padding*2;
    CGFloat height = width*0.75;
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    scrollView.sd_layout
    .topSpaceToView(self.view, 150)
    .leftSpaceToView(self.view,0)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view);
    scrollView.contentSize = CGSizeMake(SCREENW, MAX((height+padding)*self.imgArray.count/2, SCREENH-100));
    
    for (NSString * str in self.imgArray) {
        NSUInteger index = [self.imgArray indexOfObject:str];
        NSUInteger row = index/2;
        int cross = index%2;

        UIImageView * imgView = [[UIImageView alloc]init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:str]];
        [scrollView addSubview:imgView];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.sd_layout
        .topSpaceToView(scrollView,padding + (height+padding)*row)
        .leftSpaceToView(scrollView, padding + cross*SCREENW/2)
        .widthIs(width)
        .heightIs(height);
    }
    
}

-(void)requestData
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.sid forKey:@"sid"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/car/serveinfo",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"status"] intValue] == 1) {
            NSDictionary * dic = responseObject[@"data"];
            self.addressLabel.text = [NSString stringWithFormat:@"服务点:%@",dic[@"address"]];
            self.navigationItem.title = dic[@"title"];
            self.workLabel.text = dic[@"busine"];
            self.imgArray = [NSMutableArray arrayWithArray:dic[@"fileImg"]];
            self.managerLabel.text = [NSString stringWithFormat:@"服务点负责人:%@",dic[@"servename"]];
            self.telLabel.text = [NSString stringWithFormat:@"联系电话:%@",dic[@"servetel"]];
            self.tel = dic[@"servetel"];
            self.idleLabel.text = [NSString stringWithFormat:@"闲置车辆:%@",dic[@"car_num"]];

            [self creatImgGroup];
        }else{

            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
