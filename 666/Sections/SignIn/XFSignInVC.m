//
//  XFSignInVC.m
//  666
//
//  Created by 123 on 2018/5/11.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSignInVC.h"
#import "XFSignInModel.h"
#import "XFSignCountView.h"
#import "XFUserInfoModel.h"
#import "VierticalScrollView.h"
#import "MDScratchImageView.h"
#import "XFPrizeListVC.h"
#import "XFMySaleTicketController.h"

@interface XFSignInVC ()<MDScratchImageViewDelegate>

@property(nonatomic,weak)UIImageView * icon;
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)UILabel * signInCountLabel;
@property(nonatomic,weak)UILabel * drawLabel;
@property(nonatomic,weak)UILabel * resultLabel;
@property(nonatomic,weak)UILabel * disableDrawLabel;
@property(nonatomic,weak)UILabel * pLabel;

@property(nonatomic,weak)UIView * marqueeView;
@property(nonatomic,weak)UIButton * drawAgainBtn;


@property(nonatomic,strong)XFSignInModel * model;
@property(nonatomic,weak)XFSignCountView * signCountView;
@property(nonatomic,weak)MDScratchImageView * scratchImageView;

@property(nonatomic,assign)BOOL isDraw;
@property(nonatomic,assign)int drawCounts;

@end

@implementation XFSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKGROUND;
    self.navigationItem.title = @"我的签到";
    self.isDraw = NO;
    
    [self setupUI];
    [self requestData];
    [self getUserInfo];
    [self getPrizeWinners];
}

