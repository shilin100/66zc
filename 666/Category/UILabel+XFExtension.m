//
//  UILabel+XFExtension.m
//  666
//
//  Created by xiaofan on 2017/10/23.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "UILabel+XFExtension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (XFExtension)
- (void)changeAlignmentRightandLeft {
    
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil];
    
    CGFloat margin = (self.frame.size.width - textSize.size.width) / (self.text.length - 1);
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeString;
    
}
@end
