//
//  XFBMKPointAnnotation.m
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFBMKPointAnnotation.h"
#import "XFCarModel.h"
#import "XFCarSelectedModel.h"
#import "XFSelectHCPointModel.h"

@implementation XFBMKPointAnnotation
-(void)setCarModel:(XFCarModel *)carModel{
    _carModel = carModel;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [carModel.latitude floatValue];
    coor.longitude = [carModel.longtitude floatValue];
    self.coordinate = coor;
}

-(void)setCarSelectedModel:(XFCarSelectedModel *)CarSelectedModel{
    _CarSelectedModel = CarSelectedModel;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [CarSelectedModel.latitude floatValue];
    coor.longitude = [CarSelectedModel.longtitude floatValue];
    self.coordinate = coor;
}

-(void)setHCPointModel:(XFSelectHCPointModel *)HCPointModel{
    _HCPointModel = HCPointModel;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [HCPointModel.latitude floatValue];
    coor.longitude = [HCPointModel.longtitude floatValue];
    self.coordinate = coor;
}

@end
