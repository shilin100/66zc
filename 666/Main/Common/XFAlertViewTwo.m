//
//  XFAlertViewTwo.m
//  666
//
//  Created by TDC_MacMini on 2017/12/16.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFAlertViewTwo.h"

///alertView  宽
#define AlertW 280
///各个栏目之间的距离
#define XFSpace 10.0

@interface XFAlertViewTwo()

//弹窗
@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label4;
@property (nonatomic,strong) UILabel *label5;
@property (nonatomic,strong) UIImageView *imv1;
@property (nonatomic,strong) UIImageView *imv2;
@property (nonatomic,strong) UIImageView *imv3;
@property (nonatomic,strong) UIImageView *imv4;
@property (nonatomic,strong) UIImageView *imv5;

//内容
@property (nonatomic,retain) UILabel *msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;

@end


@implementation XFAlertViewTwo

- (instancetype)initWithCount:(NSString *)count message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        self.alertView.clipsToBounds = YES;
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        
        if ([count isEqualToString:@"4"]) {
            
            self.label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 2*XFSpace, AlertW/4, 20)];
            self.label1.text=@"前";
            self.label1.font=XFont(14);
            self.label1.textColor=HEXCOLOR(@"999999");
            self.label1.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label1];
            
            self.label2=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/4, 2*XFSpace, AlertW/4, 20)];
            self.label2.text=@"后";
            self.label2.font=XFont(14);
            self.label2.textColor=HEXCOLOR(@"999999");
            self.label2.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label2];
            
            self.label3=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/4*2, 2*XFSpace, AlertW/4, 20)];
            self.label3.text=@"左";
            self.label3.font=XFont(14);
            self.label3.textColor=HEXCOLOR(@"999999");
            self.label3.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label3];
            
            self.label4=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/4*3, 2*XFSpace, AlertW/4, 20)];
            self.label4.text=@"右";
            self.label4.font=XFont(14);
            self.label4.textColor=HEXCOLOR(@"999999");
            self.label4.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label4];
            
            self.imv1=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label1.frame), AlertW/4, 40)];
            self.imv1.image=IMAGENAME(@"qian");
            self.imv1.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv1];
            
            self.imv2=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/4, CGRectGetMaxY(self.label1.frame), AlertW/4, 40)];
            self.imv2.image=IMAGENAME(@"hou");
            self.imv2.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv2];
            
            self.imv3=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/4*2, CGRectGetMaxY(self.label1.frame), AlertW/4, 40)];
            self.imv3.image=IMAGENAME(@"zuo");
            self.imv3.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv3];
            
            self.imv4=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/4*3, CGRectGetMaxY(self.label1.frame), AlertW/4, 40)];
            self.imv4.image=IMAGENAME(@"you");
            self.imv4.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv4];
            
            
            self.msgLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imv1.frame)+2*XFSpace, AlertW-20, 40)];
            self.msgLbl.numberOfLines=2;
            self.msgLbl.font=XFont(14);
            self.msgLbl.textColor=HEXCOLOR(@"999999");
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.msgLbl];
            
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:message];
            [str setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(10, 7)];
            self.msgLbl.attributedText = str;
            
        }
        
        else
        {
            
            self.label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 2*XFSpace, AlertW/5, 20)];
            self.label1.text=@"前";
            self.label1.font=XFont(14);
            self.label1.textColor=HEXCOLOR(@"999999");
            self.label1.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label1];
            
            self.label2=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/5, 2*XFSpace, AlertW/5, 20)];
            self.label2.text=@"后";
            self.label2.font=XFont(14);
            self.label2.textColor=HEXCOLOR(@"999999");
            self.label2.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label2];
            
            self.label3=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/5*2, 2*XFSpace, AlertW/5, 20)];
            self.label3.text=@"左";
            self.label3.font=XFont(14);
            self.label3.textColor=HEXCOLOR(@"999999");
            self.label3.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label3];
            
            self.label4=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/5*3, 2*XFSpace, AlertW/5, 20)];
            self.label4.text=@"右";
            self.label4.font=XFont(14);
            self.label4.textColor=HEXCOLOR(@"999999");
            self.label4.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label4];
            
            self.label5=[[UILabel alloc] initWithFrame:CGRectMake(AlertW/5*4, 2*XFSpace, AlertW/5, 20)];
            self.label5.text=@"内";
            self.label5.font=XFont(14);
            self.label5.textColor=HEXCOLOR(@"999999");
            self.label5.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.label5];
            
            
            
            self.imv1=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label1.frame), AlertW/5, 40)];
            self.imv1.image=IMAGENAME(@"qian");
            self.imv1.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv1];
            
            self.imv2=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/5, CGRectGetMaxY(self.label1.frame), AlertW/5, 40)];
            self.imv2.image=IMAGENAME(@"hou");
            self.imv2.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv2];
            
            self.imv3=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/5*2, CGRectGetMaxY(self.label1.frame), AlertW/5, 40)];
            self.imv3.image=IMAGENAME(@"zuo");
            self.imv3.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv3];
            
            self.imv4=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/5*3, CGRectGetMaxY(self.label1.frame), AlertW/5, 40)];
            self.imv4.image=IMAGENAME(@"you");
            self.imv4.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv4];
            
            self.imv5=[[UIImageView alloc] initWithFrame:CGRectMake(AlertW/5*4, CGRectGetMaxY(self.label1.frame), AlertW/5, 40)];
            self.imv5.image=IMAGENAME(@"nei");
            self.imv5.contentMode=UIViewContentModeCenter;
            [self.alertView addSubview:self.imv5];
            
            self.msgLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imv1.frame)+2*XFSpace, AlertW-20, 40)];
            self.msgLbl.numberOfLines=2;
            self.msgLbl.font=XFont(14);
            self.msgLbl.textColor=HEXCOLOR(@"999999");
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.msgLbl];
            
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:message];
            [str setAttributes:@{NSForegroundColorAttributeName:MAINGREEN} range:NSMakeRange(10, 10)];
            self.msgLbl.attributedText = str;
            
        }
    
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+2*XFSpace, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 40);
            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.cancleBtn.tag = AlertButtonTypeCancel;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.cancleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.cancleBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.cancleBtn];
        }
        
        if (cancleTitle && sureTitle) {
            self.verLineView = [[UIView alloc] init];
            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame), 1, 40);
            self.verLineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [self.alertView addSubview:self.verLineView];
        }
        
        if(sureTitle && cancleTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2+1, 40);
            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithRed:6/255.0 green:189/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.sureBtn.tag = AlertButtonTypeSure;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.sureBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.sureBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.sureBtn];
            
        }
        
        //只有取消按钮
        if (cancleTitle && !sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.cancleBtn.tag = AlertButtonTypeCancel;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.cancleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.cancleBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //只有确定按钮
        if(sureTitle && !cancleTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithRed:6/255.0 green:189/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.sureBtn.tag = AlertButtonTypeSure;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.sureBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.sureBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.sureBtn];
            
        }
        
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

#pragma mark - 弹出 -
- (void)showAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - event
- (void)buttonEvent:(UIButton *)sender
{
    if (self.resultIndex) {
        self.resultIndex(sender.tag);
    }
    [self removeFromSuperview];
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
