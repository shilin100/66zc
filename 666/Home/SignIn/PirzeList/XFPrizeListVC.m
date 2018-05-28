//
//  XFPrizeListVC.m
//  666
//
//  Created by 123 on 2018/5/14.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFPrizeListVC.h"
#import "XFPrizeListModel.h"
#import "XFPrizeListCell.h"

@interface XFPrizeListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)    UICollectionView* collectionView;

@property(nonatomic,strong)NSMutableArray * dataArr;;


@end

@implementation XFPrizeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKGROUND;
    self.navigationItem.title = @"奖品明细";

    self.dataArr = [NSMutableArray array];
    
    [self setupUI];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//列距
    flowLayout.minimumLineSpacing = 13;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 ,SCREENW, SCREENH-64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = GRAYBACKGROUND;
    [_collectionView registerClass:[XFPrizeListCell class] forCellWithReuseIdentifier:@"XFPrizeListCell"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

}

- (void) requestData {
    NSMutableDictionary *params = [XFTool getBaseRequestParams];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/prizeList",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] intValue] == 1) {
            self.dataArr = [XFPrizeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.collectionView reloadData];
        }else{
            
        }
        //        NSLog(@"succ:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENW - 30)/2,SCREENW/2*0.618);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"XFPrizeListCell";
    XFPrizeListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    
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
