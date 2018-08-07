//
//  XFCleanScoreController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFCleanScoreController.h"
#import "XFCleanScoreView.h"
#import "XFBreakRuleModel.h"

@interface XFCleanScoreController ()<XFCleanScoreViewDelegate>

@property (nonatomic, strong) XFCleanScoreView *contentView;
@property (nonatomic, strong) NSString *imageStr;

@end

@implementation XFCleanScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"销分";
    
    XFCleanScoreView *contentView = [[XFCleanScoreView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    self.contentView.delegate=self;
    self.contentView.model=self.model;
    
}

-(void)XFCleanScoreView:(XFCleanScoreView *)contentView didClickPlusBtn:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [contentView.plusBtn setBackgroundImage:photos[0] forState:UIControlStateNormal];
            
            [self uploadIcon:UIImageJPEGRepresentation(photos[0], 0.3)];
            
        }];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) uploadIcon:(NSData *)iconData {
    
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/submit_points_img",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"2.png" fileName:@"22.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"succ:%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            
            _imageStr=responseObject[@"data"][@"punish_deal_img"];
            NSLog(@"_imageStr==%@",_imageStr);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}


-(void)XFCleanScoreView:(XFCleanScoreView *)contentView didClickCommitBtn:(UIButton *)button
{
    //判断图片是否上传成功
    if (_imageStr.length) {
        [SVProgressHUD showInfoWithStatus:nil];
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:self.model.breakRule_id forKey:@"tid"];
        [params setObject:_imageStr forKey:@"punish_deal_img"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/My/submit_shenhe",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"success:%@",responseObject);
            if ([responseObject[@"status"] intValue] == 1) {
                
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                [SVProgressHUD dismissWithDelay:1.2];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:ServerError];
        }];
        
    }else{
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请先添加图片再提交" sureBtn:@"确定" cancleBtn:nil];
        alert.resultIndex = ^(AlertButtonType type) {
            
            //
        };
        [alert showAlertView];
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
