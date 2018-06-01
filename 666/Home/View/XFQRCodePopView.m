//
//  XFQRCodePopView.m
//  666
//
//  Created by 123 on 2018/6/1.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFQRCodePopView.h"
#import <CoreImage/CoreImage.h>
#import <UShareUI/UShareUI.h>


@implementation XFQRCodePopView
{
    UIImage * tempQRImg;
}

-(instancetype)initQRCodePopView{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView * grayCover = [UIView new];
        grayCover.backgroundColor = GRAYCOLOR;
        grayCover.alpha = 0.3;
        [self addSubview:grayCover];
        [grayCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CGFloat width = 240;
        CGFloat height = 305;
        
        UIView * content = [UIView new];
        content.backgroundColor = WHITECOLOR;
        content.layer.cornerRadius = 5;
        content.clipsToBounds = YES;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        UIButton * closeBtn = [[UIButton alloc]init];
        closeBtn.backgroundColor = WHITECOLOR;
        [content addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_top).with.offset(0);
            make.right.equalTo(content.mas_right).with.offset(0);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@30);

        }];
        
        UILabel * msgLabel  = [UILabel new];
        msgLabel.text = @"邀请好友扫描二维码\n注册下载APP得租车返利佣金";
        msgLabel.numberOfLines = 0;
        msgLabel.textColor = GRAYTEXT;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = XFont(12);
        [content addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(10);
            make.right.equalTo(content.mas_right).with.offset(-10);
            make.top.equalTo(closeBtn.mas_bottom).with.offset(-10);
            make.height.mas_equalTo(@30);

        }];

        UIImageView * qrImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        qrImage.contentMode = UIViewContentModeScaleAspectFit;
        qrImage.image = [self creatQRImage];
        [self addSubview:qrImage];
        [qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content.mas_left).with.offset(10);
            make.right.equalTo(content.mas_right).with.offset(-10);
            make.top.equalTo(msgLabel.mas_bottom).with.offset(0);
            make.height.equalTo(qrImage.mas_width);
        }];
        tempQRImg = qrImage.image;
        
        UIButton * shareBtn = [[UIButton alloc]init];
        shareBtn.backgroundColor = WHITECOLOR;
        [content addSubview:shareBtn];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qrImage.mas_bottom).with.offset(0);
            make.left.equalTo(content.mas_left).with.offset(10);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@30);
        }];

        UIButton * downloadBtn = [[UIButton alloc]init];
        downloadBtn.backgroundColor = WHITECOLOR;
        [content addSubview:downloadBtn];
        [downloadBtn setImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(downloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qrImage.mas_bottom).with.offset(0);
            make.right.equalTo(content.mas_right).with.offset(-10);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@30);
        }];

        
    }
    
    return self;
}

-(void)shareBtnAction{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:tempQRImg];
    

    shareObject.shareImage = tempQRImg;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[XFTool getCurrentVCWithCurrentView:self] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            [SVProgressHUD dismissWithDelay:1.2];
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                UMSocialLogInfo(@"response message is %@",resp.message);
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


-(void)downloadBtnAction{
    [self loadImageFinished:tempQRImg];
}

- (void)loadImageFinished:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"已成功将二维码保存至您的相册"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"二维码保存失败"];
        }
        [SVProgressHUD dismissWithDelay:0.85];
    }];
}


-(void)closeBtnAction{
    [self removeFromSuperview];
}

- (UIImage *)creatQRImage{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    NSString *string = [NSString stringWithFormat:@"http://wap.66zuche.net/car/index.php/share/shareregister?uid=%@",model.uid];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}



@end
