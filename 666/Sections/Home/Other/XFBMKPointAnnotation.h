//
//  XFBMKPointAnnotation.h
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@class XFCarModel;
@class XFCarSelectedModel;
@class XFSelectHCPointModel;

@interface XFBMKPointAnnotation : BMKPointAnnotation
/**模型*/
@property (nonatomic, strong) XFCarModel *carModel;
@property (nonatomic, strong) XFCarSelectedModel *CarSelectedModel;
@property (nonatomic, strong) XFSelectHCPointModel *HCPointModel;
@end
