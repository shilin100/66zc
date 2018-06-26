//
//  XFHomeLeftView.m
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeLeftView.h"
#import "XFLeftViewItem.h"
#import "XFUserInfoModel.h"
#import "XFHomeLeftViewCell.h"
#import "XFDriveApplyVC.h"

@interface XFHomeLeftView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIImageView *bgImg;
@property (nonatomic, weak) UIButton *icon;
@property (nonatomic, weak) UILabel *nameLbl;
@property (nonatomic, weak) UIView *splitLine;
@property (nonatomic, weak) UIButton *logoutBtn;
@property (nonatomic, weak) UITableView *tableView;


@end

@implementation XFHomeLeftView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.contentMode = UIViewContentModeScaleAspectFill;
        bgImg.userInteractionEnabled = YES;
        bgImg.clipsToBounds = YES;
        bgImg.image = IMAGENAME(@"beijing");
        [self addSubview:bgImg];
        self.bgImg = bgImg;
        
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIButton *icon = [[UIButton alloc] init];
        icon.tag = leftViewSubTypeIcon;
        icon.contentMode = UIViewContentModeCenter;
        icon.clipsToBounds = YES;
//        [icon setBackgroundImage:IMAGENAME(@"morentouxiang") forState:UIControlStateNormal];
        [icon sd_setImageWithURL:[NSURL URLWithString:((XFLoginInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path]).img] forState:UIControlStateNormal placeholderImage:IMAGENAME(@"morentouxiang")];
        icon.layer.cornerRadius = 60*SCALE_WIDTH;
        icon.clipsToBounds = YES;
        [icon addTarget:self action:@selector(didClickSub:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        self.icon = icon;
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(50*SCALE_HEIGHT);
            make.height.width.mas_equalTo(@(120*SCALE_WIDTH));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        UILabel *nameLbl = [[UILabel alloc] init];
//        nameLbl.text = @"租车";
//        nameLbl.text = ((XFLoginInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path]).phone;
        
        nameLbl.textAlignment = NSTextAlignmentCenter;
        nameLbl.font = XFont(14);
        nameLbl.textColor = WHITECOLOR;
        [self addSubview:nameLbl];
        self.nameLbl = nameLbl;
        
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(1*SCALE_HEIGHT);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.width.height.mas_equalTo(@30);

        }];
      
        
        UIView *splitLine = [[UIView alloc] init];
        splitLine.backgroundColor = HEXCOLOR(@"8cd69e");
        [self addSubview:splitLine];
        self.splitLine = splitLine;
        
        [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(230*SCALE_HEIGHT);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(@1);
            make.right.equalTo(self.mas_right);
        }];
        
        
        UIButton *logoutBtn = [[UIButton alloc] init];
        logoutBtn.tag = leftViewSubTypeContact;
        logoutBtn.titleLabel.font = XFont(13);
        [logoutBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:MAINGREEN forState:UIControlStateNormal];
        [logoutBtn setImage:[UIImage imageNamed:@"connectus_icon"] forState:UIControlStateNormal];
        [logoutBtn setBackgroundColor:WHITECOLOR];
//        [logoutBtn setBackgroundColor:HEXCOLOR(@"ccf3e6")];
//        logoutBtn.layer.cornerRadius = 34*SCALE_HEIGHT;
//        logoutBtn.clipsToBounds = YES;
        [logoutBtn addTarget:self action:@selector(didClickSub:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:logoutBtn];
        self.logoutBtn = logoutBtn;
        
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);//.offset(-60*SCALE_HEIGHT);
            make.height.mas_equalTo(@(68*SCALE_HEIGHT));
//            make.width.mas_equalTo(@(220*SCALE_WIDTH));
            make.left.mas_equalTo(@0);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        
        //tableview
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.backgroundColor=[UIColor clearColor];
        tableView.separatorColor=[UIColor clearColor];
        [self addSubview:tableView];
        self.tableView = tableView;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.splitLine.mas_bottom).offset(40*SCALE_HEIGHT);
            make.bottom.equalTo(self.logoutBtn.mas_top).offset(-60*SCALE_HEIGHT);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        [self getUserInfo];
        
        
        
