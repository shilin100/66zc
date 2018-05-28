//
//  XFBMKPinAnnotationView.m
//  666
//
//  Created by xiaofan on 2017/10/10.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFBMKPinAnnotationView.h"

@implementation XFBMKPinAnnotationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
//-(XFCarModel *)model{
//    return self.model;
//}

-(id) initWithCarAnnotation:(XFBMKPointAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, 40, 40);
        [self imgView];
        _imgView.transform = CGAffineTransformMakeRotation(self.model.angle.floatValue);
//        self.markName = annotation.name;
    }
    return self;
}

-(void)translateImgOnAnnotation:(XFBMKPointAnnotation *)annotation {
    _imgView.transform = CGAffineTransformMakeRotation(self.model.angle.floatValue);
}

-(UIImageView *)imgView{
    if(_imgView==nil) {
        
        _imgView= [[UIImageView
                    alloc]initWithFrame:CGRectMake(0,0,40,40)];
        
        if (self.model.status == 0) {
            _imgView.image = IMAGENAME(@"marker_useable_car");
        }else{
            if (self.model.userstatus==2) {
                _imgView.image = IMAGENAME(@"marker_using_car");
            }else{
                _imgView.image = IMAGENAME(@"marker_maintain_car");
            }
            
        }

        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.userInteractionEnabled = NO;
        [self addSubview:_imgView];
    }
    return _imgView;
}



@end
