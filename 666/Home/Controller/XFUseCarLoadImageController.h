//
//  XFUseCarLoadImageController.h
//  666
//
//  Created by xiaofan on 2017/10/26.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadImageSuccessBlock)();
@interface XFUseCarLoadImageController : UIViewController
@property (nonatomic, copy) NSString *cid;


@property (nonatomic, copy)loadImageSuccessBlock successBlock;

@end
