//
//  XFCustomAnnotationView.h
//  666
//
//  Created by 123 on 2018/5/19.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface XFCustomAnnotationView : BMKPinAnnotationView

@property (nonatomic,strong) UIImageView * customImg;

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
