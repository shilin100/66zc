//
//  XFSignInModel.h
//  666
//
//  Created by 123 on 2018/5/11.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFSignInModel : NSObject
@property (nonatomic , copy) NSString              * signtimes;
@property (nonatomic , copy) NSString              * signdatetime;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              scrapnumber;
@property (nonatomic , copy) NSString              * requestsnum;
@property (nonatomic , copy) NSString              * scrapingnum;
@property (nonatomic , copy) NSString              * makescrapnum;

@end
