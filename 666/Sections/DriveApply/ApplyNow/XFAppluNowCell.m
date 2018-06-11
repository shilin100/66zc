//
//  XFAppluNowCell.m
//  666
//
//  Created by 123 on 2018/5/8.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFAppluNowCell.h"
#import "UILabel+XFExtension.h"

@implementation XFAppluNowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTextTypeUI];
    }
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    return self;
}



-(void)setupTextTypeUI{
    UIView * rowLine = [[UIView alloc]init];
    rowLine.backgroundColor = HEXCOLOR(@"#eeeeee");
    [self.contentView addSubview:rowLine];
    rowLine.sd_layout
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    UILabel *nameTitle = [[UILabel alloc] init];
    nameTitle.font = XFont(14);
    nameTitle.textColor = BlACKTEXT;
    [self.contentView addSubview:nameTitle];
    self.title = nameTitle;

    nameTitle.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .widthIs(70);
//    [nameTitle changeAlignmentRightandLeft];
    
    UITextField *nameTF  = [[UITextField alloc] init];
    nameTF.font = XFont(14);
    nameTF.textColor = HEXCOLOR(@"#333333");
    [self.contentView addSubview:nameTF];
    self.textField = nameTF;
    
    nameTF.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(nameTitle, 10)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 10);


}

-(void)setTitle:(NSString*)title placeholder:(NSString*)placeholder{
    self.title.text = title;
    self.textField.placeholder = placeholder;
}

@end
