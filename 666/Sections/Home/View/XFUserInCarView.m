//
//  XFUserInCarView.m
//  666
//
//  Created by 123 on 2018/6/11.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFUserInCarView.h"

@implementation XFUserInCarView
{
    UILabel * userTimeLabel;
    UILabel * distanceLabel;
    UILabel * costLabel;
    double startTime;
    NSTimer * timer;
}

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = WHITECOLOR;
        
        
        UILabel * userTimeTitle  = [UILabel new];
        userTimeTitle.text = @"用车时长";
        userTimeTitle.numberOfLines = 1;
        userTimeTitle.textColor = GRAYTEXT;
        userTimeTitle.textAlignment = NSTextAlignmentCenter;
        userTimeTitle.font = XFont(12);
        [self addSubview:userTimeTitle];
        [userTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(19);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.height.mas_equalTo(@20);
        }];

        UILabel * distanceTitle  = [UILabel new];
        distanceTitle.text = @"行驶距离";
        distanceTitle.numberOfLines = 1;
        distanceTitle.textColor = GRAYTEXT;
        distanceTitle.textAlignment = NSTextAlignmentCenter;
        distanceTitle.font = XFont(12);
        [self addSubview:distanceTitle];
        [distanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userTimeTitle.mas_right).with.offset(29);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.height.mas_equalTo(@20);
            make.width.equalTo(userTimeTitle.mas_width);
            
        }];

        UILabel * costTitle  = [UILabel new];
        costTitle.text = @"预计消费";
        costTitle.numberOfLines = 1;
        costTitle.textColor = GRAYTEXT;
        costTitle.textAlignment = NSTextAlignmentCenter;
        costTitle.font = XFont(12);
        [self addSubview:costTitle];
        [costTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(distanceTitle.mas_right).with.offset(29);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.height.mas_equalTo(@20);
            make.width.equalTo(distanceTitle.mas_width);
            make.right.mas_equalTo(@-19);
        }];

        UILabel * userTimeContent  = [UILabel new];
        userTimeContent.numberOfLines = 1;
        userTimeContent.textColor = MAINGREEN;
        userTimeContent.textAlignment = NSTextAlignmentCenter;
        userTimeContent.font = XFont(15);
        [self addSubview:userTimeContent];
        [userTimeContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userTimeTitle.mas_left);
            make.bottom.equalTo(distanceTitle.mas_top).with.offset(0);
            make.height.mas_equalTo(@30);
            make.width.equalTo(distanceTitle.mas_width);
        }];
        userTimeLabel = userTimeContent;

        
        UILabel * distanceContent  = [UILabel new];
        distanceContent.numberOfLines = 1;
        distanceContent.textColor = GRAYTEXT;
        distanceContent.textAlignment = NSTextAlignmentCenter;
        distanceContent.font = XFont(12);
        [self addSubview:distanceContent];
        [distanceContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(distanceTitle.mas_left);
            make.bottom.equalTo(distanceTitle.mas_top).with.offset(0);
            make.height.mas_equalTo(@30);
            make.width.equalTo(distanceTitle.mas_width);
        }];
        distanceLabel = distanceContent;

        UILabel * costContent  = [UILabel new];
        costContent.numberOfLines = 1;
        costContent.textColor = GRAYTEXT;
        costContent.textAlignment = NSTextAlignmentCenter;
        costContent.font = XFont(12);
        [self addSubview:costContent];
        [costContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(costTitle.mas_left);
            make.bottom.equalTo(distanceTitle.mas_top).with.offset(0);
            make.height.mas_equalTo(@30);
            make.width.equalTo(distanceTitle.mas_width);
        }];
        costLabel = costContent;

        
    }
    return self;
}

-(void)setUseTime:(double)usetime Distance:(NSString*)distance Cost:(NSString*)cost{
    NSString * totalDistance = [NSString stringWithFormat:@"%@公里",distance];
    distanceLabel.attributedText = [self differentColor:MAINGREEN string:distance inString:totalDistance];
    
    NSString * totalCost = [NSString stringWithFormat:@"%@元",cost];
    costLabel.attributedText = [self differentColor:MAINGREEN string:cost inString:totalCost];
    
    startTime = usetime;
    userTimeLabel.text = [self getUseTime:startTime];
    
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        userTimeLabel.text = [self getUseTime:startTime];
    } repeats:YES];
             
    
    
}

-(NSMutableAttributedString*)differentColor:(UIColor*)color string:(NSString*)str inString:(NSString*)totalStr{
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    attributeString.color = GRAYTEXT;
    
    NSRange rang = [totalStr rangeOfString:str];
    //设置标签文字属性
    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,XFont(15),NSFontAttributeName, nil] range:rang];
    return attributeString;
}

-(NSString*)getUseTime:(double)time{

    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowtime - time; //时间差
    
    int day = timeInt / (3600 * 24);
    int hour = (timeInt % (3600 * 24)) / 3600;
    int minute = (timeInt % 3600) / 60;
    int second = timeInt % 60 ;
    
    if (minute <= 0) {
        return [NSString stringWithFormat:@"%02d",second];
    }else if(hour <= 0){
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }else if(day <= 0){
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }else{
        return [NSString stringWithFormat:@"%d天%02d:%02d:%02d",day,hour,minute,second];
    }
    

}

-(void)removeFromSuperview{
    [timer invalidate];
    timer = nil;
    [super removeFromSuperview];
}

@end
