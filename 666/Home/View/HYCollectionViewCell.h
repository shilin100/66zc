//
//  HYCollectionViewCell.h
//  HouseCow
//
//  Created by 刘杰 on 15/11/30.
//  Copyright © 2015年 HYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIButton *titleBtn;

@property(nonatomic,assign)BOOL state;


@end
