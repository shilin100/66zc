//
//  XFMyRankView.h
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMyRankView : UIView
@property(nonatomic,weak)UILabel * contentLabel;
@property(nonatomic,weak)UILabel * rankLabel;
@property(nonatomic,weak)UILabel * detailLabel;
@property(nonatomic,weak)UIImageView * icon;
@property(nonatomic,weak)UIImageView * rankImg;

-(void)setParams:(NSDictionary*)params RankType:(int)ranktype;


@end
