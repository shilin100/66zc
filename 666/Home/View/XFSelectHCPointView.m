//
//  XFSelectHCPointView.m
//  666
//
//  Created by TDC_MacMini on 2017/11/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFSelectHCPointView.h"
#import "XFSelectHCPointTableViewCell.h"
#import "XFSelectHCPointModel.h"

@interface XFSelectHCPointView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIButton *sureBtn;



@end


@implementation XFSelectHCPointView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        cancelBtn.titleLabel.font = XFont(15);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//        [cancelBtn setBackgroundColor:WHITECOLOR];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(50, 40));
            
        }];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        sureBtn.titleLabel.font = XFont(15);
        [sureBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [sureBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//        [sureBtn setBackgroundColor:WHITECOLOR];
        [sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        self.sureBtn = sureBtn;
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(90, 40));
            
        }];
        
        //tableview
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        [self addSubview:tableView];
        self.tableView = tableView;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancelBtn.mas_bottom).offset(5*SCALE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
    
    
    }
    return self;
}

#pragma mark ----- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SelectHCPointModelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cell_id=@"cell_id";
    XFSelectHCPointTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if(!cell)
    {
        cell=[[XFSelectHCPointTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    
    cell.details_address =_SelectHCPointModelArr[indexPath.row].details_address;
    cell.label.text=_SelectHCPointModelArr[indexPath.row].title;
    cell.subLabel.text=_SelectHCPointModelArr[indexPath.row].address;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
   if(_show)
   {
       if(indexPath==_indexPath)
       {
           cell.label.textColor=MAINGREEN;
           cell.subLabel.textColor=MAINGREEN;
           _show=NO;
       }
   }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [tableView visibleCells];
    for (XFSelectHCPointTableViewCell *cell in array) {
        cell.label.textColor=HEXCOLOR(@"999999");
        cell.subLabel.textColor=HEXCOLOR(@"999999");
    }
    
    XFSelectHCPointTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.label.textColor=MAINGREEN;
    cell.subLabel.textColor=MAINGREEN;
    
    //暂时不要回调功能
    NSString *str=[NSString stringWithFormat:@"%@%@",cell.subLabel.text,cell.details_address];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectHCPointView:didSelectedCell:)]) {
        [self.delegate SelectHCPointView:self didSelectedCell:str];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XFSelectHCPointTableViewCell *cel=(XFSelectHCPointTableViewCell *)cell;
    NSIndexPath *index=[tableView indexPathForSelectedRow];
    
    if (index.row==indexPath.row && index!=nil)
    {
        cel.label.textColor=MAINGREEN;
        cel.subLabel.textColor=MAINGREEN;
    }
    else
    {
        cel.label.textColor=HEXCOLOR(@"999999");
        cel.subLabel.textColor=HEXCOLOR(@"999999");
    }
}

- (void) didClickCancelBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectHCPointView:didSelectedCancelBtn:)]) {
        [self.delegate SelectHCPointView:self didSelectedCancelBtn:sender];
    }
}

-(void)didClickSureBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectHCPointView:didSelectedSureBtn:)]) {
        [self.delegate SelectHCPointView:self didSelectedSureBtn:sender];
    }
}



@end
