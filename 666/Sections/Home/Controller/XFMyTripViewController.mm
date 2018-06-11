//
//  XFMyTripViewController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyTripViewController.h"

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
#import "XFUseCarController.h"
#import "XFMyTripCarInfoView.h"
#import "XFMyOrderModel.h"
#import "XFMyTripModel.h"


@interface XFMyTripViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UIGestureRecognizerDelegate>

/** 百度定位地图服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;

/** 百度地图View */
@property (nonatomic,strong) BMKMapView *mapView;

/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;

/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;

/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;

/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;

/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;


@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL display;


@end

@implementation XFMyTripViewController

-(NSMutableArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)locationArrayM
{
    if (_locationArrayM == nil) {
        _locationArrayM = [NSMutableArray array];
    }
    
    return _locationArrayM;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _bmkLocationService.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _bmkLocationService.delegate = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    [self setupSubs];
    
    [self getWalkLineData];
    
}


-(void)getWalkLineData
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.model.order_id forKey:@"order_id"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/car_travel",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1 && [responseObject[@"travel"] intValue] == 1) {
            
//            [SVProgressHUD showSuccessWithStatus:@"有数据"];
           
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[XFMyTripModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];

            for (XFMyTripModel *model in self.dataArr) {
                
                if(self.preLocation)
                {
                    // 计算本次数据与上次数据之间的距离
                    CLLocation *userLocation=[[CLLocation alloc] initWithLatitude:[model.latitude doubleValue] longitude:[model.longtitude doubleValue]];
                    CGFloat distance = [userLocation distanceFromLocation:self.preLocation];
                    NSLog(@"与上一位置点的距离为:%f",distance);
                    
                    // (20米门限值，存储数组划线) 如果距离少于 20 米，则忽略本次数据直接返回该方法
                    if (distance < 20) {
                        NSLog(@"与前一更新点距离小于20m，直接进入下一次循环");
                        continue ;
                    }
                }
                
                CLLocation *lo=[[CLLocation alloc] initWithLatitude:[model.latitude doubleValue] longitude:[model.longtitude doubleValue]];
                [self.locationArrayM addObject:lo];
                self.preLocation = lo;
            }

            NSLog(@"count===%ld",self.locationArrayM.count);
            //绘制轨迹
            [self drawWalkPolyline];
            
            
        }else{
            
//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD showErrorWithStatus:@"无数据"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
        
    }];
}


- (void) setupSubs {
    
    self.navigationItem.title = @"我的行程";
    
    // 初始化地图窗口
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    // 设置MapView的一些属性
    [self.view addSubview:mapView];
    self.mapView=mapView;
    [self setMapViewProperty];
    
    
    // 初始化百度位置服务
    [self initBMLocationService];
    [self startTrack];
    
    
//    XFMyTripCarInfoView *infoView = [[XFMyTripCarInfoView alloc] init];
//    infoView.frame = CGRectMake(20*SCALE_WIDTH, SCREENH-446*SCALE_HEIGHT-64, SCREENW - 40*SCALE_WIDTH, 431*SCALE_HEIGHT);
//    [self.view addSubview:infoView];
//
//    infoView.carModel = self.model;
    
}


#pragma mark - Customize Method

/**
 *  初始化百度位置服务
 */
- (void)initBMLocationService
{
    // 初始化位置百度位置服务
    self.bmkLocationService = [[BMKLocationService alloc] init];
}

/**
 *  设置 百度MapView的一些属性
 */
- (void)setMapViewProperty
{
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    // 允许旋转地图
    self.mapView.rotateEnabled = NO;
    
    // 显示比例尺
    //    self.bmkMapView.showMapScaleBar = YES;
    //    self.bmkMapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    displayParam.locationViewImgName = @"walk";
    [self.mapView updateLocationViewWithParam:displayParam];
}


/**
 *  开启百度地图定位服务
 */
- (void)startTrack
{
    [self.bmkLocationService startUserLocationService];
    
    // 4.设置当前地图的显示范围，直接显示到用户位置
//    BMKCoordinateRegion adjustRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake(self.bmkLocationService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f))];
//    [self.mapView setRegion:adjustRegion animated:YES];
    
}


#pragma mark - BMKLocationServiceDelegate
/**
 *  定位失败会调用该方法
 *
 *  @param error 错误信息
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
//    NSLog(@"did failed locate,error is %@",[error localizedDescription]);
//    UIAlertView *gpsWeaknessWarning = [[UIAlertView alloc]initWithTitle:@"Positioning Failed" message:@"Please allow to use your Location via Setting->Privacy->Location" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [gpsWeaknessWarning show];
}

/**
 *  用户位置更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 1. 动态更新我的位置数据
    [self.mapView updateLocationData:userLocation];
    NSLog(@"La:%f, Lo:%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    if(!_display)
    {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        _display=YES;
    }
    
}

/**
 *  用户方向更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 动态更新我的位置数据
    [self.mapView updateLocationData:userLocation];
}


#pragma mark - Selector for didUpdateBMKUserLocation:

/**
 *  绘制步行轨迹路线
 */
- (void)drawWalkPolyline
{
    //轨迹点
    NSUInteger count = self.locationArrayM.count;
    
    // 手动分配存储空间，结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    [self.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        NSLog(@"idx = %ld,tempPoints X = %f Y = %f",idx,tempPoints[idx].x,tempPoints[idx].y);
        
        // 放置起点旗帜
        if (0 == idx) {
            self.startPoint = [self creatPointWithLocaiton:location title:@"起点"];

        }
    }];
    
    // 5.添加终点旗帜
    if (self.startPoint) {
        self.endPoint = [self creatPointWithLocaiton:[self.locationArrayM lastObject] title:@"终点"];
    }
    
    
    //移除原有的绘图
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    
    //添加路线,绘图
    if (self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    
    // 清空 tempPoints 内存
    delete []tempPoints;
    
    [self mapViewFitPolyLine:self.polyLine];
}

/**
 *  添加一个大头针
 *
 *  @param location
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    
    [self.mapView addAnnotation:point];
    
    return point;
}


/**
 *  根据polyline设置地图范围
 *
 *  @param polyLine
 */
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
}


#pragma mark - BMKMapViewDelegate

/**
 *  根据overlay生成对应的View
 *  @param mapView 地图View
 *  @param overlay 指定的overlay
 *  @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
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

/**
 *  只有在添加大头针的时候会调用，直接在viewDidload中不会调用
 *  根据anntation生成对应的View
 *  @param mapView 地图View
 *  @param annotation 指定的标注
 *  @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        if(self.startPoint){
            
            // 有起点旗帜代表应该放置终点旗帜（程序一个循环只放两张旗帜：起点与终点）
            annotationView.image = IMAGENAME(@"zhong");


        }else {
            // 没有起点旗帜，应放置起点旗帜
            
            annotationView.image = IMAGENAME(@"qi");

        }
        
        
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        
        // 可拖拽
        annotationView.draggable = YES;
        
        return annotationView;
    }
    return nil;
}



@end
