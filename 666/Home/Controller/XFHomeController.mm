//
//  XFHomeController.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//
#import "XFSignPopView.h"
#import "XFSignInModel.h"
#import "XFSignInVC.h"
#import "XFDoLoginController.h"
#import "VierticalScrollView.h"

#import "XFHomeController.h"
#import "XFRightImageButton.h"
#import "XFHomeLeftView.h"
#import "XFMineInfoController.h"
#import "XFLoginNaviController.h"
#import "XFCarModel.h"
#import "XFLoginInfoModel.h"
#import "XFRecommeBuildController.h"

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>

#import "XFBMKPointAnnotation.h"
#import "XFBMKPinAnnotationView.h"
#import "RouteAnnotation.h"
#import "XFHomeUseCarInfoView.h"
#import "XFHomeChooseContent.h"
#import "XFMyOrderController.h"
#import "XFMyWalletController.h"
#import "XFContactUsController.h"
#import "XFHelpController.h"
#import "XFSettingController.h"
#import "XFMySaleController.h"
#import "XFMySaleTicketController.h"
#import "XFUseCarController.h"
#import "XFMyBreakRulesController.h"
#import "XFMyLearnDriveController.h"
#import "XFSelectHCPointViewController.h"
#import "XFAdvertModel.h"
#import "XFADChooseView.h"
#import "XFActiveCenterViewController.h"
#import "XFCarSelectedModel.h"
#import "XFGiveCarServiceController.h"
#import "XFIWantPeiLianController.h"
#import "XFVerifyUserInfoModel.h"
#import "XFUseCarLoadImageController.h"
#import "XFGetCarPriceModel.h"
#import "XFActiveListModel.h"
#import "XFMyBreakRulesController.h"
#import "XFMyOrderController.h"
#import "XFAlertViewTwo.h"
#import "XFCarTypeModel.h"
#import "XFDriveApplyVC.h"
#import "XFCarStateView.h"
#import "XFCustomAnnotationView.h"

@interface XFHomeController () <XFHomeLeftViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UIGestureRecognizerDelegate,XFHomeUseCarInfoViewDelegate,XFSelectHCPointViewPassValueDelegate,VierticalScrollViewDelegate>

@property (nonatomic, weak) XFRightImageButton *useCarBtn;

@property (nonatomic, weak) UIView *cover;

@property (nonatomic, weak) UIView *rightCover;

@property (nonatomic, weak) XFHomeLeftView *leftView;

@property (nonatomic, weak) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) NSMutableArray<XFCarModel *> *carModels;
@property (nonatomic, strong) NSMutableArray<XFCarSelectedModel *> *CarSelectedModels;

@property (nonatomic, assign) BOOL isUsingCar;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, strong) BMKPlanNode *startNode;

@property (nonatomic, strong) BMKPlanNode *endNode;

@property (nonatomic, strong) BMKRouteSearch *routeSearch;


@property (nonatomic, weak) BMKAnnotationView *selectedAnnoView;

@property (nonatomic, weak) XFHomeUseCarInfoView *infoView;
@property (nonatomic, weak) UIView *adView;

@property (nonatomic, weak) UIView *rightView;

@property (nonatomic, copy) NSString *conditionString;


@property (nonatomic, weak) XFHomeChooseContent *brandContent;

@property (nonatomic, weak) XFHomeChooseContent *typeContent;

@property (nonatomic, weak) XFHomeChooseContent *seatContent;

@property (nonatomic, weak) XFHomeChooseContent *colorContent;

@property (nonatomic, weak) XFHomeChooseContent *oilContent;

@property (nonatomic, weak) XFHomeChooseContent *starContent;

//@property (nonatomic, strong) NSMutableArray<XFAdvertModel *> *adModels;
@property (nonatomic, strong) NSMutableArray<XFActiveListModel *> *ActiveListModels;

@property (nonatomic, assign) int theDistance;

@property(assign, nonatomic) CLLocationCoordinate2D myCoordinate;

@property (nonatomic,copy) NSString *trackViewUrl1;
@property (nonatomic, copy)  NSString  *localVersion;
@property (nonatomic,copy) NSString *releaseNotesStr;

@end

@implementation XFHomeController
-(NSMutableArray<XFCarModel *> *)carModels{
    if (!_carModels) {
        _carModels = [NSMutableArray array];
    }
    return _carModels;
}

-(NSMutableArray<XFCarSelectedModel *> *)CarSelectedModels{
    if (!_CarSelectedModels) {
        _CarSelectedModels = [NSMutableArray array];
    }
    return _CarSelectedModels;
}

-(NSMutableArray<XFActiveListModel *> *)ActiveListModels
{
    if(!_ActiveListModels)
    {
        _ActiveListModels=[NSMutableArray array];
    }
    return _ActiveListModels;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
    [self refreshMapView];
    [self clearPlanAndInfoView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITECOLOR;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self checkService];
        });

    });
    
    [self autoLogin];
    [self setupSubs];
    // 广告
    [self advertDataWithType:@"2"];
    [self requestDailySignIn];
}

-(void)refreshMapView{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self getCarData];
}

-(void)locationServicesEnabled
{
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted))
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"打开定位开关" message:@"请打开系统设置中“隐私->定位服务”,允许六六租车使用您的位置" sureBtn:@"设置" cancleBtn:@"取消"];
        alert.resultIndex = ^(AlertButtonType type) {
            switch (type) {
                case AlertButtonTypeSure:
                {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }
                    break;
                case AlertButtonTypeCancel:
                    
                    break;
                default:
                    break;
            }
        };
        [alert showAlertView];
        
    }
    
    else
    {
        NSLog(@"开启了gps");
    }
}

#pragma mark - 自动登录
- (void) autoLogin {
    
    if ([USERDEFAULT boolForKey:@"isLogin"] && !self.isFromLogin) {
        NSMutableDictionary *params = [XFTool baseParams];
        [params setObject:[USERDEFAULT valueForKey:@"account"] forKey:@"name"];
        [params setObject:[[NSString alloc] initWithData:[USERDEFAULT valueForKeyPath:@"MD5PWD"] encoding:NSUTF8StringEncoding] forKey:@"pwd"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/Login"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] intValue] == 1) {
                
//                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                [SVProgressHUD dismissWithDelay:1.6];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                if ([fileMgr fileExistsAtPath:LoginModel_Doc_path]) {
                    [fileMgr removeItemAtPath:LoginModel_Doc_path error:nil];
                }
                
                [NSKeyedArchiver archiveRootObject:[XFLoginInfoModel mj_objectWithKeyValues:responseObject] toFile:LoginModel_Doc_path];
                [USERDEFAULT setBool:YES forKey:@"isLogin"];
                
                [self getCarData];
            
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:[NSBundle mainBundle]];
                XFLoginNaviController *loginNav = sb.instantiateInitialViewController;
                [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:ServerError];
            
        }];
    }else if ([USERDEFAULT boolForKey:@"isLogin"] && self.isFromLogin){
        
        [self getCarData];
    }
}

