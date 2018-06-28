//
//  XFMineInfoController.m
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

/*****审核状态和已审核状态 不允许编辑个人资料****/

#import "XFMineInfoController.h"
#import "XFUserInfoModel.h"
#import "XFUserInfoScroolView.h"
#import "HZAreaPickerView.h"
#import "CDZPicker.h"
#import "XFRecommendIconViewController.h"

@interface XFMineInfoController () <XFUserInfoScroolViewDelegate,HZAreaPickerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**用户*/
@property (nonatomic, strong) XFUserInfoModel *userModel;
/**<#desc#>*/
@property (nonatomic, strong) XFUserInfoScroolView *userView;
/**<#desc#>*/
@property (nonatomic, weak) XFUserInfoScroolView *contenView;
/**<#desc#>*/
@property (nonatomic, strong) HZAreaPickerView *areaPicker;
/**itemEnable*/
@property (nonatomic, assign) BOOL itemEnable;
@end

@implementation XFMineInfoController

//- (XFUserInfoScroolView *)userView{
//    if (!_userView) {
//        _userView = [[XFUserInfoScroolView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH-64)];
//        [self.view addSubview:_userView];
//    }
//    return _userView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    self.view.backgroundColor = WHITECOLOR;
    
    XFUserInfoScroolView *contentView = [[XFUserInfoScroolView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
//    contentView.enableEdit = ((XFLoginInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path]).user_state == 0 ? YES:NO;
    
    contentView.delegate = self;
    [self.view addSubview:contentView];
    self.contenView = contentView;
    
    // 导航栏
//    NSString *itemTitle;
//    switch (((XFLoginInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path]).user_state) {
//        case 0:
//            itemTitle = @"未提交审核";
//            self.itemEnable = YES;
//            break;
//        case 1:
//            itemTitle = @"待审核";
//            self.itemEnable = NO;
//            break;
//        case 2:
//            itemTitle = @"审核通过";
//            self.itemEnable = NO;
//            break;
//        default:
//            break;
//    }
//     UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStyleDone target:self action:@selector(EditBtnClick)];
//    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITECOLOR,NSFontAttributeName:XFont(13)} forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //获取个人信息的状态  0：未提交信息1：待审核  2：审核通过
    [self getUserInfoState];
  
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**rightItem点击*/
- (void) EditBtnClick {
    if (self.itemEnable) { // 提交审核
        
    }else{ // 审核中或审核已通过
//        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:nil message:@"审核中或审核通过的用户信息不能修改" sureBtn:@"确定" cancleBtn:nil];
//        [alert showAlertView];
    }
    
}
/**提交审核*/
- (void) submitToAudit {
    NSString *name = self.contenView.nameTF.text;
//    NSString *sex = self.contenView.sexLbl.text;
//    NSString *area = self.contenView.areaLbl.text;
//    NSString *address = self.contenView.addressTF.text;
//    NSString *friend = self.contenView.friendLbl.text;
    NSString *friendNum = self.contenView.friendNumTF.text;
    NSString *payNumber = self.contenView.alipayTF.text;
    UIImage *carCardImage = self.contenView.carCardImg.image;
    UIImage *cardOne = self.contenView.cardFrontImg.image;
    UIImage *cardTwo = self.contenView.cardBackImg.image;
    UIImage *icon = self.contenView.iconBtn.currentBackgroundImage;
    NSString *carCardNum = self.contenView.carCardTF.text;
    NSString *cardNum = self.contenView.cardTF.text;
    
    if (icon == nil) {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请上传头像" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;
    }
    if (carCardNum.length != 12) {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请正确输入12位驾驶证档案编号" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;

    }
    
    if(carCardImage == nil || cardOne == nil || cardTwo == nil)
    {
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"驾驶证或身份证照片不能为空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;
    }

    //        && sex.length && area.length && address.length && friend.length 删去

    if (name.length && friendNum.length && carCardNum.length && cardNum.length && payNumber.length) {
        
        //            if (![XFTool validateMobile:friendNum])
        //            {
        //                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"手机号不正确" sureBtn:@"确定" cancleBtn:nil];
        //                [alert showAlertView];
        //                return;
        //            }
        
        [SVProgressHUD show];
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:name forKey:@"name"];
        //            [params setObject:sex forKey:@"sex"];
        //            [params setObject:area forKey:@"area"];
        //            [params setObject:address forKey:@"address"];
        //            [params setObject:friend forKey:@"friend"];
        [params setObject:friendNum forKey:@"friend_phone"];
#pragma mark - 接口需要添加 驾驶证号 和 身份证号 接收字段
        [params setObject:cardNum forKey:@"card_number"];
        [params setObject:carCardNum forKey:@"driver_number"];
        [params setObject:payNumber forKey:@"paynumber"];
        // 头像 驾照 身份证1 身份证2
        NSArray *images = @[icon,carCardImage,cardOne,cardTwo];
        NSMutableArray *imageDataArr = [NSMutableArray array];
        for (UIImage *image in images) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [imageDataArr addObject:imageData];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/User/user_submit",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *name = [NSString string];
            for (int i = 0; i < imageDataArr.count; i++) {
                name=[NSString stringWithFormat:@"%d",i];
                NSString *filename = [NSString stringWithFormat:@"%@.png",name];
                [formData appendPartWithFileData:[imageDataArr objectAtIndex:i]
                                            name:[NSString stringWithFormat:@"image%@", @(i)]
                                        fileName:filename
                                        mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            /*
             {
             islogin = 0,
             status = 1,
             info =
             }
             */
            NSLog(@"succ:%@",responseObject);
            if ([responseObject[@"status"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [SVProgressHUD dismissWithDelay:1.2];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:ServerError];
        }];
        
    }else{
        [SVProgressHUD dismiss];
        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"信息不能留空" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
    }

}



/**获取个人信息的状态*/
-(void)getUserInfoState
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] withDic:nil Succeed:^(NSDictionary *responseObject) {
        [hud hideAnimated:YES afterDelay:0.2];
        
        if ([responseObject[@"status"] intValue] == 1)
        {
            if([responseObject[@"user_state"] intValue] == 0)
            {
                // 0：未提交信息1：待审核  2：审核通过
                //未提交可以编辑信息
                self.isSubmit=YES;
            }
            else
            {
                if ([responseObject[@"user_state"] intValue] == 1) {
                    [SVProgressHUD showErrorWithStatus:@"您的信息还在审核中,请等待审核后再查看"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        return ;
                    });
                }
                
                if ([responseObject[@"user_state"] intValue] == 3) {
                    self.isSubmit=YES;
                }else{
                    self.isSubmit=NO;
                }
                //获取用户信息
                [self getUserInfo];
                
            }
            
            self.contenView.enableEdit = self.isSubmit;
        }
        else{
            
        }

    } andFaild:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:0.2];
        NSLog(@"error:%@",error);

    }];
    