-(void)setupUI{
    
    CGFloat height = 108;
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = WHITECOLOR;
    [self.view addSubview:topView];
    topView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(height);
    
    UIImageView * icon = [[UIImageView alloc]init];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:icon];
    icon.sd_layout
    .centerYEqualToView(topView)
    .leftSpaceToView(topView, 20)
    .heightIs(height - 30)
    .widthEqualToHeight();
    icon.layer.cornerRadius = (height - 30)/2;
    icon.clipsToBounds = YES;
    self.icon = icon;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = XFont(14);
    titleLabel.textColor = BlACKTEXT;
    [topView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    titleLabel.sd_layout
    .topSpaceToView(topView, 10)
    .leftSpaceToView(icon, 10)
    .rightSpaceToView(topView, 20)
    .heightIs(30);
    
    UILabel *signInCountLabel = [[UILabel alloc] init];
    signInCountLabel.font = XFont(12);
    signInCountLabel.textColor = BlACKTEXT;
    [topView addSubview:signInCountLabel];
    self.signInCountLabel=signInCountLabel;
    signInCountLabel.sd_layout
    .topSpaceToView(titleLabel, 0)
    .leftSpaceToView(icon, 10)
    .rightSpaceToView(topView, 20)
    .heightIs(20);
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = XFont(12);
    noticeLabel.textColor = GRAYCOLOR;
    noticeLabel.text = @"每累计签到3次，即可获得一次抽奖机会～!";
    [topView addSubview:noticeLabel];
    noticeLabel.sd_layout
    .bottomSpaceToView(topView, 0)
    .leftSpaceToView(icon, 10)
    .rightSpaceToView(topView, 20)
    .heightIs(20);
    
    XFSignCountView * signCountView = [[XFSignCountView alloc]init];
    [topView addSubview:signCountView];
    signCountView.sd_layout
    .topSpaceToView(signInCountLabel, 0)
    .leftSpaceToView(icon, 10)
    .rightSpaceToView(topView, 20)
    .bottomSpaceToView(noticeLabel, 0);
    self.signCountView = signCountView;
    
    UILabel *drawLabel = [[UILabel alloc] init];
    drawLabel.font = XFont(14);
    drawLabel.textAlignment = NSTextAlignmentCenter;
    drawLabel.backgroundColor = WHITECOLOR;
    [self.view addSubview:drawLabel];
    drawLabel.sd_layout
    .topSpaceToView(topView, 2)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(44);
    self.drawLabel = drawLabel;
    
    UIView * marqueeView = [UIView new];
    marqueeView.backgroundColor = WHITECOLOR;
    [self.view addSubview:marqueeView];
    marqueeView.sd_layout
    .topSpaceToView(drawLabel, 5)
    .leftSpaceToView(self.view, 50)
    .rightSpaceToView(self.view, 50)
    .heightIs(30);
    marqueeView.layer.cornerRadius = 15;
    marqueeView.clipsToBounds = YES;
    self.marqueeView = marqueeView;
    
    UIImageView * alarm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_trumpet"]];
    alarm.contentMode = UIViewContentModeScaleAspectFit;
    [marqueeView addSubview:alarm];
    alarm.sd_layout
    .centerYEqualToView(marqueeView)
    .leftSpaceToView(marqueeView, 10)
    .widthEqualToHeight()
    .heightIs(10);
    
    UIButton * prizeListBtn = [[UIButton alloc]init];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"奖品明细" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName:MAINGREEN}];
    [prizeListBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    prizeListBtn.titleLabel.font = XFont(14);
    [prizeListBtn addTarget:self action:@selector(prizeListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prizeListBtn];
    prizeListBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    prizeListBtn.sd_layout
    .topSpaceToView(marqueeView, 5)
    .widthIs(80)
    .rightSpaceToView(self.view, 25)
    .heightIs(30);
    
    UIImageView * drawBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_draw"]];
    drawBg.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:drawBg];
    
    drawBg.sd_layout
    .topSpaceToView(prizeListBtn, 5)
    .leftSpaceToView(self.view, 25)
    .rightSpaceToView(self.view, 25)
    .heightIs(100);

    UIImageView * drawGreenBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"draw_bg"]];
    drawGreenBg.contentMode = UIViewContentModeScaleToFill;
    [drawBg addSubview:drawGreenBg];
    
    drawGreenBg.sd_layout
    .topSpaceToView(drawBg, 10)
    .leftSpaceToView(drawBg, 10)
    .rightSpaceToView(drawBg, 10)
    .bottomSpaceToView(drawBg, 10);

    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.font = [UIFont boldSystemFontOfSize:14];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = HEXCOLOR(@"#b00e16");
    resultLabel.numberOfLines = 2;
    [drawBg addSubview:resultLabel];
    resultLabel.sd_layout
    .centerYEqualToView(drawBg)
    .leftSpaceToView(drawBg, 0)
    .rightSpaceToView(drawBg, 0)
    .heightIs(44);
    self.resultLabel = resultLabel;
//    resultLabel.text = @"恭喜你\r\n你抽到积分+1";
    
    MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:drawGreenBg.frame];
    UIImage *bluredImage = [UIImage imageNamed:@"start_draw"];
    scratchImageView.image = bluredImage;
    scratchImageView.delegate = self;
    [drawBg addSubview:scratchImageView];
    self.scratchImageView = scratchImageView;
    scratchImageView.userInteractionEnabled = NO;
    scratchImageView.sd_layout
    .topSpaceToView(drawBg, 10)
    .leftSpaceToView(drawBg, 10)
    .rightSpaceToView(drawBg, 10)
    .bottomSpaceToView(drawBg, 10);
    drawBg.userInteractionEnabled = YES;
    
