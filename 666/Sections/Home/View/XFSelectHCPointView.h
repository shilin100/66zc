//
//  XFSelectHCPointView.h
//  666
//
//  Created by TDC_MacMini on 2017/11/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFSelectHCPointView;
@protocol XFSelectHCPointViewDelegate <NSObject>

@optional
- (void) SelectHCPointView:(XFSelectHCPointView *)view didSelectedCancelBtn:(UIButton *)sender;
- (void) SelectHCPointView:(XFSelectHCPointView *)view didSelectedSureBtn:(UIButton *)sender;
- (void) SelectHCPointView:(XFSelectHCPointView *)view didSelectedCell:(NSString *)str;

@end


@class XFSelectHCPointModel;
@interface XFSelectHCPointView : UIView

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<XFSelectHCPointModel *> *SelectHCPointModelArr;
@property (nonatomic, weak) id<XFSelectHCPointViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL show;

@end
