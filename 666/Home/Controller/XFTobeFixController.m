//
//  XFTobeFixController.m
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFTobeFixController.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface XFTobeFixController () <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    UIImagePickerController *_imagePickerController;
}

@property (weak, nonatomic) IBOutlet UITextField *addTF;
@property (weak, nonatomic) IBOutlet UITextView *detailTV;
@property (weak, nonatomic) IBOutlet UIButton *plusPhotoBtn;
@property (weak, nonatomic) IBOutlet UIView *photoContent;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation XFTobeFixController

-(NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车辆报修";
    
//    self.plusPhotoBtn.layer.borderWidth = 1;
//    self.plusPhotoBtn.layer.borderColor = HEXCOLOR(@"#bebebe").CGColor;
    
    // location ／ geo
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    // imagePickerController
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = NO;
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)currentLocationClick {
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
- (IBAction)plusPhotoClick {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    if (self.photos.count == 3) {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"最多上传3张照片" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }else{
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}
- (IBAction)submitBtnClick {
    
    NSString *location = self.addTF.text;
    NSString *remark = self.detailTV.text;
    if (location.length == 0 ||  remark.length == 0 || self.photos.count==0) {
        
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"必填信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;
    }
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    [params setObject:remark forKey:@"cause"];
    [params setObject:location forKey:@"address"];
    [params setObject:_cid forKey:@"cid"];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/Car/repairs",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        for (UIImage *image in self.photos) {
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%d.png",i] fileName:[NSString stringWithFormat:@"%d1.png",i] mimeType:@"image/png"];
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"succ:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            if ([responseObject[@"img_status"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [SVProgressHUD dismissWithDelay:1.2 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
            [SVProgressHUD dismissWithDelay:1.2];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];

}

#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_OPEN_NO_ERROR) {
        self.addTF.text = result.address;
        [self.view endEditing:YES];
    }
    
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (self.photos.count < 3) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSData *fileData = UIImageJPEGRepresentation(image, 0.2);
        UIButton *imgBtn = [[UIButton alloc] init];
        [imgBtn setBackgroundImage:[UIImage imageWithData:fileData] forState:UIControlStateNormal];
        [self.photoContent addSubview:imgBtn];
        
        [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.plusPhotoBtn.mas_top);
            make.left.equalTo(self.plusPhotoBtn.mas_right).offset(10 + 78*self.photos.count);
            make.bottom.equalTo(self.plusPhotoBtn.mas_bottom);
            make.width.equalTo(self.plusPhotoBtn.mas_width);
        }];
        
        [self.photos addObject:image];
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