//    UILabel *disableDrawLabel = [[UILabel alloc] init];
//    disableDrawLabel.font = [UIFont boldSystemFontOfSize:14];
//    disableDrawLabel.textAlignment = NSTextAlignmentCenter;
//    disableDrawLabel.textColor = HEXCOLOR(@"#034f12");
//    disableDrawLabel.numberOfLines = 2;
//    [drawBg addSubview:disableDrawLabel];
//    disableDrawLabel.sd_layout
//    .centerYEqualToView(drawBg)
//    .leftSpaceToView(drawBg, 0)
//    .rightSpaceToView(drawBg, 0)
//    .heightIs(44);
//    self.disableDrawLabel = disableDrawLabel;
//    disableDrawLabel.text = @"很遗憾\r\n您的签到次数不够";

    
    UIButton * myCardBagBtn = [[UIButton alloc]init];
    [myCardBagBtn setTitle:@"我的卡包" forState:UIControlStateNormal];
    [myCardBagBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    myCardBagBtn.layer.cornerRadius = 5;
    myCardBagBtn.clipsToBounds = YES;
    myCardBagBtn.titleLabel.font = XFont(14);
    myCardBagBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:myCardBagBtn];
    [myCardBagBtn addTarget:self action:@selector(myCardBagBtnAction) forControlEvents:UIControlEventTouchUpInside];
    myCardBagBtn.sd_layout
    .topSpaceToView(drawBg, 20)
    .leftEqualToView(drawBg)
    .heightIs(30)
    .widthIs(80);

    
    UIButton * drawAgainBtn = [[UIButton alloc]init];
    [drawAgainBtn setTitle:@"再刮一次" forState:UIControlStateNormal];
    [drawAgainBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    drawAgainBtn.layer.cornerRadius = 5;
    drawAgainBtn.clipsToBounds = YES;
    drawAgainBtn.titleLabel.font = XFont(14);
    drawAgainBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:drawAgainBtn];
    [drawAgainBtn addTarget:self action:@selector(drawAgainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    drawAgainBtn.sd_layout
    .topSpaceToView(drawBg, 20)
    .rightEqualToView(drawBg)
    .heightIs(30)
    .widthIs(80);
    drawAgainBtn.alpha = 0;
    self.drawAgainBtn = drawAgainBtn;

    UILabel *ruleLabel = [[UILabel alloc] init];
    ruleLabel.font = XFont(14);
    ruleLabel.text = @"规则说明:";
    ruleLabel.textAlignment = NSTextAlignmentLeft;
    ruleLabel.textColor = BlACKTEXT;
    [self.view addSubview:ruleLabel];
    ruleLabel.sd_layout
    .topSpaceToView(myCardBagBtn, 10)
    .rightEqualToView(drawBg)
    .heightIs(30)
    .leftEqualToView(drawBg);

    UILabel *ruleDetailLabel = [[UILabel alloc] init];
    ruleDetailLabel.font = XFont(12);
    ruleDetailLabel.numberOfLines = 0;
    ruleDetailLabel.text = @"1、用户每次签到可获取1积分，累计3次可获取1次抽奖机会。中奖几率为为100%。\n2、用户在抽奖期间获取的奖品自激活日起生效。\n3、用户可在自己的卡包查看获取的优惠卡等信息。\n4、本活动与苹果公司无关。";
    ruleDetailLabel.textAlignment = NSTextAlignmentLeft;
    ruleDetailLabel.textColor = BlACKTEXT;
    [self.view addSubview:ruleDetailLabel];
    ruleDetailLabel.sd_layout
    .topSpaceToView(ruleLabel, 0)
    .rightEqualToView(drawBg)
    .heightIs(90)
    .leftEqualToView(drawBg);

    
}

-(void)drawAgainBtnAction{
//    [self requestToDraw];
    
    self.isDraw = NO;
    UIImage *bluredImage = [UIImage imageNamed:@"draw_cover"];
    self.scratchImageView.image = bluredImage;
    self.scratchImageView.alpha = 1;
    self.scratchImageView.userInteractionEnabled = YES;
    
    self.drawAgainBtn.userInteractionEnabled = NO;
    self.drawAgainBtn.backgroundColor = GRAYCOLOR;
    self.resultLabel.text = @"";
    
}

-(void)myCardBagBtnAction{
    
    XFMySaleTicketController * vc = [XFMySaleTicketController new];
    vc.selectedIndex = 2;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void )prizeListBtnAction{
    XFPrizeListVC * vc = [XFPrizeListVC new]; 
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark NetRequests

- (void) requestToDraw {
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/makeScrap",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            self.resultLabel.text = responseObject[@"info"];
            [self setDrawLabelTitleCount:[NSString stringWithFormat:@"%@",responseObject[@"scrapnumber"]]];
            NSString * temp = responseObject[@"scrapnumber"];
            self.drawCounts = (int)temp.integerValue;

        }else{
            
        }
        //        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

- (void) getPrizeWinners {
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/loopPrizes",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            NSArray * data = responseObject[@"data"];
            VierticalScrollView *scroView = [VierticalScrollView initWithTitleArray:data AndFrame:CGRectMake(30, 0, self.marqueeView.bounds.size.width - 40, self.marqueeView.bounds.size.height)];
            [self.marqueeView addSubview:scroView];
            
            
        }else{
            
        }
        //        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}


- (void) getUserInfo {
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/User/User",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            XFUserInfoModel *userModel = [XFUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.icon sd_setImageWithURL:[NSURL URLWithString:userModel.img] placeholderImage:IMAGENAME(@"morentouxiang")];
            self.titleLabel.text = userModel.username != nil ? userModel.username : @"";
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:0.85];
        }
        //        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:ServerError];
        [SVProgressHUD dismissWithDelay:0.85];
        
    }];
}