//        NSArray *icons = @[@"dingdan",@"qianbao",@"youhuiquan",@"fenxiao",@"xueche",@"weizhang",@"lianxiwomen",@"bangzhu",@"shezhi"];
//        NSArray *titles = @[@"我的订单",@"我的钱包",@"我的优惠券",@"我的分销",@"我要学车",@"我的违章",@"联系我们",@"帮助",@"设置"];
//        for (int i = 0; i < icons.count; i++) {
//            XFLeftViewItem *item = [[XFLeftViewItem alloc] initWithIcon:icons[i] andTitle:titles[i]];
//            [item addTarget:self action:@selector(didClickSub:) forControlEvents:UIControlEventTouchUpInside];
//             [self addSubview:item];
//            switch (i) {
//                case 0:
//                    item.tag = leftViewSubTypeOrder;
//                    break;
//                case 1:
//                    item.tag = leftViewSubTypeWallet;
//                    break;
//                case 2:
//                    item.tag = leftViewSubTypeTicket;
//                    break;
//                case 3:
//                    item.tag = leftViewSubTypeSales;
//                    break;
//                case 4:
//                    item.tag = leftViewSubTypeStudy;
//                    break;
//                case 5:
//                    item.tag = leftViewSubTypeBreakRules;
//                    break;
//                case 6:
//                    item.tag = leftViewSubTypeContact;
//                    break;
//                case 7:
//                    item.tag = leftViewSubTypeHelp;
//                    break;
//                case 8:
//                    item.tag = leftViewSubTypeSetting;
//                    break;
//
//                default:
//                    break;
//            }
//            [item mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.mas_left);
//                make.top.equalTo(self.splitLine.mas_bottom).offset(80*SCALE_HEIGHT*i + 35*SCALE_HEIGHT);
//                make.height.mas_equalTo(@(50*SCALE_HEIGHT));
//                make.right.equalTo(self.mas_right);
//            }];
//        }
        

        
    }
    return self;
}

#pragma mark ----- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12-3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cell_id=@"cell_id";
    XFHomeLeftViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if(!cell)
    {
        cell=[[XFHomeLeftViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    
//    ,@"lianxiwomen",@"bangzhu",@"youhuiquan"
    NSArray *icons = @[@"dingdan",@"qianbao",@"个人中心",@"消息",@"xueche",@"peilian1",@"songche1",@"weizhang",@"shezhi"];
//    @"联系我们",@"帮助",@"我的卡券"
    NSArray *titles = @[@"我的订单",@"我的钱包",@"个人中心",@"消息中心",@"我要学车",@"我要陪练",@"送车服务",@"我的违章",@"设置"];
   
    cell.icon.image = IMAGENAME(icons[indexPath.row]);
    cell.titleLbl.text = titles[indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*SCALE_WIDTH;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeLeftTableView:indexPath:)]) {
        [self.delegate homeLeftTableView:tableView indexPath:indexPath];
    }
    
}

- (void) didClickSub:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeLeftView:didSelectedItem:)]) {
        [self.delegate homeLeftView:self didSelectedItem:sender];
    }
}
- (void) getUserInfo {
    NSMutableDictionary *params = [XFTool baseParams];
    
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.token forKey:@"token"];
    [params setObject:model.uid forKey:@"uid"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/User/User",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            XFUserInfoModel *userModel = [XFUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.icon sd_setImageWithURL:[NSURL URLWithString:userModel.img] forState:UIControlStateNormal placeholderImage:IMAGENAME(@"morentouxiang")];
            if(userModel.username.length)
            {
                self.nameLbl.text = userModel.username;
            }
            
        }else{
            
        }
//        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}
@end
