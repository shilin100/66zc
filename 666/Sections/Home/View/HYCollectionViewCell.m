//
//  HYCollectionViewCell.m
//  HouseCow
//
//  Created by 刘杰 on 15/11/30.
//  Copyright © 2015年 HYKJ. All rights reserved.
//

#import "HYCollectionViewCell.h"

@implementation HYCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.titleBtn.userInteractionEnabled = NO;
    self.titleBtn.layer.cornerRadius = 10;
    self.titleBtn.clipsToBounds = YES;
    
}


@end
