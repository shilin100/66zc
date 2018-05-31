//
//  XFSelectHCPointViewController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSelectHCPointViewController.h"


#import "XFLoginNaviController.h"
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

#import "XFSelectHCPointModel.h"
#import "XFUseCarController.h"
//#import "XFMyBreakRulesController.h"
//#import "XFMyLearnDriveController.h"
#import "XFSelectHCPointView.h"
#import "XFSelectHCPointTableViewCell.h"
#import "XFGuildServicePointViewController.h"


@interface XFSelectHCPointViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UIGestureRecognizerDelegate,XFSelectHCPointViewDelegate>

@property (nonatomic, weak) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) NSMutableArray<XFSelectHCPointModel *> *SelectHCPointModel;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) BMKPlanNode *startNode;
@property (nonatomic, strong) BMKPlanNode *endNode;
@property (nonatomic, strong) BMKRouteSearch *routeSearch;
@property (nonatomic, weak) BMKAnnotationView *selectedAnnoView;
@property (nonatomic, weak) XFSelectHCPointView *bottomView;
@property (nonatomic, weak) UIView *cover;
@property (nonatomic, weak) XFSelectHCPointModel *SelectHCPModel;
@property (nonatomic, strong) NSString *detail_addressStr;
@property (nonatomic, weak) XFSelectHCPointModel *selectedHCPointModel;
@property (nonatomic, assign) BOOL isSelectCell;



@end

@implementation XFSelectHCPointViewController

-(NSMutableArray<XFSelectHCPointModel *> *)SelectHCPointModel{
    if (!_SelectHCPointModel) {
        _SelectHCPointModel = [NSMutableArray array];
    }
    return _SelectHCPointModel;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
    
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
    [self setupSubs];
    [self getHCPointData];
    
}

- (void) setupSubs {
    
    if([_selectType isEqualToString:@"2"])
    {
        self.navigationItem.title = @"还车点";
    }
    
    if([_selectType isEqualToString:@"1"])
    {
        self.navigationItem.title = @"查看服务网点";
    }
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = BMKMapTypeStandard;
    [mapView setTrafficEnabled:NO];
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    mapView.zoomLevel = 12;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.505398, 114.414145)];
    mapView.overlookEnabled = NO;
    mapView.rotateEnabled = NO;
    mapView.showMapScaleBar = YES;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isRotateAngleValid = YES;
    param.isAccuracyCircleShow = NO;
    param.locationViewImgName = @"wo";
    param.locationViewOffsetX = 0;
    param.locationViewOffsetY = 0;
    [self.mapView updateLocationViewWithParam:param];
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
        
        [self getHCPointData];
    }];
//    XFButton *myUsingBtn = [[XFButton alloc] init];
//    [myUsingBtn setBackgroundImage:IMAGENAME(@"myUsingCar") forState:UIControlStateNormal];
//    [self.view insertSubview:myUsingBtn aboveSubview:self.mapView];
//    [[myUsingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [self getUsingCarStatus];
//    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40*SCALE_HEIGHT);
        make.right.equalTo(self.view.mas_right).offset(-20*SCALE_WIDTH);
        make.width.height.mas_equalTo(@(62*SCALE_WIDTH));
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
    
//    [myUsingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-40*SCALE_HEIGHT);
//        make.right.equalTo(refreshBtn.mas_left).offset(-20*SCALE_WIDTH);
//        make.width.height.equalTo(refreshBtn);
//    }];
    UIButton *allMsgBtn = [[UIButton alloc] init];
    allMsgBtn.titleLabel.font = XFont(13);
    [allMsgBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [allMsgBtn addTarget:self action:@selector(allMsgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:allMsgBtn];

}
-(void)allMsgBtnAction:(UIButton*)sender{
    if (self.SelectHCPointModel.count > 0) {
        _selectedHCPointModel = nil;
        self.bottomView.indexPath = nil;
        _isSelectCell = NO;
        [self showTableView];
    }
}


- (void) getHCPointData {
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    NSString *uid = model.uid;
    NSString *token = model.token;
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:uid forKey:@"uid"];
    [params setObject:token forKey:@"token"];
    if([_selectType isEqualToString:@"2"])
    {
        [params setObject:@"2" forKey:@"type"];
    }
    
    if([_selectType isEqualToString:@"1"])
    {
        [params setObject:@"1" forKey:@"type"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/Stop/all_serve"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.SelectHCPointModel removeAllObjects];
            [self.SelectHCPointModel addObjectsFromArray:[XFSelectHCPointModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            
            
            for (XFSelectHCPointModel *HCPointModel in self.SelectHCPointModel) {
               
                
                NSLog(@"address===%@",HCPointModel.address);
                NSLog(@"details_address===%@",HCPointModel.details_address);
                
            }
            
            [self setupAnnotations];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            [SVProgressHUD dismissWithDelay:1.6];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"连接超时"];
        [SVProgressHUD dismissWithDelay:1.6];
    }];
}
- (void) setupAnnotations {
    NSMutableArray *annos = [NSMutableArray array];
    for (XFSelectHCPointModel *HCPointModel in self.SelectHCPointModel) {
        XFBMKPointAnnotation *anno = [[XFBMKPointAnnotation alloc] init];
        anno.HCPointModel = HCPointModel;
        anno.title = @"";
        [annos addObject:anno];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:annos];
    
}
-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
//    [self clearPlanAndInfoView];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSString *AnnotationViewID = @"annoIndentifer";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    
    annotationView.pinColor = BMKPinAnnotationColorPurple;
    
    annotationView.animatesDrop = YES;
    annotationView.image = IMAGENAME(@"wangdian");

    if([_selectType isEqualToString:@"2"])
    {
        annotationView.image = IMAGENAME(@"tingche");
    }
    
    if([_selectType isEqualToString:@"1"])
    {
        annotationView.image = IMAGENAME(@"wangdian");
    }
    
    
    //不弹出popview
    annotationView.canShowCallout=NO;
    
    return annotationView;
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:NSClassFromString(@"XFBMKPointAnnotation")]) {
        _selectedHCPointModel = ((XFBMKPointAnnotation *)view.annotation).HCPointModel;
        self.selectedAnnoView = view;
    }else{
        return;
    }
    
    //设置成no才能多次执行该方法
    view.selected=NO;
    
    //底部弹出视图
    [self showTableView];

    
}