- (void) requestData {
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/singIn_list",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            self.model = [XFSignInModel mj_objectWithKeyValues:responseObject[@"data"]];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

-(void)setModel:(XFSignInModel *)model{
    _model = model;
    NSString * totalStr = [NSString stringWithFormat:@"已累计签到%@次",model.signtimes];
    NSString * str = model.signtimes;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    attributeString.color = BlACKTEXT;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:YELLOWCOLOR, NSForegroundColorAttributeName, nil] range:rang];
    self.signInCountLabel.attributedText = attributeString;
    self.signCountView.signtimes = (int)model.signtimes.integerValue;
    if (model.scrapnumber != 0) {
//        self.disableDrawLabel.text = @"刮开涂层百分百赢大奖";
        self.scratchImageView.image = [UIImage imageNamed:@"start_draw"];
        self.scratchImageView.userInteractionEnabled = YES;
    }else{
        self.scratchImageView.image = [UIImage imageNamed:@"disable_draw"];
        self.scratchImageView.userInteractionEnabled = NO;
    }
    
    
    [self setDrawLabelTitleCount:[NSString stringWithFormat:@"%d",(int)model.scrapnumber]];
}

-(void)setDrawLabelTitleCount:(NSString *)count{
    NSString * totalStr = [NSString stringWithFormat:@"您还可以抽奖%@次",count];
    NSString * str = count;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange rang = [totalStr rangeOfString:str];
    
    attributeString.color = MAINGREEN;
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:YELLOWCOLOR, NSForegroundColorAttributeName,XBFont(22),NSFontAttributeName, nil] range:rang];
    
    self.drawLabel.attributedText = attributeString;
    
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
//    [self.disableDrawLabel removeFromSuperview];
    if (!self.isDraw) {
        [self requestToDraw];
        self.isDraw = YES;
    }
    if (maskingProgress > 0.3) {
        [UIView animateWithDuration:2.0 animations:^{
            scratchImageView.alpha = 0;
        }];
        scratchImageView.userInteractionEnabled = NO;
        self.drawAgainBtn.alpha = 1;
        
        if (self.drawCounts > 0) {
            self.drawAgainBtn.userInteractionEnabled = YES;
            self.drawAgainBtn.backgroundColor = MAINGREEN;

        } else {
            self.drawAgainBtn.userInteractionEnabled = NO;
            self.drawAgainBtn.backgroundColor = GRAYCOLOR;
        }


    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
