//
//  XFHomeChooseContent.m
//  666
//
//  Created by xiaofan on 2017/10/13.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeChooseContent.h"

@interface XFHomeChooseContent ()
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation XFHomeChooseContent

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 标题
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = XFont(12);
        titleLbl.textColor = HEXCOLOR(@"#9a9a9a");
        [self addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        titleLbl.sd_layout
        .topEqualToView(self)
        .leftSpaceToView(self, 20*SCALE_WIDTH)
        .rightEqualToView(self)
        .heightIs(25*SCALE_HEIGHT);
        
        [self setupAutoHeightWithBottomViewsArray:self.subviews bottomMargin:40*SCALE_HEIGHT];
        
    }
    return self;
}
-(void)setSubTitles:(NSArray *)subTitles{
    _subTitles = subTitles;
    
    [self removeAllSubviews];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = self.title;
    titleLbl.font = XFont(12);
    titleLbl.textColor = HEXCOLOR(@"#9a9a9a");
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    titleLbl.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, 20*SCALE_WIDTH)
    .rightEqualToView(self)
    .heightIs(25*SCALE_HEIGHT);
    
    for (int i = 0; i < subTitles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = XFont(12);
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
        [btn setTitle:subTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(@"#545454") forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(@"#02c07d") forState:UIControlStateSelected];
        [btn setBackgroundImage:IMAGENAME(@"chooseItemNormalBG") forState:UIControlStateNormal];
        [btn setBackgroundImage:IMAGENAME(@"chooseItemSelectedBG") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == 0 && self.isFirst) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }else{
            btn.selected = NO;
        }
        
        btn.sd_layout
        .xIs((20+140*(i > 1 ? i%2 : i))*SCALE_WIDTH)
        .topSpaceToView(self.titleLbl, ((22+(i/2)*82)*SCALE_HEIGHT))
        .heightIs(62*SCALE_HEIGHT)
        .widthIs(120*SCALE_WIDTH);
        
    }
    [self setupAutoHeightWithBottomViewsArray:self.subviews bottomMargin:40*SCALE_HEIGHT];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLbl.text = title;
}
- (void) btnClick:(UIButton *)btn{
    
    if(self.isMultiSelect)
    {
        btn.selected = !btn.selected;
        self.selectedBtn = btn;
    }
    else
    {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
        
    }
    
    
    //暂时不用默认选中第一个
//    if (self.selectedBtn == btn) {
//        btn.selected = !btn.selected;
////        self.selectedBtn = nil;
//        if (btn.selected) {
//            self.selectedBtn = btn;
//            return;
//        }else{
//            self.selectedBtn = nil;
//            return;
//        }
//    }
   
    
    if (self.itemblock) {
        self.itemblock(btn.titleLabel.text);
    }
}
-(id)condition{
    
    if(self.isMultiSelect)
    {
        NSMutableArray *arr=[NSMutableArray array];

        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton *)view;
                if (btn.selected) {
                    [arr addObject:btn.titleLabel.text];
                }else{
                    [arr addObject:@""];
                }
            }
        }
        
        return arr;
    }
    else
    {
        if (self.selectedBtn) {
            return self.selectedBtn.titleLabel.text;
        }else{
            return @"";
        }
    }
    
}
@end