-(void) showTableView {
    if (!self.cover) {
        UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        cover.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        self.cover = cover;
        [APPLication.delegate.window addSubview:cover];
        UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
        coverTap.delegate=self;
        [cover addGestureRecognizer:coverTap];
    }
    self.cover.alpha = 1;
        XFSelectHCPointView *bottomView = [[XFSelectHCPointView alloc] initWithFrame:CGRectMake(0, SCREENH, SCREENW, 300)];
        bottomView.backgroundColor=WHITECOLOR;
        bottomView.alpha = 1.0;
        bottomView.delegate = self;
        [self.cover addSubview:bottomView];
        self.bottomView = bottomView;
    self.bottomView.SelectHCPointModelArr=_SelectHCPointModel;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.top = SCREENH-300;
    }];


    if (_selectedHCPointModel) {
        NSInteger row=-1;
        for (XFSelectHCPointModel *model in _SelectHCPointModel) {
            
            row++;
            if((_selectedHCPointModel.details_address.length > 0 && [_selectedHCPointModel.details_address isEqualToString:model.details_address]) || (_selectedHCPointModel.address.length > 0 && [_selectedHCPointModel.address isEqualToString:model.address]))
            {
                NSLog(@"detail===%@",_selectedHCPointModel.details_address);
                break;
            }
            
        }
        NSLog(@"row===%ld",row);
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.bottomView.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.bottomView.show=YES;
        self.bottomView.indexPath=indexPath;

        XFSelectHCPointModel *model = _SelectHCPointModel[row];
        [self SelectHCPointView:self.bottomView didSelectedCell:[NSString stringWithFormat:@"%@%@",model.address,model.details_address]];
    }

}

- (void) coverTap {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.top = SCREENH;
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
//        self.cover.hidden = YES;
//        [self.cover removeFromSuperview];
        self.bottomView.delegate = nil;
        [self.bottomView removeFromSuperview];
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


#pragma mark ----  XFSelectHCPointViewDelegate delegate
- (void)SelectHCPointView:(XFSelectHCPointView *)view didSelectedCancelBtn:(UIButton *)sender
{
    [self coverTap];
}
- (void)SelectHCPointView:(XFSelectHCPointView *)view didSelectedSureBtn:(UIButton *)sender
{

    [self coverTap];

    //暂时去掉回调功能
//    if(_isSelectCell)
//    {
//        [self.passValueDelegate SelectHCPointViewPassValue:_detail_addressStr type:_selectType];
//
//    }
//    else
//    {
//        [self.passValueDelegate SelectHCPointViewPassValue:_selectedHCPointModel.details_address type:_selectType];
//
//    }
//
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    if (_isSelectCell) {
        XFGuildServicePointViewController * vc = [[XFGuildServicePointViewController alloc]init];
        vc.sid = [NSString stringWithFormat:@"%@",_selectedHCPointModel.ID];
        vc.userLocation = self.locService.userLocation;
        vc.model = _selectedHCPointModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)SelectHCPointView:(XFSelectHCPointView *)view didSelectedCell:(NSString *)str
{

     NSLog(@"str===%@",str);
    _isSelectCell=YES;
    _detail_addressStr=str;
    NSInteger row=-1;
    for (XFSelectHCPointModel *model in _SelectHCPointModel) {
        
        row++;
        if([str isEqualToString:[NSString stringWithFormat:@"%@%@",model.address,model.details_address]])
        {
            _selectedHCPointModel = model;
            break;
        }
        
    }

}


@end
