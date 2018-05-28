//
//  XFCustomAnnotationView.m
//  666
//
//  Created by 123 on 2018/5/19.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFCustomAnnotationView.h"

@implementation XFCustomAnnotationView

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, 40, 40);
        [self imgView];
    }
    return self;

}

-(UIImageView *)imgView{
    if(_customImg==nil) {
        
        _customImg= [[UIImageView
                    alloc]initWithFrame:CGRectMake(-20,0,40,40)];
        
        _customImg.contentMode = UIViewContentModeCenter;
        _customImg.userInteractionEnabled = NO;
        [self addSubview:_customImg];
    }
    return _customImg;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                return isInside;
        }
    }
    return isInside;
}

@end
