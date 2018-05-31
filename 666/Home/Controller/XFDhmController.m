//
//  XFDhmController.m
//  666
//
//  Created by TDC_MacMini on 2018/2/11.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFDhmController.h"
#import "XFAlertViewThree.h"
#import "XFExchangePopView.h"

#define kDotCount 10  //密码个数
#define K_Field_Height 45  //每一个输入框的高度

@interface XFDhmController ()<UITextFieldDelegate>

@property(strong,nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *labelArray; //显示数字的label

@end

@implementation XFDhmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兑换码";
    self.view.backgroundColor = HEXCOLOR(@"#eeeeee");
    [self setupSubs];
}

-(void)setupSubs
{
    _titleLabel=[[UILabel alloc] init];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.text=@"请输入您的优惠券兑换码";
    _titleLabel.textColor=HEXCOLOR(@"#666666");
    _titleLabel.font=XFont(14);
    [self.view addSubview:_titleLabel];
    _titleLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 70)
    .widthIs(180)
    .heightIs(30);
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearsOnBeginEditing = YES;
    //输入的文字颜色为白色
    _textField.textColor = [UIColor whiteColor];
    //输入框光标的颜色为白色
    _textField.tintColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.keyboardType = UIKeyboardTypePhonePad;
    _textField.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    _textField.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(_titleLabel, 10)
    .heightIs(K_Field_Height);
    
    //每个密码输入框的宽度
    CGFloat width = (SCREENW-40)/kDotCount;
    
    //分割线
    for (int i = 0; i < kDotCount - 1; i++)
    {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [self.view addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(self.view, 20+(i+1)*width)
        .topSpaceToView(_titleLabel, 10)
        .widthIs(1)
        .heightIs(K_Field_Height);
    }
    
    self.labelArray = [[NSMutableArray alloc] init];
    //显示数字的label
    for (int i = 0; i < kDotCount; i++)
    {
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textAlignment=NSTextAlignmentCenter;
//        numLabel.font=XFont(14);
        [self.view addSubview:numLabel];
        numLabel.sd_layout
        .leftSpaceToView(self.view, 20 + i*width)
        .topSpaceToView(_titleLabel, 10)
        .widthIs(width)
        .heightIs(K_Field_Height);
        
        //把创建的label加入到数组中
        [self.labelArray addObject:numLabel];
    }
    
    UIButton *commitBtn = [[UIButton alloc] init];
    [commitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [commitBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    commitBtn.titleLabel.font = XFont(14);
    commitBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    commitBtn.clipsToBounds = YES;
    commitBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:commitBtn];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.sd_layout
    .topSpaceToView(_textField, 50)
    .leftSpaceToView(self.view, 50*SCALE_HEIGHT)
    .heightIs(80*SCALE_HEIGHT)
    .rightSpaceToView(self.view, 50*SCALE_HEIGHT);
    
    
    UILabel *dspLabel1=[[UILabel alloc] init];
    dspLabel1.numberOfLines=0;
//    dspLabel1.lineBreakMode=NSLineBreakByCharWrapping;
    dspLabel1.text=@"1.每天兑换错误超过六次将禁止兑换，停封兑换时间为一天。\n2.兑换成功后，相应奖励将发送到登录账户中。\n3.本功能最终解释权在法律允许的范围内归六六租车所有。";
    dspLabel1.textColor=HEXCOLOR(@"#666666");
    dspLabel1.font=XFont(13);
    [self.view addSubview:dspLabel1];
    dspLabel1.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(commitBtn, 15)
    .heightIs(80);
    
    UILabel *dspLabel2=[[UILabel alloc] init];
    dspLabel2.numberOfLines=0;
    dspLabel2.lineBreakMode=NSLineBreakByCharWrapping;
    dspLabel2.text=@"兑换及使用过程中如有任何疑问请加QQ群234881709咨询客服";
    dspLabel2.textColor=HEXCOLOR(@"#666666");
    dspLabel2.font=XFont(13);
    [self.view addSubview:dspLabel2];
    dspLabel2.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(dspLabel1, 0)
    .heightIs(50);
    
    UIImageView *imv=[[UIImageView alloc] init];
    imv.contentMode=UIViewContentModeCenter;
    imv.image=[UIImage imageNamed:@"lianxidianhua"];
    [self.view addSubview:imv];
    imv.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(dspLabel2, 0)
    .widthIs(30)
    .heightIs(30);
    
    UIButton *telBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    telBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [telBtn setTitle:@"客服电话：027-59762081" forState:UIControlStateNormal];
    telBtn.titleLabel.font=XFont(13);
    [telBtn setTitleColor:MAINGREEN forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(telBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telBtn];
    telBtn.sd_layout
    .leftSpaceToView(imv, 0)
    .topSpaceToView(dspLabel2, 0)
    .widthIs(200)
    .heightIs(30);
    
}

-(void)telBtnAction:(UIButton *)sender
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"027-59762081"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        //删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount)
    {
        [textField resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}


//显示数字
- (void)textFieldDidChange:(UITextField *)textField
{

    NSString *str=textField.text;
    if(![self isNumber:str])
    {
        textField.text=@"";
        return;
    }
    NSLog(@"%@", str);
    
    for (UILabel *num in self.labelArray)
    {
        num.text = @"";
    }
    
    for (int i = 0; i < str.length; i++)
    {
        UILabel *numLabel=(UILabel *)[self.labelArray objectAtIndex:i];
        numLabel.text=[str substringWithRange:NSMakeRange(i, 1)];
    }
    if (textField.text.length >= kDotCount)
    {
        [textField resignFirstResponder];
        NSLog(@"输入完毕");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//匹配数字
- (BOOL)isNumber:(NSString *)str {
    
    NSString *pattern = @"^[\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


-(void)commitBtnClick
{
    if(_textField.text.length==10)
    {
        NSLog(@"number===%@",_textField.text);
        [SVProgressHUD show];
        NSMutableDictionary *params = [XFTool baseParams];
        XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:_textField.text forKey:@"coupon_number"];

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/My/changeCoupon",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"responseObject***:%@",responseObject);
            if ([responseObject[@"status"] intValue] == 1) {
                ExchangeType type = ExchangeFail;
                if ([responseObject[@"data"][@"status"] intValue] == 0) {
                    type = ExchangeSuccess;
                }
                XFExchangePopView * alert = [[XFExchangePopView alloc]initWithTitle:responseObject[@"data"][@"title"] Msg:responseObject[@"data"][@"info"] ExchangType:type];
                alert.exchangeCheckBlock = ^{
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [alert show];
            }
            else
            {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:nil message:responseObject[@"info"] sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            NSLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:ServerError];
        }];
    }

    else
    {
        ExchangeType type = ExchangeFail;
        XFExchangePopView * alert = [[XFExchangePopView alloc]initWithTitle:@"提示" Msg:@"兑换码填写不完整" ExchangType:type];
        [alert show];

//        XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"兑换码填写不完整" sureBtn:@"确定" cancleBtn:nil];
//        [alert showAlertView];
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