- (void) getUsingCarStatus {
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/myuse",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject&&&===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            if ([responseObject[@"now"] intValue] == 1) {
                XFCarModel *model = [XFCarModel mj_objectWithKeyValues:responseObject];
                model.cid = responseObject[@"cid"];
//                model.code = responseObject[@""];
                XFUseCarController *vc = [[XFUseCarController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您目前没有正在使用中的车辆" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
        
    }];
}
- (void) setupSubs {
    self.navigationItem.title = @"六六租车";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"wode") style:UIBarButtonItemStyleDone target:self action:@selector(userItemClick)];
    XFRightImageButton *useCarBtn = [[XFRightImageButton alloc] init];
    useCarBtn.titleLabel.font = XFont(13);
    [useCarBtn setTitle:@"选车" forState:UIControlStateNormal];
//    [useCarBtn setImage:IMAGENAME(@"xiangxiajiantou") forState:UIControlStateNormal];
//    [useCarBtn setImage:IMAGENAME(@"xiangshang") forState:UIControlStateSelected];
    [useCarBtn addTarget:self action:@selector(useCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.useCarBtn = useCarBtn;
    [useCarBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:useCarBtn];
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = BMKMapTypeStandard;
    [mapView setTrafficEnabled:NO];
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    mapView.zoomLevel = 16;
    mapView.overlookEnabled = NO;
    mapView.rotateEnabled = NO;
    mapView.showMapScaleBar = YES;
    
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
//    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
//    param.isRotateAngleValid = YES;
//    param.isAccuracyCircleShow = NO;
//    param.locationViewImgName = @"wo";
//    param.locationViewOffsetX = 0;
//    param.locationViewOffsetY = 0;
//    [self.mapView updateLocationViewWithParam:param];
     
    BMKLocationService *locService = [[BMKLocationService alloc] init];
    [locService startUserLocationService];
    self.locService = locService;
    XFButton *recommeBtn = [[XFButton alloc] init];
    [recommeBtn setBackgroundImage:IMAGENAME(@"jiandian") forState:UIControlStateNormal];
    [self.view insertSubview:recommeBtn aboveSubview:self.mapView];
    [[recommeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        XFRecommeBuildController *vc = [[XFRecommeBuildController alloc] init];
        vc.navigationItem.title = @"推荐建点";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    XFButton *locationBtn = [[XFButton alloc] init];
    [locationBtn setBackgroundImage:IMAGENAME(@"huidian") forState:UIControlStateNormal];
    [self.view insertSubview:locationBtn aboveSubview:self.mapView];
    [[locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        BMKUserLocation *location = self.locService.userLocation;
        [self.mapView setCenterCoordinate:location.location.coordinate animated:YES];
    }];
    XFButton *refreshBtn = [[XFButton alloc] init];
    [refreshBtn setBackgroundImage:IMAGENAME(@"shuaxin") forState:UIControlStateNormal];
    [self.view insertSubview:refreshBtn aboveSubview:self.mapView];
    [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        
       [self getCarData];
    }];
    XFButton *myUsingBtn = [[XFButton alloc] init];
    [myUsingBtn setBackgroundImage:IMAGENAME(@"myUsingCar") forState:UIControlStateNormal];
    [self.view insertSubview:myUsingBtn aboveSubview:self.mapView];
    [[myUsingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self getUsingCarStatus];
    }];
    
    
    UIView * adView = [[UIView alloc] init];
    adView.layer.cornerRadius=5;
    adView.layer.masksToBounds = YES;
    adView.backgroundColor = WHITECOLOR;
    [self.view insertSubview:adView aboveSubview:self.mapView];
    self.adView=adView;
    adView.sd_layout
    .rightSpaceToView(self.view, 35)
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 35)
    .heightIs(40);
    
    UIImageView * alarm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_home_adv"]];
    alarm.contentMode = UIViewContentModeScaleAspectFit;
    [adView addSubview:alarm];
    alarm.sd_layout
    .centerYEqualToView(adView)
    .leftSpaceToView(adView, 8)
    .widthEqualToHeight()
    .heightIs(14);

    
    
    [myUsingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40*SCALE_HEIGHT);
        make.right.equalTo(self.view.mas_right).offset(-20*SCALE_WIDTH);
        make.width.height.mas_equalTo(@(62*SCALE_WIDTH));
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(myUsingBtn.mas_top).offset(-30*SCALE_HEIGHT);
        make.right.equalTo(myUsingBtn.mas_right);
        make.height.width.equalTo(myUsingBtn);
    }];
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(refreshBtn.mas_top).offset(-30*SCALE_HEIGHT);
        make.right.equalTo(refreshBtn.mas_right);
        make.height.width.equalTo(refreshBtn);
    }];
    
    [recommeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(locationBtn.mas_top).offset(-30*SCALE_HEIGHT);
        make.right.equalTo(locationBtn.mas_right);
        make.height.width.equalTo(locationBtn.mas_height);
    }];
    
    
    //判断是否启用gps
    [self locationServicesEnabled];
   
    
}

