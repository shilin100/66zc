//
//  XFHomeLeftView.h
//  666
//
//  Created by xiaofan on 2017/10/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    leftViewSubTypeIcon = 100,
    leftViewSubTypeOrder,
    leftViewSubTypeWallet,
    leftViewSubTypeTicket,
    leftViewSubTypeSales,
    leftViewSubTypeStudy,
    leftViewSubTypeBreakRules,
//    leftViewSubTypeHelp,
    leftViewSubTypeSetting,
    leftViewSubTypeLogout,
    leftViewSubTypeContact,

} leftViewSubType;

@class XFHomeLeftView;
@protocol XFHomeLeftViewDelegate <NSObject>

@optional
- (void) homeLeftView:(XFHomeLeftView *)leftView didSelectedItem:(UIButton *)sender;

- (void) homeLeftTableView:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath;


@end
@interface XFHomeLeftView : UIView
@property (nonatomic, weak) id<XFHomeLeftViewDelegate> delegate;
@end
