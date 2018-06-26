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
        [self.contentView addSubview:garyTop];
        garyTop.sd_layout
        .topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(27);
        
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

        
        UIView * whiteContent = [[UIView alloc]init];
        whiteContent.backgroundColor = WHITECOLOR;
        [self.contentView addSubview:whiteContent];
        whiteContent.sd_layout
        .topSpaceToView(garyTop, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        
        UILabel* uploadContent = [UILabel new];
        uploadContent.numberOfLines = 2;
        uploadContent.font = XBFont(12);
        uploadContent.textColor = BlACKTEXT;
        [whiteContent addSubview:uploadContent];
        self.uploadContent = uploadContent;
        
        uploadContent.sd_layout
        .topSpaceToView(whiteContent, 13)
        .leftSpaceToView(whiteContent, 10)
        .rightSpaceToView(whiteContent, 22)
        .heightIs(35);

        
        UILabel* replyContent = [UILabel new];
        replyContent.numberOfLines = 2;
        replyContent.font = XFont(9);
        replyContent.textColor = GRAYTEXT;
        [whiteContent addSubview:replyContent];
        self.replyContent = replyContent;
        
        replyContent.sd_layout
        .topSpaceToView(uploadContent, 0)
        .leftSpaceToView(whiteContent, 10)
        .rightSpaceToView(whiteContent, 22)
        .heightIs(34);

        
        UILabel* uploadDate = [UILabel new];
        uploadDate.font = XFont(10);
        uploadDate.textColor = GRAYTEXT;
        uploadDate.textAlignment = NSTextAlignmentRight;
        [whiteContent addSubview:uploadDate];
        self.uploadDate = uploadDate;
        
        uploadDate.sd_layout
        .bottomSpaceToView(whiteContent, 8)
        .widthIs(150)
        .rightSpaceToView(whiteContent, 10)
        .heightIs(9);

        
    }
    
    return self;
}

-(void)setModel:(XFSuggestModel *)model{
    _model = model;
    self.replyDate.text = model.status == 1 ? model.admintime : @"最近";
    self.isReplySign.text = model.status == 1 ? @"已回复" : @"未回复";
    self.uploadDate.text = model.usertime;
    self.uploadContent.text = model.usercontent;
    
    self.replyContent.text = [NSString stringWithFormat:@"回复:%@",model.revertcontent];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:2];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.firstLineHeadIndent = 1;
//    style.lineSpacing = 1;
//
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.revertcontent  dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:9.0f],NSParagraphStyleAttributeName:style } documentAttributes:nil error:nil];
//
//    self.replyContent.attributedText = attrStr;
//    self.replyContent.font = XFont(9);
//    self.replyContent.numberOfLines = 2;
//
//    [self.replyContent sizeToFit];
    

    self.replyContent.sd_layout
    .heightIs(model.status == 1 ? 29 : 0);
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