-(void)clickTitleButton:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    
    XFWebViewController * vc = [[XFWebViewController alloc]init];
    XFActiveListModel* model = self.ActiveListModels[(int)button.tag-1];
    vc.urlString = model.link;
    vc.webTitle = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) userItemClick {
    [self clearPlanAndInfoView];
    UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.cover = cover;
    [APPLication.delegate.window addSubview:cover];
    UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap:)];
    coverTap.delegate=self;
    [cover addGestureRecognizer:coverTap];
    XFHomeLeftView *leftView = [[XFHomeLeftView alloc] initWithFrame:CGRectMake(-320*SCALE_WIDTH, 0, 320*SCALE_WIDTH, SCREENH)];
    leftView.alpha = 1.0;
    leftView.delegate = self;
    [cover addSubview:leftView];
    self.leftView = leftView;
    [UIView animateWithDuration:0.3 animations:^{
        leftView.left = 0;
    }];
}
- (void) coverTap:(UIGestureRecognizer *)gesture {
//    CGPoint point = [gesture locationInView:gesture.view];
//    if (CGRectContainsPoint(self.leftView.frame, point)) {
//        return;
//    }

    [UIView animateWithDuration:0.3 animations:^{
        self.leftView.left = -320 * SCALE_WIDTH;
        self.cover.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.001];
    } completion:^(BOOL finished) {
        self.cover.hidden = YES;
        [self.cover removeFromSuperview];
        self.leftView.delegate = nil;
    }];
    
}

//防止和tableview的点击事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"tap===%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
    
}

