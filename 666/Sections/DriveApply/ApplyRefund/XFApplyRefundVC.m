//
//  XFApplyRefundVC.m
//  666
//
//  Created by 123 on 2018/5/10.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFApplyRefundVC.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
#import "XFSignCountView.h"


@interface XFApplyRefundVC ()

@property(nonatomic,strong)UITextView * reasonTextView;
@property (nonatomic, weak) UIScrollView *imageContent;
@property (nonatomic, weak) UIButton *plusBtn;
/**<#desc#>*/
@property (nonatomic, assign) CGFloat imgW;
@property(nonatomic,strong)NSArray<UIImage *> *photos;


@end

@implementation XFApplyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKGROUND;
    self.navigationItem.title = @"售后申请";
    self.imgW = (SCREENW - 20 - 40*SCALE_WIDTH) / 3;

    
    [self setupUI];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
-(void)setupUI{
    
    UILabel *reasonLabel = [[UILabel alloc] init];
    reasonLabel.font = XFont(17);
    reasonLabel.textColor = BlACKTEXT;
    reasonLabel.text = @"退款原因";
    [self.view addSubview:reasonLabel];
    reasonLabel.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);

    UITextView *reasonTextView = [[UITextView alloc] init];
    reasonTextView.backgroundColor = WHITECOLOR;
    reasonTextView.font = XFont(14);
    reasonTextView.textColor = BlACKTEXT;
    reasonTextView.zw_placeHolder = @"请输入退款原因";
    reasonTextView.zw_placeHolderColor = GRAYTEXT;
    reasonTextView.zw_limitCount = 200;
    reasonTextView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.reasonTextView = reasonTextView;
    
    [self.view addSubview:reasonTextView];
    reasonTextView.sd_layout
    .topSpaceToView(reasonLabel, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(120);

    NSString * totalStr = @"退款金额* 不可修改";
    NSString * str = @"*";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    //设置标签文字属性
    attributeString.color = BlACKTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:REDCOLOR, NSForegroundColorAttributeName, nil] range:rang];
    str = @"不可修改";
    rang = [totalStr rangeOfString:str];
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:GRAYTEXT, NSForegroundColorAttributeName,XFont(12), NSFontAttributeName, nil] range:rang];

    UILabel *refundLabel = [[UILabel alloc] init];
    refundLabel.font = XFont(17);
    refundLabel.attributedText = attributeString;
    [self.view addSubview:refundLabel];
    
    refundLabel.sd_layout
    .topSpaceToView(reasonTextView, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.backgroundColor = WHITECOLOR;
    moneyLabel.font = XFont(14);
    moneyLabel.textColor = BlACKTEXT;
    moneyLabel.text = [NSString stringWithFormat:@"   %@",self.model.cost];
    [self.view addSubview:moneyLabel];
    moneyLabel.sd_layout
    .topSpaceToView(refundLabel, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);
    
    UILabel *uploadLabel = [[UILabel alloc] init];
    uploadLabel.backgroundColor = WHITECOLOR;
    uploadLabel.font = XFont(14);
    uploadLabel.textColor = BlACKTEXT;
    uploadLabel.text = [NSString stringWithFormat:@"   %@",@"拍照上传"];
    [self.view addSubview:uploadLabel];
    uploadLabel.sd_layout
    .topSpaceToView(moneyLabel, 5)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);


    UIScrollView *imageContent = [[UIScrollView alloc] init];
    imageContent.backgroundColor = WHITECOLOR;
    [self.view addSubview:imageContent];
    self.imageContent = imageContent;
    imageContent.sd_layout
    .topSpaceToView(uploadLabel, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(130);
    
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
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count <= 0) {
            return;
        }else{
            for (UIView *view in self.imageContent.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UIImageView")]) {
                    [view removeAllSubviews];
                }
            }
            self.photos = [NSArray arrayWithArray:photos];
            int i = 100;
            for (UIImage *img in photos) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.tag = i;
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                imgV.clipsToBounds = YES;
                imgV.image = img;
                [self.imageContent addSubview:imgV];
                i++;
                
                int index = (int)[photos indexOfObject:img];
                int cross = index%3;
                int row = index/3;

                imgV.sd_layout
                .heightIs(self.imgW)
                .widthEqualToHeight()
                .topSpaceToView(self.imageContent, 6+(self.imgW+20*SCALE_HEIGHT)*row)
                .leftSpaceToView(self.imageContent, 10+(self.imgW+20*SCALE_WIDTH)*cross);
                
                
            }
        }
        int index = (int)photos.count;
        int cross = index%3;
        int row = index/3;

        self.plusBtn.sd_layout
        .topSpaceToView(self.imageContent, 6+(self.imgW+20*SCALE_HEIGHT)*row)
        .leftSpaceToView(self.imageContent, 10+(self.imgW+20*SCALE_WIDTH)*cross);
        self.imageContent.contentSize = CGSizeMake(0, 130+115*row);
        
        
        [self.imageContent setNeedsLayout];
        [self.view setNeedsLayout];
        
    }];
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void) loadBtnClick {
    if (self.reasonTextView.text.length <= 0) {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请填写退款原因" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;
    }

    [SVProgressHUD show];
        NSMutableDictionary *params = [XFTool getBaseRequestParams];
        [params setObject:self.model.de_id forKey:@"deid"];
        [params setObject:self.model.did forKey:@"did"];
        [params setObject:self.reasonTextView.text forKey:@"cause"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/StudyCar/refund",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int i = 0;
            for (UIImage *image in self.photos) {
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
