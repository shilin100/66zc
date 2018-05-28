//
//  XFHomeChooseContent.h
//  666
//
//  Created by xiaofan on 2017/10/13.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemBlock)(NSString *string);
typedef void(^aaa)();

@interface XFHomeChooseContent : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *subTitles;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, copy) itemBlock itemblock;
@property (nonatomic, copy, readonly) NSString *condition;
@property (nonatomic, assign) BOOL isMultiSelect;




@end
