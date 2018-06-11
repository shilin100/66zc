//
//  XFScoreDetailController.m
//  666
//
//  Created by xiaofan on 2017/10/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyScoreController.h"
#import "XFScoreDetailController.h"

@interface XFMyScoreController ()
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *usedScoreLbl;

@property (weak, nonatomic) IBOutlet UIImageView *bgImv;


@end

@implementation XFMyScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分";
    self.bgImv.clipsToBounds=YES;
}
- (IBAction)detailBtnClick {
    XFScoreDetailController *vc = [[XFScoreDetailController alloc] init];
    vc.indentifer = @"score";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
