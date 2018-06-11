//
//  XFGiveCarServiceYCController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceYCController.h"
#import "XFGiveCarServiceYCView.h"
#import "HZAreaPickerView.h"
#import "UWDatePickerView.h"
#import "XFVerifyUserInfoModel.h"
#import "XFMineInfoController.h"

@interface XFGiveCarServiceYCController ()<XFGiveCarServiceYCViewDelegate,HZAreaPickerDelegate,UWDatePickerViewDelegate>

{
    UWDatePickerView *_pickerView;
}

@property (nonatomic, strong) XFGiveCarServiceYCView *contentView;
@property (nonatomic, strong) HZAreaPickerView *areaPicker;
@property (nonatomic, strong) CDZPicker *carBrandPicker;
@property (nonatomic, strong) NSMutableArray * carBrandArr;
@property (nonatomic, strong) NSMutableArray * subCarBrandArr;

@end

@implementation XFGiveCarServiceYCController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"送车服务";
    
    XFGiveCarServiceYCView *contentView = [[XFGiveCarServiceYCView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    contentView.delegate=self;
    [self.view addSubview:contentView];
    self.contentView=contentView;
    [self requestCarType];
}


-(void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickCommitBtn:(UIButton *)button
{
    NSString *area = self.contentView.areaLbl.text;
    NSString *address = self.contentView.addressTF.text;
    NSString *carType = self.contentView.carTypeLbl.text;
    NSString *time = self.contentView.timeLbl.text;
    NSString *name = self.contentView.peopleTF.text;
    NSString *phone = self.contentView.phoneTF.text;
    
    if (![area isEqualToString:@"请选择区域"] && address.length && ![carType isEqualToString:@"请选择车型"] && ![time  isEqualToString:@"请选择用车时间"] && name.length && phone.length)
    {
        if (![XFTool validateMobile:phone])
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
            return;
        }
        
        //没完善资料不能约车
        [self verifyUserInfo];
    
    }else{

        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }
   
}

-(void)verifyUserInfo
{
    NSString *area = self.contentView.areaLbl.text;
    NSString *address = self.contentView.addressTF.text;
    NSString *carType = self.contentView.carTypeLbl.text;
    NSString *time = self.contentView.timeLbl.text;
    NSString *name = self.contentView.peopleTF.text;
    NSString *phone = self.contentView.phoneTF.text;
    
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
                //资料完善才能提交
            NSLog(@"area=%@,address=%@,cartype=%@,time=%@,name=%@,phone=%@",area,address,carType,time,name,phone);
                [SVProgressHUD show];
                NSMutableDictionary *params = [XFTool baseParams];
                XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
                [params setObject:model.uid forKey:@"uid"];
                [params setObject:model.token forKey:@"token"];
                [params setObject:area forKey:@"area"];
                [params setObject:address forKey:@"address"];
                [params setObject:carType forKey:@"hope_car"];
                [params setObject:time forKey:@"use_time"];
                [params setObject:name forKey:@"name"];
                [params setObject:phone forKey:@"tel"];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:[NSString stringWithFormat:@"%@/Car/send_car",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [SVProgressHUD dismiss];
                    NSLog(@"success:%@",responseObject);
                    if ([responseObject[@"status"] intValue] == 1)
                    {
                        if([responseObject[@"apply"] intValue] == 1)
                        {
                            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                            [SVProgressHUD dismissWithDelay:1.2];
                        }
                        
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                        [SVProgressHUD dismissWithDelay:1.2];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    NSLog(@"error:%@",error);
                    [SVProgressHUD showErrorWithStatus:ServerError];
                }];
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

-(void)requestCarType{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/sendCar",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            self.carBrandArr = [NSMutableArray arrayWithArray:[responseObject[@"result"][@"brand"]  valueForKeyPath:@"brand"]];
            
            self.subCarBrandArr = [NSMutableArray array];
            for (NSArray * arr in responseObject[@"result"][@"type"]) {
                [self.subCarBrandArr addObject:[arr valueForKeyPath:@"brand"]];
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

/**区域选择*/
-(void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickAreaBtn:(UIButton *)button{
    if (!_areaPicker) {
        _areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        _areaPicker.pickerDidChangeStatus = ^(HZAreaPickerView *picker) {
            
            if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                contentView.areaLbl.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state, picker.locate.city, picker.locate.district];
            } else{
                
            }
        };
    }
    [_areaPicker showInView:self.view];
}

-(void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickCarBrandBtn:(UIButton *)button{
    NSMutableArray * arr;
    arr = [NSMutableArray array];
    for (int i = 0; i < self.carBrandArr.count; i++) {
        CDZPickerComponentObject *temp = [[CDZPickerComponentObject alloc]initWithText:self.carBrandArr[i]];
        temp.subArray = [NSMutableArray array];
        for (NSString * str in self.subCarBrandArr[i]) {
            CDZPickerComponentObject *subTemp = [[CDZPickerComponentObject alloc]initWithText:str];
            [temp.subArray addObject:subTemp];
        }
        [arr addObject:temp];
    }

    CDZPickerBuilder * builder = [CDZPickerBuilder new];
    builder.pickerTextColor = MAINGREEN;
    builder.pickerHeight = 256;
    WeakSelf;
    _carBrandPicker = [CDZPicker showLinkagePickerInView:self.view withBuilder:builder components:arr confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        weakSelf.contentView.carTypeLbl.text = [strings componentsJoinedByString:@" "];
        NSLog(@"strings:%@ indexs:%@",strings,indexs);
    }cancel:^{
        //your code
    }];

    
    //    contentView.carTypeLbl.text = value;

}


/**时间选择*/
-(void)XFGiveCarServiceYCView:(XFGiveCarServiceYCView *)contentView didClickTimeBtn:(UIButton *)button
{
    [self setupDateView:DateTypeOfStart];
}

#pragma mark =======  PickerView ========
//选择时间的代码，时间选择器
- (void)setupDateView:(DateType)type {
    
    _pickerView = [UWDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = type;
    _pickerView.datePickerView.minimumDate = [NSDate date];
    
    [self.view addSubview:_pickerView];
}


- (void)getSelectDate:(NSString *)date systemDate:(NSDate *)sysDate type:(DateType)type{

    self.contentView.timeLbl.text=date;
    
    switch (type) {
        case DateTypeOfStart:// TODO 日期确定选择
            break;
        case DateTypeOfEnd:// TODO 日期取消选择
            break;
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
