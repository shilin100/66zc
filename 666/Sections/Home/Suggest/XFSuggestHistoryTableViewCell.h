//
//  XFSuggestHistoryTableViewCell.h
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSuggestModel.h"

@interface XFSuggestHistoryTableViewCell : UITableViewCell

@property(nonatomic,strong)XFSuggestModel * model;

@property(nonatomic,weak)UILabel * replyDate;
@property(nonatomic,weak)UILabel * isReplySign;
@property(nonatomic,weak)UILabel * replyContent;
@property(nonatomic,weak)UILabel * uploadDate;
@property(nonatomic,weak)UILabel * uploadContent;



@end
