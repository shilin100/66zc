//
//  XFEndCarLoadImageController.m
//  666
//
//  Created by xiaofan on 2017/10/31.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFEndCarLoadImageController.h"

@interface XFEndCarLoadImageController ()
@property (weak, nonatomic) IBOutlet UIView *infoContent;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) UIView *imageContent;
@property (nonatomic, weak) UIButton *plusBtn;
/**<#desc#>*/
@property (nonatomic, assign) CGFloat imgW;

@end

@implementation XFEndCarLoadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgW = (SCREENW - 20 - 40*SCALE_WIDTH) / 3;
    
    self.navigationItem.title = @"上传图片";
    
    // 初始化UI
    [self setupSubs];
    
}
- (void) setupSubs {
    UIView *imageContent = [[UIView alloc] init];
    imageContent.backgroundColor = WHITECOLOR;
    [self.view addSubview:imageContent];
    self.imageContent = imageContent;
    imageContent.sd_layout
    .topSpaceToView(self.infoContent, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    UIButton *plusBtn = [[UIButton alloc] init];
    [plusBtn setBackgroundImage:IMAGENAME(@"shangchuantupian") forState:UIControlStateNormal];
    [plusBtn setBackgroundImage:IMAGENAME(@"shangchuantupian") forState:UIControlStateHighlighted];
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageContent addSubview:plusBtn];
    self.plusBtn = plusBtn;
    plusBtn.sd_layout
    .topSpaceToView(imageContent, 6)
    .widthIs(self.imgW)
    .heightEqualToWidth()
    .leftSpaceToView(imageContent, 10);
    
    [imageContent setupAutoHeightWithBottomView:plusBtn bottomMargin:15];
    
    UIButton *loadBtn = [[UIButton alloc] init];
    [loadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loadBtn.titleLabel.font = XFont(14);
    loadBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:loadBtn];
    [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loadBtn.sd_layout
    .topSpaceToView(self.imageContent, 90*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 25)
    .heightIs(80*SCALE_HEIGHT)
    .rightSpaceToView(self.view, 25);
    
}
- (void)plusBtnClick {
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count != 5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请一次选择5张照片";
            [hud hideAnimated:YES afterDelay:1.6];
            return;
        }else{
            for (UIView *view in self.imageContent.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UIImageView")]) {
                    [view removeAllSubviews];
                }
            }
            
            int i = 100;
            for (UIImage *img in photos) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.tag = i;
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                imgV.clipsToBounds = YES;
                imgV.image = img;
                [self.imageContent addSubview:imgV];
                i++;
            }
        }
        self.plusBtn.sd_layout
        .topSpaceToView(self.imageContent, 6+self.imgW+20*SCALE_HEIGHT)
        .leftSpaceToView(self.imageContent, 10+self.imgW*2+20*SCALE_WIDTH*2);
        
        for (UIImageView *imgV in self.imageContent.subviews) {
            switch (imgV.tag) {
                case 100:
                    imgV.sd_layout
                    .heightIs(self.imgW)
                    .widthEqualToHeight()
                    .topSpaceToView(self.imageContent, 6)
                    .leftSpaceToView(self.imageContent, 10);
                    break;
                case 101:
                    imgV.sd_layout
                    .heightIs(self.imgW)
                    .widthEqualToHeight()
                    .topSpaceToView(self.imageContent, 6)
                    .leftSpaceToView(self.imageContent, 10+self.imgW+20*SCALE_WIDTH);
                    break;
                case 102:
                    imgV.sd_layout
                    .heightIs(self.imgW)
                    .widthEqualToHeight()
                    .topSpaceToView(self.imageContent, 6)
                    .leftSpaceToView(self.imageContent, 10+self.imgW*2+20*SCALE_WIDTH*2);
                    break;
                case 103:
                    imgV.sd_layout
                    .heightIs(self.imgW)
                    .widthEqualToHeight()
                    .topSpaceToView(self.imageContent, 6+self.imgW+20*SCALE_HEIGHT)
                    .leftSpaceToView(self.imageContent, 10);
                    break;
                case 104:
                    imgV.sd_layout
                    .heightIs(self.imgW)
                    .widthEqualToHeight()
                    .topSpaceToView(self.imageContent, 6+self.imgW+20*SCALE_HEIGHT)
                    .leftSpaceToView(self.imageContent, 10+self.imgW+20*SCALE_WIDTH);
                    break;
                    
                default:
                    break;
            }
        }
        
        
        [self.imageContent setNeedsLayout];
        [self.view setNeedsLayout];
        
    }];
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:^{}];
}
- (void) loadBtnClick {
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (UIView *view in self.imageContent.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIImageView")]) {
            [imgs addObject:((UIImageView *)view).image];
        }
    }
    if (imgs.count == 5) {
        [SVProgressHUD showInfoWithStatus:nil];
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:self.cid forKey:@"cid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:self.rid forKey:@"rid"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/car/Submitback_img",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int i = 0;
            for (UIImage *image in imgs) {
                NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%d.jpg",i] fileName:[NSString stringWithFormat:@"%d1.jpg",i] mimeType:@"image/jpg"];
                i++;
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"responseObject==%@",responseObject);
            if ([responseObject[@"status"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                [SVProgressHUD dismissWithDelay:1.2 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    self.loadBlock();
                }];
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:ServerError];
        }];
        
    }else{
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请依次选中5张图片" sureBtn:@"确定" cancleBtn:nil];
        alert.resultIndex = ^(AlertButtonType type) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self plusBtnClick];
        };
        [alert showAlertView];
    }
    
}
@end
