//
//  XFAppluNowCell.h
//  666
//
//  Created by 123 on 2018/5/8.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XFAppluNowCell : UITableViewCell

@property(nonatomic,strong)UILabel* title;
@property(nonatomic,strong)UITextField* textField;

-(void)setTitle:(NSString*)title placeholder:(NSString*)placeholder;

@end
