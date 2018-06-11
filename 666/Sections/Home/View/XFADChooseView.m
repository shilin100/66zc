//
//  XFADChooseView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFADChooseView.h"
#import "HYCollectionViewCell.h"

#define   Sections 100

@interface XFADChooseView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//@property (nonatomic, weak) UIButton *contentBtn;

//现在使用collectionView做无限滑动
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)NSMutableArray * imageArr;

@end

@implementation XFADChooseView

-(instancetype)initWithImageArray:(NSMutableArray *)array{
    if (self = [super init]) {
        
        _imageArr=array;
        [self addTimer];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        
        //广告轮播
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(250,250);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        self.collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 250, 250) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = CLEARCOLOR;
        self.collectionView.layer.cornerRadius=10;
        self.collectionView.clipsToBounds=YES;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.bounces = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerNib:[UINib nibWithNibName:@"HYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collec"];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(250, 250));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPage = 0;
//        _pageControl.currentPageIndicatorTintColor = MAINGREEN;
//        _pageControl.pageIndicatorTintColor = LMColor2(79, 190, 99, 0.5);
        _pageControl.currentPageIndicatorTintColor = LMColor2(48, 192, 136, 1.0);
        _pageControl.pageIndicatorTintColor = LMColor2(125, 125, 125, 1.0);
        [self addSubview:self.pageControl];
        
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.collectionView.mas_centerX);
            make.bottom.equalTo(self.collectionView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        self.pageControl.numberOfPages =_imageArr.count;
        
        
//
//        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [contentBtn sd_setImageWithURL:[NSURL URLWithString:imvUrl] forState:UIControlStateNormal];
////        contentBtn.backgroundColor=WHITECOLOR;
//        contentBtn.layer.cornerRadius = 10;
//        contentBtn.clipsToBounds = YES;
//        [self addSubview:contentBtn];
//        self.contentBtn = contentBtn;
//        [[contentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            if (self.topBlock) {
//                [self hide];
//                self.topBlock();
//            }
//        }];
//
//        [contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(250, 250));
//            make.centerX.equalTo(self.mas_centerX);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
        
        
        // 关闭按钮
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:IMAGENAME(@"guanbi") forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //            [self removeFromSuperview];
            [self hide];
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.collectionView.mas_centerX);
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
            make.height.width.mas_equalTo(@40);
        }];
    
       
    }
    return self;
}
-(void)show{
    CGAffineTransform scale = CGAffineTransformMakeScale(0.5,0.5);
    [self.collectionView setTransform:scale];
    [UIView animateWithDuration:0.1 animations:^{
        self.collectionView.transform = CGAffineTransformIdentity;
    }];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}
- (void) hide {
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform scale = CGAffineTransformMakeScale(0.7,0.7);
        [self.collectionView setTransform:scale];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.1];
        self.collectionView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return Sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"collec" forIndexPath:indexPath];
     item.backgroundColor = CLEARCOLOR;
    [item.titleBtn sd_setBackgroundImageWithURL:_imageArr[indexPath.item] forState:UIControlStateNormal];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topBlock) {
        [self hide];
        self.topBlock(indexPath);
    }
}

#pragma mark - 轮播图

- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:Sections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return currentIndexPathReset;
}

- (void)nextPage
{
    // 显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    // 计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == _imageArr.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    // 通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_imageArr.count>0) {
        
        int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % _imageArr.count;
        
        self.pageControl.currentPage = page;
    }
}


@end
