//
//  XFUseCarController.m
//  666
//
//  Created by xiaofan on 2017/10/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFUseCarController.h"
#import "XFCarModel.h"
#import "XFTobeFixController.h"
#import "XFUseCarLoadImageController.h"
#import "XFEndCarLoadImageController.h"
#import "XFMyOrdersDetailController.h"
#import "XFGetMyCarUseModel.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "XFCar_endModel.h"
#import "XFAlertViewTwo.h"
#import "XFSelectHCPointViewController.h"

@interface XFUseCarController ()<BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *engineTypeLbl;
@property (weak, nonatomic) IBOutlet UIButton *submitFixBtn;
@property (weak, nonatomic) IBOutlet UIButton *endUseBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeDoorBtn;
@property (weak, nonatomic) IBOutlet UIButton *opneDoorBtn;


@property (weak, nonatomic) IBOutlet UILabel *notifiLbl;


@property (strong,nonatomic) XFGetMyCarUseModel *carModel;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (strong,nonatomic) NSString *cid;


@end

@implementation XFUseCarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
     [self getMyCarUse];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"用车";
    self.notifiLbl.hidden=YES;
    self.submitFixBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    self.endUseBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    self.closeDoorBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    self.opneDoorBtn.layer.borderColor = WHITECOLOR.CGColor;
    self.opneDoorBtn.layer.borderWidth=1;
    self.opneDoorBtn.backgroundColor=MAINGREEN;
    [self.opneDoorBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    
    //定位获取经纬度计算距离
    BMKLocationService *locService = [[BMKLocationService alloc] init];
    locService.delegate = self;
    [locService startUserLocationService];
    self.locService = locService;
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    _userLocation=userLocation;
}


-(void)getMyCarUse
{
//    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/myuse",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        NSLog(@"responseObject&&&===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            _carModel = [XFGetMyCarUseModel mj_objectWithKeyValues:responseObject];
            
            if([_carModel.islock isEqualToString:@"0"])
            {
                self.opneDoorBtn.layer.borderColor = WHITECOLOR.CGColor;
                self.opneDoorBtn.layer.borderWidth=1;
                self.opneDoorBtn.backgroundColor=MAINGREEN;
                [self.opneDoorBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                
                self.closeDoorBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
                self.closeDoorBtn.backgroundColor=CLEARCOLOR;
                [self.closeDoorBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            }
            else
            {
                self.opneDoorBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
                self.opneDoorBtn.layer.borderWidth=1;
                self.opneDoorBtn.backgroundColor=CLEARCOLOR;
                [self.opneDoorBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                
                self.closeDoorBtn.layer.borderColor = WHITECOLOR.CGColor;
                self.closeDoorBtn.backgroundColor=MAINGREEN;
                [self.closeDoorBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
            }
            

            self.numberLbl.text = _carModel.code;
            self.typeLbl.text = _carModel.type;
            if([_carModel.is_oil isEqualToString:@"1"])
            {
                self.engineTypeLbl.text = @"油车";
            }
            else
            {
                self.engineTypeLbl.text = @"电车";
            }
            
            if([_carModel.color isEqualToString:@"1"])
            {
                self.colorLbl.text = @"金色";
                
            }
            else if ([_carModel.color isEqualToString:@"2"])
            {
                self.colorLbl.text = @"灰色";
            }
            else if ([_carModel.color isEqualToString:@"3"])
            {
                self.colorLbl.text = @"黑色";
            }
            else if ([_carModel.color isEqualToString:@"4"])
            {
                self.colorLbl.text = @"白色";
            }
            else if ([_carModel.color isEqualToString:@"5"])
            {
                self.colorLbl.text = @"红色";
            }
            else if ([_carModel.color isEqualToString:@"6"])
            {
                self.colorLbl.text = @"银色";
            }
            else if ([_carModel.color isEqualToString:@"7"])
            {
                self.colorLbl.text = @"其它";
            }
            else
            {
                self.colorLbl.text = _carModel.color.length>0?_carModel.color:@"无";
            }
            
            _cid=_carModel.cid;
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
        
    }];
}


- (IBAction)openDoorBtnClick {
    
//    NSLog(@"%@==%@==%@",_carModel.code,_carModel.type,_carModel.longtitude); NSLog(@"long===%lf\nlati===%lf",_userLocation.location.coordinate.longitude,_userLocation.location.coordinate.latitude);
//    NSLog(@"long2===%lf\nlati2===%lf",[_carModel.longtitude doubleValue],[_carModel.latitude doubleValue]);
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_userLocation.location.coordinate.latitude, _userLocation.location.coordinate.longitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([_carModel.latitude doubleValue], [_carModel.longtitude doubleValue]));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    NSLog(@"距离==%lf米",distance);
    
    //判断距离是否在500米内
    if(distance<=500)
    {
        if([_carModel.islock isEqualToString:@"0"])
        {
            [self openLock];
        }
        else
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已开锁" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        
    }
    else
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"500米以外无法开锁" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }
    
}