- (void) useCarBtnClick:(XFRightImageButton *)button {
    button.selected = !button.selected;
    [self clearPlanAndInfoView];
    UIView *rightCover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    rightCover.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.rightCover = rightCover;
    [APPLication.delegate.window addSubview:rightCover];
    UITapGestureRecognizer *rightCoverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightCoverTap:)];
    [rightCover addGestureRecognizer:rightCoverTap];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREENW, 0, 295*SCALE_WIDTH, SCREENH)];
    rightView.backgroundColor = WHITECOLOR;
    [rightCover addSubview:rightView];
    self.rightView = rightView;
    
    [UIView animateWithDuration:0.3 animations:^{
        rightView.left = SCREENW - 295*SCALE_WIDTH;
    }];
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"查询" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    submitBtn.backgroundColor = HEXCOLOR(@"#05be7f");
    submitBtn.titleLabel.font = XFont(15);
    submitBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    submitBtn.clipsToBounds = YES;
    [submitBtn addTarget:self action:@selector(doSubmitSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:submitBtn];
    submitBtn.sd_layout
    .bottomSpaceToView(rightView, 50*SCALE_HEIGHT)
    .heightIs(80*SCALE_HEIGHT)
    .leftSpaceToView(rightView, 60*SCALE_WIDTH)
    .rightSpaceToView(rightView, 60*SCALE_WIDTH);

    UILabel *carStateLbl = [[UILabel alloc] init];
    carStateLbl.font = XFont(12);
    carStateLbl.textColor = HEXCOLOR(@"#9a9a9a");
    [rightView addSubview:carStateLbl];
    carStateLbl.text = @"车辆状态";
    
    carStateLbl.sd_layout
    .topSpaceToView(rightView, 20)
    .leftSpaceToView(rightView, 20*SCALE_WIDTH)
    .rightEqualToView(rightView)
    .heightIs(25*SCALE_HEIGHT);
    
    XFCarStateView * blueview = [XFCarStateView initWithColor:RGBCOLOR(51, 153, 253) title:@"闲置"];
    [rightView addSubview:blueview];
    blueview.sd_layout
    .topSpaceToView(carStateLbl, 5)
    .leftEqualToView(rightView)
    .widthIs(rightView.width/2)
    .heightIs(30);
    
    XFCarStateView * yellowview = [XFCarStateView initWithColor:RGBCOLOR(238, 203, 39) title:@"使用中"];
    [rightView addSubview:yellowview];
    yellowview.sd_layout
    .topSpaceToView(carStateLbl, 5)
    .leftSpaceToView(blueview, 0)
    .widthIs(rightView.width/2)
    .heightIs(30);

    XFCarStateView * greenview = [XFCarStateView initWithColor:RGBCOLOR(38, 190, 125) title:@"我的"];
    [rightView addSubview:greenview];
    greenview.sd_layout
    .topSpaceToView(blueview, 0)
    .leftEqualToView(rightView)
    .widthIs(rightView.width/2)
    .heightIs(30);

    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.frame = CGRectMake(0, 30+30, rightView.width, rightView.height - 180*SCALE_HEIGHT-30-30);
    [rightView addSubview:contentScrollView];
    
    
    XFHomeChooseContent *brandContent = [[XFHomeChooseContent alloc] init];
    brandContent.isFirst = NO; // 默认选中第一个
    [contentScrollView addSubview:brandContent];
    brandContent.sd_layout
    .topSpaceToView(contentScrollView, 100*SCALE_HEIGHT)
    .leftEqualToView(contentScrollView)
    .rightEqualToView(contentScrollView);
    brandContent.title = @"车辆品牌";
    self.brandContent = brandContent;
    
    XFHomeChooseContent *typeContent = [[XFHomeChooseContent alloc] init];
    [contentScrollView addSubview:typeContent];
    typeContent.sd_layout
    .topSpaceToView(brandContent, 0)
    .leftEqualToView(brandContent)
    .heightIs(0)
    .rightEqualToView(brandContent);
    typeContent.title = @"车辆型号";
    typeContent.alpha = 0;

    self.typeContent = typeContent;
    
//    XFHomeChooseContent *seatContent = [[XFHomeChooseContent alloc] init];
//    [contentScrollView addSubview:seatContent];
//    seatContent.sd_layout
//    .topSpaceToView(typeContent, 0)
//    .leftEqualToView(typeContent)
//    .rightEqualToView(typeContent);
//    seatContent.title = @"座位数";
//    seatContent.subTitles = @[@"2座",@"4座",@"5座",@"6座",@"7座以上"];
//    self.seatContent = seatContent;
    
    XFHomeChooseContent *colorContent = [[XFHomeChooseContent alloc] init];
    [contentScrollView addSubview:colorContent];
    colorContent.sd_layout
    .topSpaceToView(typeContent, 0)
    .leftEqualToView(typeContent)
    .rightEqualToView(typeContent);
    colorContent.title = @"颜色";
    colorContent.alpha = 0;
//    colorContent.subTitles = @[@"金色",@"灰色",@"黑色",@"白色",@"红色",@"银色",@"其它"];
    self.colorContent = colorContent;
    
//    XFHomeChooseContent *oilContent = [[XFHomeChooseContent alloc] init];
//    [contentScrollView addSubview:oilContent];
//    oilContent.sd_layout
//    .topSpaceToView(colorContent, 0)
//    .leftEqualToView(colorContent)
//    .rightEqualToView(colorContent);
//    oilContent.isMultiSelect=YES;
//    oilContent.title = @"其它";
//    oilContent.subTitles = @[@"油车",@"亮点车型"];
//    self.oilContent = oilContent;
    
//    XFHomeChooseContent *starContent = [[XFHomeChooseContent alloc] init];
//    [contentScrollView addSubview:starContent];
//    starContent.sd_layout
//    .topSpaceToView(oilContent, 0)
//    .leftEqualToView(oilContent)
//    .rightEqualToView(oilContent);
//    starContent.title = @"亮点车型";
//    starContent.subTitles = @[@"亮点车型"];
//    self.starContent = starContent;
    [contentScrollView setupAutoContentSizeWithBottomView:colorContent bottomMargin:10*SCALE_HEIGHT];
    
    
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
//    [mgr POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/car/getBrand"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@">>>");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"<<<");
//    }];
    
    [mgr GET:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/car/getBrand?"] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
  
        if ([responseObject[@"status"] intValue] == 1) {
            NSArray *arr = responseObject[@"result"];
            NSArray *titles = [arr valueForKeyPath:@"brand"];
            brandContent.subTitles = titles;

//            typeContent.subTitles = [arr[0][@"_child"] valueForKeyPath:@"brand"];
            
            NSMutableArray * tempArr = [NSMutableArray array];
            brandContent.itemblock = ^(NSString *title) {

                colorContent.alpha = 0;

                NSUInteger index = [titles indexOfObject:title];
                typeContent.subTitles = [arr[index][@"_child"] valueForKeyPath:@"brand"];
                [tempArr removeAllObjects];
                [tempArr addObjectsFromArray:arr[index][@"_child"]];
                typeContent.alpha = 1;

            };

            typeContent.itemblock = ^(NSString *title) {
                colorContent.alpha = 1;

                NSUInteger index = [[tempArr valueForKeyPath:@"brand"] indexOfObject:title];
                colorContent.subTitles = tempArr[index][@"color"];
                
            };


        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
    }];
    
    
    
    
    
}
- (void) rightCoverTap:(UIGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    if (CGRectContainsPoint(self.rightView.frame, point)) {
        return;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.left = SCREENW;
        self.rightCover.backgroundColor = [UIColor colorWithWhite:0.f alpha:0];
    } completion:^(BOOL finished) {
        self.rightView = nil;
        [self.rightCover removeFromSuperview];
        
        self.brandContent = nil;
        self.typeContent = nil;
        self.seatContent = nil;
        self.colorContent = nil;
        self.oilContent = nil;
        self.starContent = nil;
        
        self.useCarBtn.selected = NO;
    }];
}
- (void) doSubmitSearchClick {
    [self rightCoverTap:nil];
    
    NSLog(@"conditions:brand:%@,type:%@,seat:%@,color:%@,oil:%@",self.brandContent.condition,self.typeContent.condition,self.seatContent.condition,self.colorContent.condition,self.oilContent.condition);
    
    NSMutableArray *arr=(NSMutableArray *)self.oilContent.condition;
    NSString *is_oil,*bright,*color;
    is_oil=[arr[0] isEqualToString:@""]  ? @"2":@"1";
    bright=[arr[1] isEqualToString:@""]  ? @"2":@"1";
    NSLog(@"is_oil==%@&&&bright==%@",is_oil,bright);
    
    if([self.colorContent.condition isEqualToString:@"金色"])
    {
        color=@"1";
    }
    else if ([self.colorContent.condition isEqualToString:@"灰色"])
    {
        color=@"2";
    }
    else if ([self.colorContent.condition isEqualToString:@"黑色"])
    {
        color=@"3";
    }
    else if ([self.colorContent.condition isEqualToString:@"白色"])
    {
        color=@"4";
    }
    else if ([self.colorContent.condition isEqualToString:@"红色"])
    {
        color=@"5";
    }
    else if ([self.colorContent.condition isEqualToString:@"银色"])
    {
        color=@"6";
    }
    else if ([self.colorContent.condition isEqualToString:@"其它"])
    {
        color=@"7";
    }

    else
    {
        color=@"";
    }
        
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    if(![self.brandContent.condition isEqualToString:@""])
    {
        [params setObject:self.brandContent.condition forKey:@"brand"];
    }
    if(![self.typeContent.condition isEqualToString:@""])
    {
        [params setObject:self.typeContent.condition forKey:@"type"];
    }
//    if(![self.seatContent.condition isEqualToString:@""])
//    {
//        [params setObject:self.seatContent.condition forKey:@"seat"];
//    }
    if(![color isEqualToString:@""])
    {
        [params setObject:self.colorContent.condition forKey:@"color"];
    }
    
//    if([is_oil isEqualToString:@"1"])
//    {
//        [params setObject:is_oil forKey:@"is_oil"];
//    }

    if([bright isEqualToString:@"1"])
    {
        [params setObject:bright forKey:@"bright"];
    }

    [params setObject:@(_myCoordinate.longitude) forKey:@"longtitude"];
    [params setObject:@(_myCoordinate.latitude) forKey:@"latitude"];
    NSLog(@"lo==%f,la==%f",_myCoordinate.longitude,_myCoordinate.latitude);
    
//    [params setObject:@"" forKey:@"region"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/getType_info",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
         NSLog(@"responseObject111===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            //找到符合条件的车辆
            [self.CarSelectedModels removeAllObjects];
            [self.CarSelectedModels addObjectsFromArray:[XFCarSelectedModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
            NSMutableArray *carModels=[NSMutableArray array];
            [carModels addObjectsFromArray:[XFCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];

            
//            for (XFCarSelectedModel *selectModel in self.CarSelectedModels) {
//
//                for (XFCarModel *carModel in self.carModels) {
//
//                    if([selectModel.cid intValue]==[carModel.cid intValue])
//                    {
//                        [carModels addObject:carModel];
//                    }
//                }
//            }
//            NSLog(@"count==%ld",carModels.count);
            
            self.mapView.zoomLevel = 12;
            [self setupAnnotations:carModels];
            
            
        }else{
            
            //未找到符合条件的
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:0.85];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD dismiss];
    }];
    
}
- (void) getCarData {
    [SVProgressHUD show];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    NSString *uid = model.uid;
    NSString *token = model.token;
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Car/Index?"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject222===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            self.isUsingCar = [responseObject[@"now"] boolValue];
            
            [self.carModels removeAllObjects];
            [self.carModels addObjectsFromArray:[XFCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            for (XFCarModel *car in self.carModels) {
//                car.latitude = [NSString stringWithFormat:@"%f",car.latitude.floatValue + arc4random()%10*0.005];
//                car.longtitude = [NSString stringWithFormat:@"%f",car.longtitude.floatValue + arc4random()%10*0.005];
                car.latitude = [NSString stringWithFormat:@"%f",car.latitude.floatValue];
                car.longtitude = [NSString stringWithFormat:@"%f",car.longtitude.floatValue];
            }

            [self setupAnnotations:self.carModels];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}
- (void) setupAnnotations:(NSMutableArray *)array{
    NSMutableArray *annos = [NSMutableArray array];

    for (XFCarModel *model in array) {
        XFBMKPointAnnotation *anno = [[XFBMKPointAnnotation alloc] init];
        anno.carModel = model;
        anno.title = @"";
        [annos addObject:anno];
    }
    XFBMKPointAnnotation *anno = [[XFBMKPointAnnotation alloc] init];
    [annos insertObject:anno atIndex:0];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:annos];
    
}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self clearPlanAndInfoView];
}