//    NSMutableDictionary *params = [XFTool baseParams];
//    XFLoginInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
//    [params setObject:user.uid forKey:@"uid"];
//    [params setObject:user.token forKey:@"token"];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        NSLog(@">>%@",responseObject);
//        [hud hideAnimated:YES afterDelay:0.2];
//
//        if ([responseObject[@"status"] intValue] == 1)
//        {
//            if([responseObject[@"user_state"] intValue] == 0)
//            {
//                // 0：未提交信息1：待审核  2：审核通过
//                //未提交可以编辑信息
//                self.isSubmit=YES;
//            }
//            else
//            {
//                if ([responseObject[@"user_state"] intValue] == 1) {
//                    [SVProgressHUD showErrorWithStatus:@"您的信息还在审核中,请等待审核后再查看"];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self.navigationController popViewControllerAnimated:YES];
//                        return ;
//                    });
//                }
//
//                if ([responseObject[@"user_state"] intValue] == 3) {
//                    self.isSubmit=YES;
//                }else{
//                    self.isSubmit=NO;
//                }
//                //获取用户信息
//                [self getUserInfo];
//
//            }
//
//            self.contenView.enableEdit = self.isSubmit;
//        }
//        else{
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES afterDelay:0.2];
//        NSLog(@"error:%@",error);
//    }];
}

