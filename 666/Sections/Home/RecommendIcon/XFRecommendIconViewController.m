//
//  XFRecommendIconViewController.m
//  666
//
//  Created by 123 on 2018/6/26.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFRecommendIconViewController.h"
#import "XFRecommendIconCollectionViewCell.h"

@interface XFRecommendIconViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)    UICollectionView* collectionView;

@property(nonatomic,strong)NSArray * imgTitleArr;;
@property(nonatomic,strong)NSArray * imgNameArr;;


@end

@implementation XFRecommendIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头像";
    self.view.backgroundColor = HEXCOLOR(@"eeeeee");
    self.imgNameArr = @[@"car-1093927_640",@"volkswagen-569315_640",@"cuba-1197800_640",@"morocco-123978_640",@"poppy-3137588_640",@"flower-3421864_960_720",@"alpine-cornflower-3440640_640",@"poppy-3441348_640",@"tree-736875_960_720",@"sunset-3434051_960_720",@"tree-736885_960_720",@"sunset-203188_640"];
    self.imgTitleArr = @[@"复古",@"荒漠",@"酷炫",@"掠影",@"花朵",@"薰衣草",@"小清新",@"花丛",@"草原",@"海平线",@"紫海",@"黄昏"];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//列距
    flowLayout.minimumLineSpacing = 13;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 ,SCREENW, SCREENH-64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = GRAYBACKGROUND;
    [_collectionView registerClass:[XFRecommendIconCollectionViewCell class] forCellWithReuseIdentifier:@"XFRecommendIconCollectionViewCell"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgNameArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENW - 30)/4,85);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"XFRecommendIconCollectionViewCell";
    XFRecommendIconCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.icon.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    cell.titleLabel.text = self.imgTitleArr[indexPath.row];
    return cell;
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


@end
