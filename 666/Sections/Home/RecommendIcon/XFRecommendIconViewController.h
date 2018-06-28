//
//  XFRecommendIconViewController.h
//  666
//
//  Created by 123 on 2018/6/26.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RecommendIconBlock)(UIImage * img);

@interface XFRecommendIconViewController : UIViewController
@property (nonatomic, copy) RecommendIconBlock recommendIconBlock;

@end
