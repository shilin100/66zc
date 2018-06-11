//
//  XFBMKPinAnnotationView.h
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "XFBMKPointAnnotation.h"
#import "XFCarModel.h"

@class XFCarModel;
@interface XFBMKPinAnnotationView : BMKPinAnnotationView
/**carModel*/
@property (nonatomic, strong) XFCarModel *model;

@property (nonatomic,strong) UIImageView *imgView;

-(id)initWithCarAnnotation:(XFBMKPointAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier;

-(void)translateImgOnAnnotation:(XFBMKPointAnnotation *)annotation;

@end