- (void) openLock {
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.carModel.cid forKey:@"cid"];
    [params setObject:self.carModel.code forKey:@"code"];
    NSLog(@"cid==%@\ncode==%@",self.carModel.cid,self.carModel.code);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/lock",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"open===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"开锁成功"];
            
            self.opneDoorBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
            self.opneDoorBtn.layer.borderWidth=1;
            self.opneDoorBtn.backgroundColor=CLEARCOLOR;
            [self.opneDoorBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            
            self.closeDoorBtn.layer.borderColor = WHITECOLOR.CGColor;
            self.closeDoorBtn.backgroundColor=MAINGREEN;
            [self.closeDoorBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
            
            //调用接口刷新锁的状态
            [self getMyCarUse];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"<<%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}
- (IBAction)closeDoorClick {
    
    if([_carModel.islock isEqualToString:@"0"])
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已锁门" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        
    }
    else
    {
        [self doLockDoor];
    }
    
    
}
- (void) doLockDoor {
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.carModel.cid forKey:@"cid"];
    [params setObject:self.carModel.code forKey:@"code"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/offlock",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"close===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"锁车成功"];
            
            self.opneDoorBtn.layer.borderColor = WHITECOLOR.CGColor;
            self.opneDoorBtn.layer.borderWidth=1;
            self.opneDoorBtn.backgroundColor=MAINGREEN;
            [self.opneDoorBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
            
            self.closeDoorBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
            self.closeDoorBtn.backgroundColor=CLEARCOLOR;
            [self.closeDoorBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            
            //调用接口刷新锁的状态
            [self getMyCarUse];
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
        
    }];
}

-(void)canEndTrip{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/car/serve",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary * dic = responseObject[@"data"];

        if ([responseObject[@"status"] intValue] == 1 && [dic boolValueForKey:@"isEnter" default:false]) {
            [self isHavePerson];
        }else{
            [SVProgressHUD dismiss];
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"服务点范围内才能结束行程，请靠近服务点。" sureBtn:@"确定" cancleBtn:@"查看服务点"];
            alert.resultIndex = ^(AlertButtonType type) {
                if (type == AlertButtonTypeCancel) {
                    XFSelectHCPointViewController * vc = [XFSelectHCPointViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                };
            };
            [alert showAlertView];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];

    
}

-(void)isHavePerson
{
    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请保证手刹、电源、车窗及车灯已关闭并且车内无人" sureBtn:@"已关闭" cancleBtn:@"未关闭"];
    alert.resultIndex = ^(AlertButtonType type) {
        switch (type) {
            case AlertButtonTypeSure: //
                [self uploadImage];
                break;
            case AlertButtonTypeCancel://
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"无法结束行程";
                [hud hideAnimated:YES afterDelay:1.2];
            }
                break;
            default:
                break;
        }
    };
    [alert showAlertView];

}

//-(void)shousha
//{
//    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手刹是否拉紧？" sureBtn:@"是" cancleBtn:@"否"];
//    alert.resultIndex = ^(AlertButtonType type) {
//        switch (type) {
//            case AlertButtonTypeSure:
//                [self dianyuan];
//                break;
//            case AlertButtonTypeCancel:
//            {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.label.text = @"无法结束行程";
//                [hud hideAnimated:YES afterDelay:1.2];
//            }
//                break;
//            default:
//                break;
//        }
//    };
//    [alert showAlertView];
//}
//
//-(void)dianyuan
//{
//    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"电源、窗户及车灯是否关闭？" sureBtn:@"是" cancleBtn:@"否"];
//    alert.resultIndex = ^(AlertButtonType type) {
//        switch (type) {
//            case AlertButtonTypeSure:
//                [self uploadImage];
//                break;
//            case AlertButtonTypeCancel:
//            {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.label.text = @"无法结束行程";
//                [hud hideAnimated:YES afterDelay:1.2];
//            }
//                break;
//            default:
//                break;
//        }
//    };
//    [alert showAlertView];
//}

-(void)uploadImage
{
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.carModel.cid forKey:@"cid"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/check_need",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"succ:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            if ([responseObject[@"data"][@"is_need"] intValue] == 1) {
                
                XFAlertViewTwo *alert=[[XFAlertViewTwo alloc] initWithCount:@"5" message:@"请根据图上指示拍下车前、后、左、右、车内图并上传" sureBtn:@"确定" cancleBtn:nil];
                alert.resultIndex = ^(AlertTwoButtonType type) {
                    if (type == AlertButtonTypeSure) {
                        XFEndCarLoadImageController *vc = [[XFEndCarLoadImageController alloc] init];
                        vc.loadBlock = ^{
                            [self endUseCar];
                        };
                        vc.cid = self.carModel.cid;
                        vc.rid = responseObject[@"data"][@"rid"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:vc animated:YES];
                        });
                    }
                };
                [alert showAlertView];
            }else{
                [self endUseCar];
            }
        }
        
        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}


- (IBAction)endUseBtnClick {
    
    if([_carModel.islock isEqualToString:@"1"])
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请先关锁后再结束行程" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        
    }
    else
    {
        [self canEndTrip];
    }
    
    
}
- (void) endUseCar {

    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:self.carModel.cid forKey:@"cid"];
    [params setObject:self.carModel.code forKey:@"number"];
    [params setObject:@"1" forKey:@"user_type"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/Pay/car_end",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"end===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            NSString *str=[NSString stringWithFormat:@"%@",responseObject[@"id"]];
            if(StrISEMPTY(str))
            {
                [SVProgressHUD showInfoWithStatus:@"用车时间太短,无法创建订单"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"结束成功"];
                [SVProgressHUD dismissWithDelay:1.2];
                
                XFCar_endModel *endModel = [XFCar_endModel mj_objectWithKeyValues:responseObject];
                XFMyOrdersDetailController *vc=[[XFMyOrdersDetailController alloc] init];
                vc.endModel=endModel;
                vc.typeStr=@"endPay";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

- (IBAction)submitFixClick {
    XFTobeFixController *vc = [[XFTobeFixController alloc] init];
    vc.cid=_cid;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
