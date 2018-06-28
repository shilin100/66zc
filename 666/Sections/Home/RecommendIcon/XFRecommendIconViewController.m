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

@property(nonatomic,strong)NSIndexPath* selectedIndex;;


@end

@implementation XFRecommendIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头像";
    self.view.backgroundColor = HEXCOLOR(@"eeeeee");
    self.imgNameArr = @[@"car-1093927_640",@"volkswagen-569315_640",@"cuba-1197800_640",@"morocco-123978_640",@"poppy-3137588_640",@"flower-3421864_960_720",@"alpine-cornflower-3440640_640",@"poppy-3441348_640",@"tree-736875_960_720",@"sunset-3434051_960_720",@"tree-736885_960_720",@"sunset-203188_640"];
    self.imgTitleArr = @[@"复古",@"荒漠",@"酷炫",@"掠影",@"花朵",@"薰衣草",@"小清新",@"花丛",@"草原",@"海平线",@"紫海",@"黄昏"];

    
    UIView * whiteTop = [UIView new];
    whiteTop.backgroundColor = WHITECOLOR;
    [self.view addSubview:whiteTop];
    
    [whiteTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@30);
    }];
    
    UIView * greenCross = [UIView new];
    greenCross.backgroundColor = MAINGREEN;
    [whiteTop addSubview:greenCross];
    
    [greenCross mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteTop.mas_top).offset(4);
        make.bottom.equalTo(whiteTop.mas_bottom).offset(-4);
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(@3);
    }];

    UILabel *defaultRecommend = [[UILabel alloc] init];
    defaultRecommend.font = XBFont(12);
    defaultRecommend.textColor = BlACKTEXT;
    defaultRecommend.numberOfLines = 1;
    defaultRecommend.text = @"默认推荐";
    [whiteTop addSubview:defaultRecommend];
    [defaultRecommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteTop.mas_top).offset(4);
        make.bottom.equalTo(whiteTop.mas_bottom).offset(-4);
        make.left.equalTo(greenCross.mas_left).offset(7);
        make.right.mas_equalTo(@0);
    }];

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//列距
    flowLayout.minimumLineSpacing = 13;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30+2 ,SCREENW, SCREENH-64-30-2) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = GRAYBACKGROUND;
    [_collectionView registerClass:[XFRecommendIconCollectionViewCell class] forCellWithReuseIdentifier:@"XFRecommendIconCollectionViewCell"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = WHITECOLOR;
    [self.view addSubview:_collectionView];

    
    UIButton *loadBtn = [[UIButton alloc] init];
    [loadBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    loadBtn.titleLabel.font = XFont(14);
    loadBtn.layer.cornerRadius = 22;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = MAINGREEN;
    [self.view addSubview:loadBtn];
    [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loadBtn.sd_layout
    .bottomSpaceToView(self.view, 40)
    .leftSpaceToView(self.view, 37)
    .heightIs(40)
    .rightSpaceToView(self.view, 37);

    
}

-(void)loadBtnClick{
    if (self.selectedIndex == nil) {
        [SVProgressHUD showErrorWithStatus:@"请先选择头像再提交。"];
        return;
    }
    if (self.recommendIconBlock) {
        self.recommendIconBlock([UIImage imageNamed:self.imgNameArr[self.selectedIndex.row]]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedIndex != nil) {
        XFRecommendIconCollectionViewCell * selectedCell = (XFRecommendIconCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectedIndex];
        selectedCell.tik.alpha = 0;
    }
    XFRecommendIconCollectionViewCell * cell = (XFRecommendIconCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.tik.alpha = 1;

    self.selectedIndex = indexPath;
    
}


@end
