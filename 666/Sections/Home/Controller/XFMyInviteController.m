//
//  XFMyInviteController.m
//  666
//
//  Created by xiaofan on 2017/10/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyInviteController.h"
#import <UShareUI/UShareUI.h>
#import "XFMyInviteListModel.h"

@interface XFMyInviteController ()
@property (weak, nonatomic) IBOutlet UIImageView *BGImage;
@property (weak, nonatomic) IBOutlet UILabel *inviteLbl;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSMutableArray<XFMyInviteListModel *> *inviteList;

@end

@implementation XFMyInviteController

-(NSMutableArray<XFMyInviteListModel *> *)inviteList{
    if (!_inviteList) {
        _inviteList = [NSMutableArray array];
    }
    return _inviteList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐有礼";
    CGFloat topCons;
    if (SCREENW == 320) {
        topCons = 101;
    }else if (SCREENW == 375) {
        topCons = 122;
    }else{
        topCons = 136;
    }
    [self.inviteLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGImage.mas_top).offset(topCons);
        make.left.equalTo(self.BGImage.mas_left);
        make.right.equalTo(self.BGImage.mas_right);
        make.height.mas_equalTo(50*SCALE_HEIGHT);
    }];
    self.inviteLbl.text = [NSString stringWithFormat:@"邀请码:%@",((XFLoginInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path]).number];
    
    self.inviteBtn.layer.cornerRadius = self.inviteBtn.height * 0.5;
    self.inviteBtn.clipsToBounds = YES;
    
    [self getData];
}

-(void)getData
{
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    NSLog(@"params===%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/giveRequest",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [self.inviteList addObjectsFromArray:[XFMyInviteListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
           
            self.moneyLabel.text=self.inviteList[0].money;
            self.typeLabel.text=[NSString stringWithFormat:@"%@(%ld张)",self.inviteList[0].type,self.inviteList.count];
            self.ruleLabel.text=self.inviteList[0].rule;
            if([self.inviteList[0].day isEqualToString:@"永久"])
            {
                self.timeLabel.text = @"有效时间:永久";
            }
            else
            {
                NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:[self.inviteList[0].starttime integerValue]];
                NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:[self.inviteList[0].end_time integerValue]];
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *startStr=[formatter stringFromDate:startDate];
                NSString *endStr=[formatter stringFromDate:endDate];
                NSString *s1=[startStr stringByAppendingString:@"至"];
                NSString *s2=[s1 stringByAppendingString:endStr];
                NSLog(@"s2===%@",s2);
                self.timeLabel.text = [NSString stringWithFormat:@"有效时间:%@",s2];
            }
     
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
}


- (IBAction)inviteBtnClick {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    NSString* thumbURL =  @"http://www.baidu.com";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用六六租车" descr:@"推荐有礼" thumImage:IMAGENAME(@"AppIcon")];
    
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    NSString *url=[SHARE_BASE_URL stringByAppendingString:@"/index.php/share/shareregister/uid/"];
    NSString *shareUrl=[url stringByAppendingString:model.uid];
    NSLog(@"shareUrl===%@",shareUrl);
    shareObject.webpageUrl = shareUrl;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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

@end
