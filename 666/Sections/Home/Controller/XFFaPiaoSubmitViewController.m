//
//  XFFaPiaoSubmitViewController.m
//  666
//
//  Created by TDC_MacMini on 2017/12/4.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFFaPiaoSubmitViewController.h"
#import "XFFaPiaoSubmitView.h"
#import "HZAreaPickerView.h"
#import "XFFaPiaoSubmitSelectPersonView.h"

@interface XFFaPiaoSubmitViewController ()<XFFaPiaoSubmitViewDelegate,HZAreaPickerDelegate,XFFaPiaoSubmitSelectPersonViewDelegate>

@property (nonatomic, strong) XFFaPiaoSubmitView *contentView;
@property (nonatomic, strong) XFFaPiaoSubmitSelectPersonView *selectPersoncontentView;
@property (nonatomic, strong) HZAreaPickerView *areaPicker;

@end

@implementation XFFaPiaoSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发票开具";
    
    XFFaPiaoSubmitView *contentView = [[XFFaPiaoSubmitView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    contentView.delegate=self;
    [self.view addSubview:contentView];
    self.contentView=contentView;
    
    //选择个人的时候
    XFFaPiaoSubmitSelectPersonView *selectPersoncontentView = [[XFFaPiaoSubmitSelectPersonView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    selectPersoncontentView.delegate=self;
    [self.view addSubview:selectPersoncontentView];
    self.selectPersoncontentView=selectPersoncontentView;
    selectPersoncontentView.hidden=YES;
}


-(void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickAreaBtn:(UIButton *)button
{
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

-(void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickCommitBtn:(UIButton *)button
{
    NSString *fpttStr = self.contentView.fpttTF.text;
    NSString *sbhStr = self.contentView.sbhTF.text;
    NSString *fpMoneyStr = self.contentView.fpMoneyTF.text;
    NSString *moreInfoStr = self.contentView.moreInfoTF.text;
    NSString *receivePersonStr = self.contentView.receivePersonTF.text;
    NSString *phoneStr = self.contentView.phoneTF.text;
    NSString *area = self.contentView.areaLbl.text;
    NSString *address = self.contentView.addressTF.text;
    NSString *fpContent=self.contentView.fpnrLabel2.text;
    NSString *head_style=self.contentView.companyTTBtn.selected?@"1":@"2";

    if (fpttStr.length && sbhStr.length && fpMoneyStr.length && receivePersonStr.length && phoneStr.length && area.length && address.length && moreInfoStr.length)
    {
        if (![XFTool validateMobile:phoneStr])
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
            return;
        }
        
        if([fpMoneyStr floatValue]<300)
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"开票金额必须大于等于300元" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        else
        {
            if(_syMoney<300)
            {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"剩余金额必须大于等于300元才能开票" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
            }
            else
            {
                NSLog(@"fpttStr=%@,sbhStr=%@,fpMoneyStr=%@,moreInfoStr=%@,receivePersonStr=%@,phoneStr=%@,area=%@,address=%@,fpContent=%@,head_style=%@",fpttStr,sbhStr,fpMoneyStr,moreInfoStr,receivePersonStr,phoneStr,area,address,fpContent,head_style);
                
                [SVProgressHUD show];
                NSMutableDictionary *params = [XFTool baseParams];
                XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
                NSLog(@"id===%@",model.uid);
                [params setObject:model.uid forKey:@"uid"];
                [params setObject:model.token forKey:@"token"];
                [params setObject:head_style forKey:@"head_style"];
                [params setObject:fpttStr forKey:@"head"];
                [params setObject:sbhStr forKey:@"identify"];
                [params setObject:fpContent forKey:@"content"];
                [params setObject:fpMoneyStr forKey:@"money"];
                [params setObject:moreInfoStr forKey:@"more_info"];
                [params setObject:receivePersonStr forKey:@"name"];
                [params setObject:phoneStr forKey:@"tel"];
                [params setObject:area forKey:@"area"];
                [params setObject:address forKey:@"address"];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:[NSString stringWithFormat:@"%@/Car/invoice",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [SVProgressHUD dismiss];
                    NSLog(@"success:%@",responseObject);
                    if ([responseObject[@"status"] intValue] == 1)
                    {
                        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                        [SVProgressHUD dismissWithDelay:1.2];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    //                NSLog(@"error:%@",error);
                    NSError *underError = error.userInfo[@"NSUnderlyingError"];
                    NSData *responseData = underError.userInfo[@"com.alamofire.serialization.response.error.data"];
                    NSString *result = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
                    NSLog(@"result===%@",result);
                    [SVProgressHUD showErrorWithStatus:ServerError];
                }];
            }
        }
    }
    
    else
    {
        
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }
    
}

#pragma mark - 选择个人
-(void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickAreaBtn:(UIButton *)button
{
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

-(void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickCommitBtn:(UIButton *)button
{
    NSString *fpMoneyStr = self.selectPersoncontentView.fpMoneyTF.text;
    NSString *moreInfoStr = self.selectPersoncontentView.moreInfoTF.text;
    NSString *receivePersonStr = self.selectPersoncontentView.receivePersonTF.text;
    NSString *phoneStr = self.selectPersoncontentView.phoneTF.text;
    NSString *area = self.selectPersoncontentView.areaLbl.text;
    NSString *address = self.selectPersoncontentView.addressTF.text;
    NSString *fpContent=self.selectPersoncontentView.fpnrLabel2.text;
    NSString *head_style=self.selectPersoncontentView.companyTTBtn.selected?@"1":@"2";
    
    
    if (fpMoneyStr.length && receivePersonStr.length && phoneStr.length && area.length && address.length && moreInfoStr.length)
    {
        if (![XFTool validateMobile:phoneStr])
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
            return;
        }
        
        if([fpMoneyStr floatValue]<300)
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"开票金额必须大于等于300元" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        else
        {
            if(_syMoney<300)
            {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"剩余金额必须大于等于300元才能开票" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
            }
            else
            {
                NSLog(@"fpMoneyStr=%@,moreInfoStr=%@,receivePersonStr=%@,phoneStr=%@,area=%@,address=%@,fpContent=%@,head_style=%@",fpMoneyStr,moreInfoStr,receivePersonStr,phoneStr,area,address,fpContent,head_style);
                
                [SVProgressHUD show];
                NSMutableDictionary *params = [XFTool baseParams];
                XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
                NSLog(@"id===%@",model.uid);
                [params setObject:model.uid forKey:@"uid"];
                [params setObject:model.token forKey:@"token"];
                [params setObject:head_style forKey:@"head_style"];
                [params setObject:@"1" forKey:@"head"];
                [params setObject:@"1" forKey:@"identify"];
                [params setObject:fpContent forKey:@"content"];
                [params setObject:fpMoneyStr forKey:@"money"];
                [params setObject:moreInfoStr forKey:@"more_info"];
                [params setObject:receivePersonStr forKey:@"name"];
                [params setObject:phoneStr forKey:@"tel"];
                [params setObject:area forKey:@"area"];
                [params setObject:address forKey:@"address"];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:[NSString stringWithFormat:@"%@/Car/invoice",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [SVProgressHUD dismiss];
                    NSLog(@"success:%@",responseObject);
                    if ([responseObject[@"status"] intValue] == 1)
                    {
                        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                        [self.navigationController popViewControllerAnimated:YES];
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
            
        }
        
    }
    
    else
    {
        
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }
    
}


-(void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickCompanyBtn:(UIButton *)button
{
    //
    
}

-(void)XFFaPiaoSubmitView:(XFFaPiaoSubmitView *)contentView didClickPersonBtn:(UIButton *)button
{
    self.contentView.hidden=YES;
    self.selectPersoncontentView.hidden=NO;
    self.selectPersoncontentView.companyTTBtn.selected=NO;
    self.selectPersoncontentView.personTTBtn.selected=YES;
    
}




-(void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickCompanyBtn:(UIButton *)button
{
     self.selectPersoncontentView.hidden=YES;
    self.contentView.hidden=NO;
    self.contentView.companyTTBtn.selected=YES;
    self.contentView.personTTBtn.selected=NO;
   
}

-(void)XFFaPiaoSubmitSelectPersonView:(XFFaPiaoSubmitSelectPersonView *)contentView didClickPersonBtn:(UIButton *)button
{
//
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