- (void) homeLeftTableView:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self myOrder];
            break;
        case 1:
            [self myWallet];
            break;
        case 2:
            [self myticket];
            break;
        case 3:
            [self activeCenter];
            break;
        case 4:
            [self myInvite];
            break;
        case 5:
            [self myStudy];
            break;
        case 6:
            [self peilian];
            break;
        case 7:
            [self carService];
            break;
        case 8:
            [self myBreakRules];
            break;
        case 9:
            [self contactUs];
            break;
        case 10:
            [self help];
            break;
        case 11:
            [self setting];
            break;
            
        default:
            break;
    }
}


-(void)homeLeftView:(XFHomeLeftView *)leftView didSelectedItem:(UIButton *)sender{
    NSLog(@">>%ld",(long)sender.tag);
//    XFMineInfoController *vc = [[XFMineInfoController alloc] init];
//    [self coverTap:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:vc animated:YES];
//    });
    switch (sender.tag) {
        case leftViewSubTypeIcon:
            [self userInfo];
            break;
        case leftViewSubTypeOrder:
            [self myOrder];
            break;
        case leftViewSubTypeBreakRules:
            [self myBreakRules];
            break;
        case leftViewSubTypeLogout:
            [self doLogout];
            break;
        case leftViewSubTypeWallet:
            [self myWallet];
            break;
        case leftViewSubTypeContact:
            [self contactUs];
            break;
        case leftViewSubTypeHelp:
            [self help];
            break;
        case leftViewSubTypeSetting:
            [self setting];
            break;
        case leftViewSubTypeSales:
            [self myInvite];
            break;
        case leftViewSubTypeTicket:
            [self myticket];
            break;
        case leftViewSubTypeStudy:
            [self myStudy];
            break;
            
        default:
            break;
    }
}

