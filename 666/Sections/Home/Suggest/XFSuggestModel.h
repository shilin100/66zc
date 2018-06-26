//
//  XFSuggestModel.h
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFSuggestModel : NSObject
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * admintime;
@property (nonatomic , copy) NSString              * usertime;
@property (nonatomic , copy) NSString              * usercontent;
@property (nonatomic , copy) NSString              * revertcontent;

@end
