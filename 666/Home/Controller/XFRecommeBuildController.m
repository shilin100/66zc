//
//  XFRecommeBuildController.m
//  666
//
//  Created by xiaofan on 2017/10/20.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFRecommeBuildController.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface XFRecommeBuildController () <UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKPoiSearch *_poiSearch;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITextField *stationTF;
@property (weak, nonatomic) IBOutlet UITextField *stationDetailTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic, strong) NSMutableArray<BMKPoiInfo *> *results;


@end

@implementation XFRecommeBuildController
-(NSMutableArray<BMKPoiInfo *> *)results{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    _poiSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _poiSearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultTableView.hidden = YES;
    self.resultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.searchTF addTarget:self action:@selector(searchAddressChanged) forControlEvents:UIControlEventEditingChanged];
    
    // location ／ geo
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    _poiSearch = [[BMKPoiSearch alloc] init];
    
    
    self.searchTF.delegate = self;
    
    self.commitBtn.layer.cornerRadius = self.commitBtn.height*0.5;
    self.commitBtn.clipsToBounds = YES;
    
    self.remarkTV.layer.borderWidth = 0.5;
    self.remarkTV.layer.borderColor = HEXCOLOR(@"eeeeee").CGColor;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark - FUNC
- (IBAction)currentLocationBtnClick {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    if (_locService.userLocation.location.coordinate.latitude != 0 && _locService.userLocation.location.coordinate.longitude != 0) {
        pt = (CLLocationCoordinate2D){
            _locService.userLocation.location.coordinate.latitude,
            _locService.userLocation.location.coordinate.longitude
        };
        
        
        
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOptions = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeSearchOptions.reverseGeoPoint = pt;
        
        BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOptions];// 发送反编码请求
        if (flag) {
            NSLog(@"geo success");
        }else{
            NSLog(@"geo faild");
        }
    }
}
- (IBAction)commitBtnClick {
    
    NSString *location = self.searchTF.text;
    NSString *station = self.stationTF.text;
    NSString *stationDetail = self.stationDetailTF.text;
    NSString *price = self.priceTF.text;
    NSString *remark = self.remarkTV.text;
    if (location.length == 0 || station.length == 0 || stationDetail.length == 0 ) {
       
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"必填信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;
    }
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:station forKey:@"stop_name"];
    [params setObject:stationDetail forKey:@"site"];
    if (price.length) {
        [params setObject:price forKey:@"stop_money"];
    }
    if (remark.length) {
        [params setObject:remark forKey:@"content"];
    }
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Stop/recommend_stop",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"suc===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            if ([responseObject[@"success"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [SVProgressHUD dismissWithDelay:1.2 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}
#pragma mark - UITextFieldDelegate
- (void) searchAddressChanged {
    NSString *add = self.searchTF.text;
    
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.keyword = add;
    
    BOOL flag = [_poiSearch poiSearchInCity:option];
    if (flag) {
//        NSLog(@"poi search success");
    }else{
        NSLog(@"poi search faild");
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *add = self.searchTF.text;
//    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
//    option.pageIndex = 0;
//    option.pageCapacity = 10;
//    option.keyword = add;
//
//    BOOL flag = [_poiSearch poiSearchInCity:option];
//    if (flag) {
//        NSLog(@"poi search success");
//    }else{
//        NSLog(@"poi search faild");
//    }
    
    return YES;
}
#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_OPEN_NO_ERROR) {
        self.searchTF.text = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        self.resultTableView.hidden = YES;
        [self.view endEditing:YES];
    }
    
}
#pragma mark - BMKPoiSearchDelegate
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        self.resultTableView.hidden = NO;
        [self.results removeAllObjects];
        [self.results addObjectsFromArray:poiResult.poiInfoList];
        if (self.results.count == 0) {
            self.resultTableView.hidden = YES;
        }else{
            self.resultTableView.hidden = NO;
            [self.resultTableView reloadData];
        }
    }
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"resultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.results[indexPath.row].name;
    cell.detailTextLabel.text = self.results[indexPath.row].address;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchTF.text = [NSString stringWithFormat:@"%@%@",self.results[indexPath.row].name,self.results[indexPath.row].address];
    [self.view endEditing:YES];
    tableView.hidden = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
