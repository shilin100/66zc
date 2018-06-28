//
//  XFSuggestHistoryTableViewCell.m
//  666
//
//  Created by 123 on 2018/6/25.
//  Copyright © 2018年 xiaofan. All rights reserved.
//

#import "XFSuggestHistoryTableViewCell.h"

@implementation XFSuggestHistoryTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * garyTop = [[UIView alloc]init];
        garyTop.backgroundColor = HEXCOLOR(@"#eeeeee");
        [self addSubview:garyTop];
        
        [garyTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.height.mas_equalTo(@30);
        }];
        
        UILabel* replyDate = [UILabel new];
        replyDate.font = XFont(12);
        replyDate.textColor = BlACKTEXT;
        [garyTop addSubview:replyDate];
        self.replyDate = replyDate;
        
        replyDate.sd_layout
        .centerYEqualToView(garyTop)
        .widthIs(150)
        .leftSpaceToView(garyTop, 11)
        .heightIs(30);
        

        UILabel* isReplySign = [UILabel new];
        isReplySign.font = XFont(10);
        isReplySign.textAlignment = NSTextAlignmentRight;
        isReplySign.textColor = GRAYTEXT;
        [garyTop addSubview:isReplySign];
        self.isReplySign = isReplySign;
        
        isReplySign.sd_layout
        .centerYEqualToView(garyTop)
        .widthIs(150)
        .rightSpaceToView(garyTop, 11)
        .heightIs(30);

        
        UILabel* uploadContent = [UILabel new];
        uploadContent.numberOfLines = 0;
        uploadContent.font = XBFont(12);
        uploadContent.textColor = BlACKTEXT;
        [self addSubview:uploadContent];
        self.uploadContent = uploadContent;
        

        [uploadContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(garyTop.mas_bottom).offset(13);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-22);

        }];

        
        UILabel* replyContent = [UILabel new];
        replyContent.numberOfLines = 0;
        replyContent.font = XFont(9);
        replyContent.textColor = GRAYTEXT;
        [self addSubview:replyContent];
        self.replyContent = replyContent;
        
        [replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(uploadContent.mas_bottom).offset(16);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-22);
            
        }];

        
        UILabel* uploadDate = [UILabel new];
        uploadDate.font = XFont(10);
        uploadDate.textColor = GRAYTEXT;
        uploadDate.textAlignment = NSTextAlignmentRight;
        [self addSubview:uploadDate];
        self.uploadDate = uploadDate;
        

        [uploadDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(replyContent.mas_bottom).offset(4);
            make.bottom.equalTo(self).offset(-8);
            make.right.equalTo(self).offset(-10);
            make.width.mas_equalTo(@150);
            make.height.mas_equalTo(@9);
        }];

    }
    
    return self;
}

-(void)setModel:(XFSuggestModel *)model{
    _model = model;
    self.replyDate.text = model.status == 1 ? model.admintime : @"最近";
    self.isReplySign.text = model.status == 1 ? @"已回复" : @"未回复";
    self.uploadDate.text = model.usertime;
    self.uploadContent.text = model.usercontent;
    
    self.replyContent.text = model.status ? [NSString stringWithFormat:@"回复:%@",model.revertcontent] : @"";
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