/**获取用户信息*/
- (void) getUserInfo {
    
    [XFTool PostRequestWithUrlString:[NSString stringWithFormat:@"%@/User/User",BASE_URL] withDic:nil Succeed:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] intValue] == 1) {
            
            self.userModel = [XFUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.contenView.userModel = self.userModel;
        }else{
            
        }
        
    } andFaild:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];

    
//    NSMutableDictionary *params = [XFTool baseParams];
//
//    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
//    [params setObject:model.token forKey:@"token"];
//    [params setObject:model.uid forKey:@"uid"];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [manager POST:[NSString stringWithFormat:@"%@/User/User",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
//        /*
//         {
//         address = "";
//         area = "";
//         "car_card" = "";
//         card = "";
//         friend = "";
//         "friend_phone" = "";
//         id = 202;
//         img = "";
//         info = "";
//         islogin = 0;
//         paynumber = "";
//         phone = 13566665555;
//         sex = "\U5973";
//         status = 1;
//         username = Lee;
//         }
//         */
//        NSLog(@"responseObject===%@",responseObject);
//        if ([responseObject[@"status"] intValue] == 1) {
//
//            self.userModel = [XFUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
//            self.contenView.userModel = self.userModel;
//
//
//        }else{
//
//        }
//
//        NSLog(@"succ:%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
//    }];
}
#pragma mark - XFUserInfoScroolViewDelegate
/**头像点击*/
-(void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickIconBtn:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [contentView.iconBtn setBackgroundImage:photos[0] forState:UIControlStateNormal];
            
            //单独修改头像时才调用接口
            if(!self.isSubmit)
            {
                // 修改头像
                [self uploadIcon:UIImageJPEGRepresentation(photos[0], 0.3)];
            }
            
        }];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *recommend = [UIAlertAction actionWithTitle:@"选择推荐头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XFRecommendIconViewController * vc = [XFRecommendIconViewController new];
        vc.recommendIconBlock = ^(UIImage *img) {
            [contentView.iconBtn setBackgroundImage:img forState:UIControlStateNormal];
            
            //单独修改头像时才调用接口
            if(!self.isSubmit)
            {
                // 修改头像
                [self uploadIcon:UIImageJPEGRepresentation(img, 0.3)];
            }

        };
//        [contentView.iconBtn setBackgroundImage:photos[0] forState:UIControlStateNormal];

        [self.navigationController pushViewController:vc animated:YES];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:recommend];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void) uploadIcon:(NSData *)iconData {
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/User/headimg",BASE_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"1.png" fileName:@"11.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /*
         {
         img = "http://127.0.0.1:8081/Public/Upload/pic/pic/2017-10-25/59efe6e0c97e5.png";
         info = "";
         islogin = 0;
         status = 1;
         }
         */
        NSLog(@"succ:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SVProgressHUD dismissWithDelay:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}
/**保存*/
-(void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickSaveBtn:(UIButton *)button{
    [self submitToAudit];
    if (self.itemEnable) { // 保存信息
        /*
        [SVProgressHUD show];
        NSString *name = contentView.nameTF.text;
        NSString *sex = contentView.sexLbl.text;
        NSString *area = contentView.areaLbl.text;
        NSString *address = contentView.addressTF.text;
        NSString *friend = contentView.friendLbl.text;
        NSString *friendNum = contentView.friendNumTF.text;
        
        if (name.length && sex.length && area.length && address.length && friend.length && friendNum.length) {
            NSMutableDictionary *params = [XFTool baseParams];
            XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
            [params setObject:model.uid forKey:@"uid"];
            [params setObject:model.token forKey:@"token"];
            [params setObject:name forKey:@"username"];
            [params setObject:sex forKey:@"sex"];
            [params setObject:area forKey:@"area"];
            [params setObject:address forKey:@"address"];
            [params setObject:friend forKey:@"friend"];
            [params setObject:friendNum forKey:@"friend_phone"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:[NSString stringWithFormat:@"%@/User/member",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                NSLog(@"succ:%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                NSLog(@"error:%@",error);
            }];
            
            [self submitToAudit];
         
        }else{
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"所有信息都不能留空" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        */
    }else{ // 不可编辑
//        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:nil message:@"审核中或审核通过的用户信息不能修改" sureBtn:@"确定" cancleBtn:nil];
//        [alert showAlertView];
#warning 下面的代码应该移到 上面的 ‘保存信息’中
        /*
        [SVProgressHUD show];
        NSString *name = contentView.nameTF.text;
        NSString *sex = contentView.sexLbl.text;
        NSString *area = contentView.areaLbl.text;
        NSString *address = contentView.addressTF.text;
        NSString *friend = contentView.friendLbl.text;
        NSString *friendNum = contentView.friendNumTF.text;
        
        if (name.length && sex.length && area.length && address.length && friend.length && friendNum.length) {
            NSMutableDictionary *params = [XFTool baseParams];
            XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
            [params setObject:model.uid forKey:@"uid"];
            [params setObject:model.token forKey:@"token"];
            [params setObject:name forKey:@"username"];
            [params setObject:sex forKey:@"sex"];
            [params setObject:area forKey:@"area"];
            [params setObject:address forKey:@"address"];
            [params setObject:friend forKey:@"friend"];
            [params setObject:friendNum forKey:@"friend_phone"];

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:[NSString stringWithFormat:@"%@/User/member",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SVProgressHUD dismiss];
                NSLog(@"succ:%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                NSLog(@"error:%@",error);
            }];
            
        }else{
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"所有信息都不能留空" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
         */
    }
}
/**区域选择*/
-(void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickAreaBtn:(UIButton *)button{
    if (!_areaPicker) {
        _areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        _areaPicker.pickerDidChangeStatus = ^(HZAreaPickerView *picker) {
            
            if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                contentView.areaLbl.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state, picker.locate.city, picker.locate.district];
            } else{
                
            }
        };
    }
    NSLog(@"view.frame===%@",NSStringFromCGRect(self.view.frame));
    NSLog(@"view.frame===%@",NSStringFromCGRect(self.view.bounds));
    [_areaPicker showInView:self.view];
}
/**亲友关系选择*/
-(void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickFriendBtn:(UIButton *)button{
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.pickerColor = HEXCOLOR(@"eeeeee");
    builder.pickerTextColor = MAINGREEN;
    builder.showMask = YES;
//    builder.cancelTextColor = UIColor.clearColor;
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:@[@"父母",@"夫妻",@"子女",@"亲友"] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        contentView.friendLbl.text = strings[0];
    }cancel:^{
        //your code
    }];
    
}
/**添加驾照图片*/
-(void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickCarCardBtn:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            [contentView.iconBtn setImage:photos[0] forState:UIControlStateNormal];
            
//            for (UIView *sub in contentView.carCardContent.subviews) {
//                if ([sub isKindOfClass:NSClassFromString(@"UIImageView")]) {
//                    [sub removeFromSuperview];
//                }
//            }
//            UIImageView *imgV = [[UIImageView alloc] init];
//            imgV.clipsToBounds = YES;
//            imgV.image = photos[0];
//            imgV.contentMode = UIViewContentModeScaleAspectFill;
//            [contentView.carCardContent addSubview:imgV];
//
//            imgV.sd_layout
//            .topSpaceToView(contentView.carCardTitle, 0)
//            .leftSpaceToView(contentView.carCardContent, 20*SCALE_WIDTH)
//            .heightIs(210*SCALE_HEIGHT)
//            .widthIs(290*SCALE_HEIGHT);
//
//            [contentView.carCardContent setupAutoHeightWithBottomViewsArray:contentView.carCardContent.subviews bottomMargin:20*SCALE_HEIGHT];
            contentView.carCardImg.image = photos[0];
            contentView.carCardImg.sd_layout
            .heightIs(210*SCALE_HEIGHT);
        }];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**添加身份证图片，必须一次选中2张*/
- (void)XFUserInfoScroolView:(XFUserInfoScroolView *)contentView didClickCardBtn:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请一次性选中两张图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:nil];
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos.count != 2) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"请一次选择2张照片";
                [hud hideAnimated:YES afterDelay:1.6];
                return;
            }
            else
            {
                contentView.cardFrontImg.image = photos[0];
                contentView.cardFrontImg.sd_layout
                .heightIs(210*SCALE_HEIGHT);
                
                contentView.cardBackImg.image = photos[1];
                contentView.cardBackImg.sd_layout
                .heightIs(210*SCALE_HEIGHT);
            }
 
        }];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