-(void)activeCenter
{
    NSLog(@"活动中心");
    [self coverTap:nil];
    XFActiveCenterViewController  *vc = [[XFActiveCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)peilian
{
    NSLog(@"陪练");
    [self coverTap:nil];
    XFIWantPeiLianController  *vc = [[XFIWantPeiLianController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)carService
{
    NSLog(@"送车服务");
    [self coverTap:nil];
    XFGiveCarServiceController  *vc = [[XFGiveCarServiceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) myStudy {
    [self coverTap:nil];
//    XFMyLearnDriveController  *vc = [[XFMyLearnDriveController alloc] init];
    XFDriveApplyVC  *vc = [[XFDriveApplyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) myBreakRules {
    [self coverTap:nil];
    XFMyBreakRulesController *vc = [[XFMyBreakRulesController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) myOrder {
    [self coverTap:nil];
    XFMyOrderController *vc = [[XFMyOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) userInfo {
    [self coverTap:nil];
    XFMineInfoController *vc = [[XFMineInfoController alloc] init];
    vc.isSubmit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) myticket {
    [self coverTap:nil];
    XFMySaleTicketController *vc = [[XFMySaleTicketController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) myInvite {
    [self coverTap:nil];
    XFMySaleController *vc = [[XFMySaleController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) setting {
    [self coverTap:nil];
    XFSettingController *vc = [[XFSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) help {
    [self coverTap:nil];
    XFHelpController *vc = [[XFHelpController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) contactUs {
    [self coverTap:nil];
    XFContactUsController *vc = [[XFContactUsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) doLogout {
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path exception:nil];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    [SVProgressHUD show];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Login/Outlogin"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            [SVProgressHUD dismissWithDelay:1.0 completion:^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:[NSBundle mainBundle]];
                
                UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"LoginSB" bundle:nil];
                XFDoLoginController *vc = [mainStory instantiateViewControllerWithIdentifier:@"DoLoginIdentity"];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[XFLoginNaviController alloc]initWithRootViewController:vc];
                
                [USERDEFAULT setBool:NO forKey:@"isLogin"];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                if ([fileMgr fileExistsAtPath:LoginModel_Doc_path]) {
                    [fileMgr removeItemAtPath:LoginModel_Doc_path error:nil];
                }
            }];
            [SVProgressHUD dismiss];

        }else{
            [SVProgressHUD showErrorWithStatus:@"退出失败"];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
}
- (void) myWallet {
    
    [self verifyUserInfo];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
   //未开gps默认定位到光谷
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted))
    {
        CLLocationCoordinate2D coo=CLLocationCoordinate2DMake(30.5058830894, 114.3979415382);
        self.mapView.centerCoordinate = coo;
        self.mapView.zoomLevel=15;
    }
    else
    {
         [self.mapView updateLocationData:userLocation];
    }
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    
    //得到自己的经纬度信息
    _myCoordinate=userLocation.location.coordinate;

}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
//        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"userAnnotationView"];
//        if (!annotationView) {
//            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotationView"];
//        }
//        return annotationView;
//    }

    
    NSString *AnnotationViewID = @"annoIndentifer";
    XFCarModel * model = ((XFBMKPointAnnotation*)annotation).carModel;
    
    
    XFCustomAnnotationView *annotationView = (XFCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (!annotationView) {
        annotationView = [[XFCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
//    annotationView.pinColor = BMKPinAnnotationColorPurple;
    
//    annotationView.animatesDrop = YES;
    annotationView.image = [UIImage imageNamed:@""];
    if (model.status == 0) {
        annotationView.customImg.image = IMAGENAME(@"min_marker_useable_car");
    }else{
        if (model.userstatus==2) {
            annotationView.customImg.image = IMAGENAME(@"min_marker_using_car");
        }else{
            annotationView.customImg.image = IMAGENAME(@"min_marker_maintain_car");
        }
        
    }
    annotationView.customImg.transform = CGAffineTransformMakeRotation(model.angle.floatValue);


    //    annotationView.image = IMAGENAME(@"che");
    UIButton *distance = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150*SCALE_WIDTH, 62*SCALE_HEIGHT)];
    distance.userInteractionEnabled = NO;
    distance.tag = 1000;
    [distance setBackgroundImage:IMAGENAME(@"luchengbeijing") forState:UIControlStateNormal];
    [distance setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    distance.titleLabel.font = XFont(12);
    distance.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 9, 0);
    [distance setTitle:@"距离" forState:UIControlStateNormal];
    
    annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:distance];
    return annotationView;
}


-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if (self.infoView) {
        [self.infoView removeFromSuperview];
    }
    
    XFCarModel *seletedCar;
    if ([view.annotation isKindOfClass:NSClassFromString(@"XFBMKPointAnnotation")]) {
        seletedCar = ((XFBMKPointAnnotation *)view.annotation).carModel;
        self.selectedAnnoView = view;
       
    }else{
        return;
    }

    CLLocationCoordinate2D carLocation;
    carLocation.latitude = seletedCar.latitude.floatValue;
    carLocation.longitude = seletedCar.longtitude.floatValue;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = carLocation;
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeSearch.delegate = self;
    [self.geoCodeSearch reverseGeoCode:option];
    
    self.startNode = [[BMKPlanNode alloc] init];
    self.endNode = [[BMKPlanNode alloc] init];
    
    self.startNode.pt = self.locService.userLocation.location.coordinate;
    
    CLLocationCoordinate2D endCoor;
    endCoor.latitude = seletedCar.latitude.floatValue;
    endCoor.longitude = seletedCar.longtitude.floatValue;
    self.endNode.pt = endCoor;
    
    BMKWalkingRoutePlanOption *walkingOption = [[BMKWalkingRoutePlanOption alloc] init];
    walkingOption.from = self.startNode;
    walkingOption.to = self.endNode;
    
    self.routeSearch = [[BMKRouteSearch alloc] init];
    self.routeSearch.delegate = self;
    BOOL flag = [self.routeSearch walkingSearch:walkingOption];
    if (flag) {
    }else{
    }
    
    //用车的时候未开gps先提示
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted))
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"打开定位开关" message:@"请打开系统设置中“隐私->定位服务”,允许六六租车使用您的位置" sureBtn:@"设置" cancleBtn:@"取消"];
        alert.resultIndex = ^(AlertButtonType type) {
            switch (type) {
                case AlertButtonTypeSure:
                {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }
                    break;
                case AlertButtonTypeCancel:
                    
                    break;
                default:
                    break;
            }
        };
        [alert showAlertView];
        
    }
    else
    {
        //判断用户信息完整性
        [self verifyUserInfo:seletedCar];
    }
    

}


#pragma mark - 验证用户信息完整性

-(void)verifyUserInfo
{
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            XFVerifyUserInfoModel *model = [XFVerifyUserInfoModel mj_objectWithKeyValues:responseObject];
            
            if([model.user_state isEqualToString:@"0"] || [model.user_state isEqualToString:@"3"])
            {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您需要完善资料以后才可以使用此功能" sureBtn:@"立即前往" cancleBtn:@"稍后再说"];
                alert.resultIndex = ^(AlertButtonType type) {
                    switch (type) {
                        case AlertButtonTypeSure:
                        {
                            [self coverTap:nil];
                            XFMineInfoController *vc = [[XFMineInfoController alloc] init];
                            vc.isSubmit = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        case AlertButtonTypeCancel:
                            
                            break;
                        default:
                            break;
                    }
                };
                [alert showAlertView];
                return;
            }
            else if([model.user_state isEqualToString:@"1"])
            {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您的信息正在审核中，审核通过之后才能使用此功能" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
                return;
            }
            
            else if([model.user_state isEqualToString:@"2"])
            {
                [self coverTap:nil];
                XFMyWalletController *vc = [[XFMyWalletController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            else
            {
                //
            }
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


-(void)verifyUserInfo:(XFCarModel *)carModel
{
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    if (carModel.cid) {
        [params setObject:@(carModel.cid.intValue) forKey:@"cid"];
    }
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***===%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            XFVerifyUserInfoModel *model = [XFVerifyUserInfoModel mj_objectWithKeyValues:responseObject];
   
//            黄车点击事件
//            if ([model.car isEqualToString:@"0"]) {
//                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"车辆暂时不能使用" sureBtn:@"确定" cancleBtn:nil];
//                [alert showAlertView];
//                return;
//            }
//            else
            {
                if ([model.user_state isEqualToString:@"0"] || [model.user_state isEqualToString:@"3"])
                {
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您需要完善资料以后才能使用车辆，立即前往完善资料？" sureBtn:@"立即前往" cancleBtn:@"稍后再说"];
                    alert.resultIndex = ^(AlertButtonType type) {
                        switch (type) {
                            case AlertButtonTypeSure:
                            {
                                XFMineInfoController *vc = [[XFMineInfoController alloc] init];
                                vc.isSubmit = YES;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                                break;
                            case AlertButtonTypeCancel:
                                
                                break;
                            default:
                                break;
                        }
                    };
                    [alert showAlertView];
                    return;
                }
                else if ([model.user_state isEqualToString:@"1"])
                {
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您的信息正在审核中，审核通过之后才能用车" sureBtn:@"确定" cancleBtn:nil];
                    [alert showAlertView];
                    return;
                }
                else if ([model.user_state isEqualToString:@"2"])
                {
                    if ([model.state isEqualToString:@"1"])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"用户状态不正常" sureBtn:@"确定" cancleBtn:nil];
                        [alert showAlertView];
                        return;
                    }
                    else if ([model.state isEqualToString:@"2"])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"押金不足" sureBtn:@"去交押金" cancleBtn:@"取消"];
                        alert.resultIndex = ^(AlertButtonType type) {
                            if (type == AlertButtonTypeSure) {
                                XFMyWalletController *vc = [[XFMyWalletController alloc] init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        };
                        [alert showAlertView];
                        return;
                    }
//                    else if ([model.state isEqualToString:@"3"])
//                    {
//                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已经在用车中" sureBtn:@"确定" cancleBtn:nil];
//                        [alert showAlertView];
//                        return;
//                    }
                    else if ([model.state isEqualToString:@"4"])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您有未完成的订单" sureBtn:@"去处理" cancleBtn:@"取消"];
                        alert.resultIndex = ^(AlertButtonType type) {
                            if (type == AlertButtonTypeSure) {
                                XFMyOrderController *vc = [[XFMyOrderController alloc] init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        };
                        [alert showAlertView];
                        return;
                    }
                    else if ([model.state isEqualToString:@"5"])
                    {
                        if ([carModel.use_type isEqualToString:@"1"]) {
                            
                        }else{
                            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"该车辆需缴纳高押金才能使用" sureBtn:@"去补差价" cancleBtn:@"取消"];
                            alert.resultIndex = ^(AlertButtonType type) {
                                if (type == AlertButtonTypeSure) {
                                    XFMyWalletController *vc = [[XFMyWalletController alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            };
                            [alert showAlertView];
                            return;
                        }
                        
                    }
                    else if ([model.state isEqualToString:@"6"] || [model.state isEqualToString:@"8"])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您有违章未处理" sureBtn:@"去处理" cancleBtn:@"取消"];
                        alert.resultIndex = ^(AlertButtonType type) {
                            if (type == AlertButtonTypeSure) {
                                XFMyBreakRulesController *vc = [[XFMyBreakRulesController alloc] init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        };
                        [alert showAlertView];
                        return;
                    }
                    else if ([model.state isEqualToString:@"7"])
                    {
                        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您的押金正在提现" sureBtn:@"确定" cancleBtn:nil];
                        [alert showAlertView];
                        return;
                        
                    }
                    else if ([model.state isEqualToString:@"0"]|| ([model.state isEqualToString:@"3"]))
                    {
                        if (carModel.status != 0 && carModel.userstatus==2) {
                            [self getUsingCarStatus];
                        }else{
                            XFHomeUseCarInfoView *infoView = [[XFHomeUseCarInfoView alloc] init];
                            infoView.frame = CGRectMake(20*SCALE_WIDTH, SCREENH, SCREENW - 40*SCALE_WIDTH, 605*SCALE_HEIGHT);
                            [self.view addSubview:infoView];
                            [UIView animateWithDuration:0.3 animations:^{
                                infoView.top = SCREENH - (620*SCALE_HEIGHT)-64;
                            }];
                            infoView.delegate=self;
                            if ([model.car isEqualToString:@"0"]) {
                                [infoView setSubMitBtnDisable:YES];
                            }else if (model.usecar && carModel.status == 0){
                                [infoView setSubMitBtnDisable:NO];
                            }
                            __weak typeof(self) weakSelf = self;

                            infoView.costDetailBlock = ^{
                                XFWebViewController * vc = [XFWebViewController new];
                                vc.urlString = weakSelf.infoView.carPriceModel.url;
                                vc.title = weakSelf.infoView.carPriceModel.title;
                                [weakSelf.navigationController pushViewController:vc animated:YES];
                            };
                            infoView.submitBlock = ^{
                                if ([model.car isEqualToString:@"0"] || (model.usecar && carModel.status == 0)) {
                                    [weakSelf clearPlanAndInfoView];
                                    return ;
                                }

                                //上传用车照片
                                XFAlertViewTwo *alert=[[XFAlertViewTwo alloc] initWithCount:@"4" message:@"请根据图上指示拍下车前、后、左、右图并上传" sureBtn:@"去拍照" cancleBtn:@"取消"];
                                alert.resultIndex = ^(AlertTwoButtonType type) {
                                    if (type == AlertButtonTypeSure) {
                                        XFUseCarLoadImageController *vc = [[XFUseCarLoadImageController alloc] init];
                                        vc.successBlock = ^{
                                            
                                            [self submitToUseCar:carModel];
                                        };
                                        vc.navigationItem.title = @"上传图片";
                                        vc.cid = carModel.cid;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                };
                                [alert showAlertView];
                                
                            };
                            self.infoView = infoView;
                            //调用获取价格的接口
                            [self getCarPrice:carModel];

                            
                        }
                        
                        
                    }
                    else
                    {
                        //
                    }
                }
                else
                {
                 //
                }
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)getCarPrice:(XFCarModel *)carModel
{
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:carModel.cid forKey:@"cid"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/car/reserve",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            XFGetCarPriceModel *model = [XFGetCarPriceModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.infoView.carPriceModel = model;
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

- (void) requestDailySignIn {
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/singIn_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            XFSignInModel * model = [XFSignInModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (model.status == 0) {
                XFSignPopView * popView = [XFSignPopView new];
                popView.model = model;
                popView.drawBlock = ^{
                    XFSignInVC * vc = [XFSignInVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                };
                [popView show];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


#pragma mark ----  XFHomeUseCarInfoView delegate

- (void)XFHomeUseCarInfoView:(XFHomeUseCarInfoView *)contentView didClickHCPBtn:(UIButton *)button
{
    NSLog(@"选择还车点");
    XFSelectHCPointViewController *vc = [[XFSelectHCPointViewController alloc] init];
    vc.selectType=@"2";
    vc.passValueDelegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)XFHomeUseCarInfoView:(XFHomeUseCarInfoView *)contentView didClickServicePBtn:(UIButton *)button
{
    NSLog(@"选择服务网点");
    XFSelectHCPointViewController *vc = [[XFSelectHCPointViewController alloc] init];
    vc.selectType=@"1";
    vc.passValueDelegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)SelectHCPointViewPassValue:(NSString *)str type:(NSString *)type
{
    NSLog(@"str==%@",str);
    
    if([type isEqualToString:@"2"])
    {
        [self.infoView.selectHCPointBtnTwo setTitle:str forState:UIControlStateNormal];
    }
    
    if([type isEqualToString:@"1"])
    {
        [self.infoView.selectServicePointBtnTwo setTitle:str forState:UIControlStateNormal];
    }

    
}


-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        NSLog(@"GEO:%@",result.address);
        if (self.infoView) {
            self.infoView.address = result.address;
            [self.infoView setNeedsDisplay];
        }
    }else{
        NSLog(@"找不到");
    }
}
-(void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray *array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            planPointCounts += transitStep.pointsCount;
        }
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine];
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        _theDistance = plan.distance;
        UIButton *btn = [self.selectedAnnoView.paopaoView viewWithTag:1000];
        [btn setTitle:[XFTool stringWithMeter:_theDistance] forState:UIControlStateNormal];
    }

    
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = MAINGREEN;
        polylineView.strokeColor = MAINGREEN;
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat leftTopX, leftTopY, rightBottomX, rightBottomY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    leftTopX = pt.x;
    leftTopY = pt.y;
    rightBottomX = pt.x;
    rightBottomY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
        leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
        rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
        rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTopX, leftTopY);
    rect.size = BMKMapSizeMake(rightBottomX - leftTopX, rightBottomY - leftTopY);
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 0, 100, 0);
    BMKMapRect fitRect = [_mapView mapRectThatFits:rect edgePadding:padding];
    [_mapView setVisibleMapRect:fitRect];
}

- (void) clearPlanAndInfoView {
    [self.selectedAnnoView setSelected:NO];
    [self.selectedAnnoView.paopaoView removeFromSuperview];
    NSArray *array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (self.infoView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.infoView.top = self.view.bottom;
        } completion:^(BOOL finished) {
            [self.infoView removeFromSuperview];
        }];
    }
}
-(void)checkService
{
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/server/updateinfo",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        
        if (responseObject[@"app_end"]!= nil && [responseObject[@"app_end"] intValue] == 0) {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:[NSString stringWithFormat:@"服务器维护"] message:[NSString stringWithFormat:@"服务器维护中，暂时无法为您提供服务，非常抱歉给您带来不便，请您稍候再使用"] sureBtn:@"确定" cancleBtn:nil];
            alert.resultIndex = ^(AlertButtonType type) {
                switch (type) {
                    case AlertButtonTypeSure:
                    {
                        
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        UIWindow *window = app.window;
                        
                        [UIView animateWithDuration:1.0f animations:^{
                            window.alpha = 0;
                            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
                        } completion:^(BOOL finished) {
                            exit(0);
                        }];
                        
                    }
                        break;
                    case AlertButtonTypeCancel:
                        
                        break;
                    default:
                        break;
                }
            };
            [alert showAlertView];
        }else{
            [self checkVersion];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

- (void)checkVersion{
    NSString *urlStr = [NSString stringWithFormat:@"%@id=%@",APP_checkUp,MY_APPID];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        NSArray *array=dic[@"results"];
        NSDictionary *dict = [array lastObject];
        _releaseNotesStr = dict[@"releaseNotes"];
        if (array.count>0) {
            NSDictionary *releaseInfo = [array objectAtIndex:0];
            NSString *latestVersion = [releaseInfo objectForKey:@"version"];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            //获取本地版本号
            _localVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            if ([latestVersion compare:_localVersion]==NSOrderedDescending) {
                NSString * latest = [latestVersion substringWithRange:NSMakeRange(0, 1)];
                NSString * local = [_localVersion substringWithRange:NSMakeRange(0, 1)];
                BOOL forceUpdate = [latest compare:local]==NSOrderedDescending;
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本%@",latestVersion] message:[NSString stringWithFormat:@"版本更新内容:\n%@",_releaseNotesStr] sureBtn:@"立即更新" cancleBtn:forceUpdate ? nil : @"取消"];
                alert.resultIndex = ^(AlertButtonType type) {
                    switch (type) {
                        case AlertButtonTypeSure:
                        {
                            
                            NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/app/id1163445276"];
                            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                            
                        }
                            break;
                        case AlertButtonTypeCancel:
                            
                            break;
                        default:
                            break;
                    }
                };
                
                [alert showAlertView];
            }else{
//                [SVProgressHUD showSuccessWithStatus:@"已是最新版本"];
//                [SVProgressHUD dismissWithDelay:0.85];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
    }];

}


#pragma mark - 广告

- (void) advertDataWithType:(NSString *)type{
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:type forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/My/advert_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject***%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.ActiveListModels removeAllObjects];
            [self.ActiveListModels addObjectsFromArray:[XFActiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
            NSMutableArray *arr=[NSMutableArray array];
            NSMutableArray *dataArr=[NSMutableArray array];

            for (XFActiveListModel *model in self.ActiveListModels) {
                NSLog(@"id=%@\nimage=%@\nlink=%@\ntitle=%@",model.activeId,model.image,model.link,model.title);
                if (model.image != nil) {
                    [arr addObject:[NSURL URLWithString:model.image]];
                }
                [dataArr addObject:model.describe];
            }
            
            
            
            VierticalScrollView *scroView = [[VierticalScrollView alloc] initWithHtmlTitleArray:dataArr AndFrame:CGRectMake(30, 0, self.adView.bounds.size.width - 40, self.adView.bounds.size.height)];
            scroView.delegate = self;
            scroView.isHtmlTitle = YES;
            [self.adView addSubview:scroView];

            if([arr count])
            {
                XFADChooseView *view=[[XFADChooseView alloc] initWithImageArray:arr];
                
                view.topBlock = ^(NSIndexPath *index) {
                    
                    NSLog(@"广告详情");
                    XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
                    webViewController.urlString = self.ActiveListModels[index.item].link;
                    webViewController.webTitle  = self.ActiveListModels[index.item].title;
                    [self.navigationController pushViewController:webViewController animated:YES];
                    
                };
                
                [view show];
            }
            
        }else{
            
            //
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];

}


- (void) submitToUseCar:(XFCarModel *)carModel {
    if (carModel) {
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:carModel.cid forKey:@"cid"];
        [params setObject:carModel.code != nil ? carModel.code : carModel.car_number forKey:@"code"];
        [params setObject:carModel.type forKey:@"type"];
        [params setObject:carModel.color forKey:@"color"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/Car/usecar",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"status"] intValue] == 1) {
                
                //调用添加usercarid的接口
                [self addUserCarId:carModel];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:ServerError];
        }];
    }else{
        return;
    }
}

-(void)addUserCarId:(XFCarModel *)carModel
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:carModel.cid forKey:@"cid"];
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/save_usercarid",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"add_id"] intValue] == 1) {
            
            [self clearPlanAndInfoView];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [SVProgressHUD dismissWithDelay:1.2 completion:^{
                XFUseCarController *vc = [[XFUseCarController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


@end
