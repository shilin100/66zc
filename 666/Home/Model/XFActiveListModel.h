//
//  XFActiveListModel.h
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFActiveListModel : NSObject

@property (nonatomic, copy) NSString *activeId;
@property (nonatomic , copy) NSString              * end_time;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * overdue_info;

@end
