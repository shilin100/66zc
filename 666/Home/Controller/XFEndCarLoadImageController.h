//
//  XFEndCarLoadImageController.h
//  666
//
//  Created by xiaofan on 2017/10/31.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^endLoadSuccessBlock)();
@interface XFEndCarLoadImageController : UIViewController
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *rid;

/**<#desc#>*/
@property (nonatomic, copy) endLoadSuccessBlock loadBlock;
@end
